Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E9E311973;
	Sat, 14 Feb 2026 21:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104422; cv=none; b=YB5aBpKYEBaf5CvIcilrVslh5Z6MN5OC7bIsuusyr4VM8P8gs2c6jBz0BV0Z6tbY5Z7xqw61ycJm4k2mXsjLpUUyEGTr94pRnlxi9Uq3hHk8lX+sCMZcWAVbtSD6inx7XB39XgunmPhq7Ze8YYZSkqf0KietuDOPHFQ2rf9KPmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104422; c=relaxed/simple;
	bh=8L+DMnx/20OxLSRvf4GM28MXZp+E9GgiShWJazuo+cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NnT+ECJbeIkdLOSkDw6PWWKJaHgL30ombpWMU4WqE8J9HQiSK9DxrgpFXSrdnLLrtIf9zvD/FKS7ihr7gMFUBbFRTLyqIDd5imESx4cvD/5PirYU2Bhv+Q1XlCkgPv9BGnOE41ZjXRDxBD8wzT1qtM8qdn8afaMddn3KzgzqORc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGUm3mgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGUm3mgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AEDC16AAE;
	Sat, 14 Feb 2026 21:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104421;
	bh=8L+DMnx/20OxLSRvf4GM28MXZp+E9GgiShWJazuo+cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGUm3mgIWxi0VjB8MbSESMERyj1ecmHHrW0SHmTJLXfyFu7f6tcg+a216e3G4KkIB
	 OZ23//XsuL/hLzGaH++31zo0h13Da2CRcav8z7ASzIr3b3q2mIf4/DP4TQDfjGGuem
	 cMSeRTIhjiMaOVyb9oj5Sylb3UaZCIItp3kAtMNuF4/DoOSUrWHpoDsAtqOIVxN3zV
	 rYvW8FhNrlnrmNsYr2TEh/hufmVDV7vZ5Cf64B204TAkicnUfGiAD7EzZ+Fd2dIumR
	 awMc2JjOeSC7h8yQzXYJkzHkltliDMK3syAB2N3NxrOwbV5+TxfbBen+L0ispm3Qjh
	 QcYTqPZwWh0qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pavan.chebbi@broadcom.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] bnxt_en: Allow ntuple filters for drops
Date: Sat, 14 Feb 2026 16:23:41 -0500
Message-ID: <20260214212452.782265-76-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joe Damato <joe@dama.to>

[ Upstream commit 61cef6454cfbb9fcdbe41401fb53895f86603081 ]

It appears that in commit 7efd79c0e689 ("bnxt_en: Add drop action
support for ntuple"), bnxt gained support for ntuple filters for packet
drops.

However, support for this does not seem to work in recent kernels or
against net-next:

  % sudo ethtool -U eth0 flow-type udp4 src-ip 1.1.1.1 action -1
    rmgr: Cannot insert RX class rule: Operation not supported
    Cannot insert classification rule

The issue is that the existing code uses ethtool_get_flow_spec_ring_vf,
which will return a non-zero value if the ring_cookie is set to
RX_CLS_FLOW_DISC, which then causes bnxt_add_ntuple_cls_rule to return
-EOPNOTSUPP because it thinks the user is trying to set an ntuple filter
for a vf.

Fix this by first checking that the ring_cookie is not RX_CLS_FLOW_DISC.

After this patch, ntuple filters for drops can be added:

  % sudo ethtool -U eth0 flow-type udp4 src-ip 1.1.1.1 action -1
  Added rule with ID 0

  % ethtool -n eth0
  44 RX rings available
  Total 1 rules

  Filter: 0
      Rule Type: UDP over IPv4
      Src IP addr: 1.1.1.1 mask: 0.0.0.0
      Dest IP addr: 0.0.0.0 mask: 255.255.255.255
      TOS: 0x0 mask: 0xff
      Src port: 0 mask: 0xffff
      Dest port: 0 mask: 0xffff
      Action: Drop

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260131003042.2570434-1-joe@dama.to
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit fixes a bug where ntuple filters for packet drops (`action
-1` / `RX_CLS_FLOW_DISC`) don't work on bnxt_en network devices, despite
support being added in commit 7efd79c0e689. The user gets `-EOPNOTSUPP`
when trying to add a drop rule via ethtool. The commit message is clear,
includes a reproducer, and shows the fix working.

### Code Change Analysis

The fix is small and surgical, modifying a single file
(`bnxt_ethtool.c`) with minimal changes:

1. **The core bug**: When `ring_cookie` is set to `RX_CLS_FLOW_DISC`
   (indicating a drop action), the old code calls
   `ethtool_get_flow_spec_ring_vf(fs->ring_cookie)` which returns a non-
   zero value for `RX_CLS_FLOW_DISC`. This causes the function to
   incorrectly return `-EOPNOTSUPP`, thinking the user is trying to set
   a VF filter.

2. **The fix**: Check if `ring_cookie == RX_CLS_FLOW_DISC` first. If it
   is, skip the VF check entirely (drops don't target a VF or ring). The
   FLOW_MAC_EXT/FLOW_EXT check is also separated out for clarity.

3. **Additional cleanup**: The `ring` variable is removed;
   `ethtool_get_flow_spec_ring()` is now called inline only in the else
   branch (when it's not a drop action), which is correct since drop
   actions don't need a ring number. The `vf` variable is also removed
   since it's only used in the condition now.

### Bug Classification

This is a **real bug fix** — a feature that was intentionally added
(drop action support for ntuple filters) is broken and returns an error
to users. The `ethtool_get_flow_spec_ring_vf()` function misinterprets
`RX_CLS_FLOW_DISC` (which is `(u64)-1` / all bits set) as containing VF
information, since the VF bits are part of the upper bits of
`ring_cookie`.

### Scope and Risk Assessment

- **Lines changed**: Very small — a few lines of logic restructuring in
  one function
- **Files touched**: 1 file (`bnxt_ethtool.c`)
- **Risk**: Very low. The change only affects the ntuple filter add
  path. The logic is straightforward:
  - If `ring_cookie == RX_CLS_FLOW_DISC`, skip the VF check (correct,
    drops don't have a VF)
  - Otherwise, check for VF as before
  - The ring extraction is moved to where it's actually used (the non-
    drop path)
- **Could it break something?**: Extremely unlikely. The only behavioral
  change is that drop rules now work instead of being rejected. Non-drop
  rules follow the same logic as before.

### User Impact

- **Who is affected**: Users of Broadcom bnxt_en network adapters (very
  common in data center/enterprise environments) who want to use ethtool
  ntuple filters for packet drops
- **Severity**: Medium — the feature is completely broken, returning
  `-EOPNOTSUPP`
- **Workaround**: None apparent — the drop action simply doesn't work

### Stability Indicators

- **Reviewed-by**: Michael Chan (Broadcom maintainer for bnxt)
- **Accepted by**: Jakub Kicinski (net maintainer)
- The fix is obviously correct from reading the code

### Dependency Check

The fix is self-contained. It modifies existing code in `bnxt_ethtool.c`
that has been present since commit 7efd79c0e689 was merged. No
dependencies on other patches.

### Stable Criteria Assessment

1. **Obviously correct and tested**: Yes — reviewed by subsystem
   maintainer, clear logic
2. **Fixes a real bug**: Yes — ntuple drop filters are broken, returning
   EOPNOTSUPP
3. **Important issue**: Moderate — broken network filtering feature on a
   widely-used NIC driver
4. **Small and contained**: Yes — minimal changes to one function in one
   file
5. **No new features**: Correct — this restores functionality that was
   intended but broken
6. **Applies cleanly**: Should apply to any stable tree that has commit
   7efd79c0e689

This is a clear bug fix that restores broken functionality in a widely-
used network driver. The fix is small, obviously correct, reviewed by
the subsystem maintainer, and carries minimal risk.

**YES**

 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 068e191ede19e..c76a7623870be 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1346,16 +1346,17 @@ static int bnxt_add_ntuple_cls_rule(struct bnxt *bp,
 	struct bnxt_l2_filter *l2_fltr;
 	struct bnxt_flow_masks *fmasks;
 	struct flow_keys *fkeys;
-	u32 idx, ring;
+	u32 idx;
 	int rc;
-	u8 vf;
 
 	if (!bp->vnic_info)
 		return -EAGAIN;
 
-	vf = ethtool_get_flow_spec_ring_vf(fs->ring_cookie);
-	ring = ethtool_get_flow_spec_ring(fs->ring_cookie);
-	if ((fs->flow_type & (FLOW_MAC_EXT | FLOW_EXT)) || vf)
+	if (fs->flow_type & (FLOW_MAC_EXT | FLOW_EXT))
+		return -EOPNOTSUPP;
+
+	if (fs->ring_cookie != RX_CLS_FLOW_DISC &&
+	    ethtool_get_flow_spec_ring_vf(fs->ring_cookie))
 		return -EOPNOTSUPP;
 
 	if (flow_type == IP_USER_FLOW) {
@@ -1481,7 +1482,7 @@ static int bnxt_add_ntuple_cls_rule(struct bnxt *bp,
 	if (fs->ring_cookie == RX_CLS_FLOW_DISC)
 		new_fltr->base.flags |= BNXT_ACT_DROP;
 	else
-		new_fltr->base.rxq = ring;
+		new_fltr->base.rxq = ethtool_get_flow_spec_ring(fs->ring_cookie);
 	__set_bit(BNXT_FLTR_VALID, &new_fltr->base.state);
 	rc = bnxt_insert_ntp_filter(bp, new_fltr, idx);
 	if (!rc) {
-- 
2.51.0

