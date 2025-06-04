Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B867D221FBC;
	Wed,  4 Jun 2025 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998608; cv=none; b=uRJNFsr9JhmyAqXBboylkAwEYaaG9UaF9Lw92q+E6tfehNli/gDGDiJrFoNGu7YYNHoJ2BPqUofLIteWqMxVCqR+LVPAFuaVBZMA+l1e8iFlCF4T7ckifPFzukeZe/4cj+qB2lr45P7gT7zvunQlCUt1QhmRcGRNyDRellw7IB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998608; c=relaxed/simple;
	bh=f2krVlrhkGcfJNfBsZoQMnWPwWv4KUdrcZNltF+kAjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fHinz0Vbv6uVOj0FyBfG78QUCkh6sM50qctbJfRsZ79ZWu/dDwbvKjIsHT8toUc8OFUtM7wjU2bYfmIlDPVfoi8WRVLVnSkV6DRvDiS2HDxA2NwbvMpMJ07rL77+yzDmQ3hrawLAPZGXbxo8BYr5ESwCJr9/YBphMxlCPOSEa68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKNzLzFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKNzLzFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595E8C4CEF1;
	Wed,  4 Jun 2025 00:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998608;
	bh=f2krVlrhkGcfJNfBsZoQMnWPwWv4KUdrcZNltF+kAjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKNzLzFf255AF90NqgHlOhsnY7uhQfa0s8pfKthqqfB8Gt/BZVWVIYLhxOdaMl816
	 9ZdwErFL+3O4mEbsn+1oFYSELjhrIpOxhQo+tpG0ZoWuk1dCCicIdwT+f4D7m1AZk8
	 DJj+eVitr9Cyc4PWgVT/PODbQiFgNUEqkwFxBLH4BeVho7EXGC8Hs+Sc0aCmMmGw/+
	 hODXwSJbEMvDTYYmX9cePXbO/N3VG0qThbpi7XQouOscGP8IY5+5Js02ZBAjSkg8B/
	 NTXYtKeARjsIPVYpZmatOCGXZwfET0nITDUwSTnUpKrFgOV8GuN16H1hhbet3iVzp6
	 yx6259KPDyibg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 039/108] xfrm: validate assignment of maximal possible SEQ number
Date: Tue,  3 Jun 2025 20:54:22 -0400
Message-Id: <20250604005531.4178547-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e86212b6b13a20c5ad404c5597933f57fd0f1519 ]

Users can set any seq/seq_hi/oseq/oseq_hi values. The XFRM core code
doesn't prevent from them to set even 0xFFFFFFFF, however this value
will cause for traffic drop.

Is is happening because SEQ numbers here mean that packet with such
number was processed and next number should be sent on the wire. In this
case, the next number will be 0, and it means overflow which causes to
(expected) packet drops.

While it can be considered as misconfiguration and handled by XFRM
datapath in the same manner as any other SEQ number, let's add
validation to easy for packet offloads implementations which need to
configure HW with next SEQ to send and not with current SEQ like it is
done in core code.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Bug Analysis The commit addresses a **user
input validation bug** in the XFRM (IPsec transformation) subsystem.
Specifically: 1. **Root Cause**: Users can set sequence numbers (`seq`,
`seq_hi`, `oseq`, `oseq_hi`) to `0xFFFFFFFF` (U32_MAX) via netlink
interface 2. **Problem**: When a sequence number is set to U32_MAX, the
next packet will have sequence number 0, which triggers sequence number
overflow detection and causes packet drops 3. **Impact**: This leads to
**immediate traffic disruption** for IPsec connections ## Code Changes
Analysis The fix adds **comprehensive input validation** in
`net/xfrm/xfrm_user.c:verify_replay()`: ### For Non-ESN Mode (32-bit
sequences): - **Output SA**: Validates `rs->oseq != U32_MAX` (lines
189-195) - **Input SA**: Validates `rs->seq != U32_MAX` (lines 223-228)
### For ESN Mode (64-bit sequences): - **Output SA**: Validates
`!(rs->oseq == U32_MAX && rs->oseq_hi == U32_MAX)` (lines 196-202) -
**Input SA**: Validates `!(rs->seq == U32_MAX && rs->seq_hi == U32_MAX)`
(lines 230-236) ## Why This Should Be Backported ### 1. **Fixes User-
Visible Bug** This prevents user misconfiguration from causing immediate
IPsec traffic failure, which is a critical networking bug. ### 2.
**Small, Contained Fix** - **Single file modified**:
`net/xfrm/xfrm_user.c` - **Only 42 insertions, 10 deletions** - **Pure
input validation** - no algorithmic or architectural changes - **Low
regression risk** - only rejects previously invalid configurations ###
3. **Benefits Hardware Offload** The commit message explicitly mentions
this helps "packet offloads implementations which need to configure HW
with next SEQ to send." This is increasingly important as IPsec hardware
offload becomes more common. ### 4. **Follows Historical Pattern**
Looking at similar commits in the reference examples: - **Similar Commit
#1** (Status: NO) - Only validates ESN vs non-ESN mode consistency -
**Current commit** - **More comprehensive**, validates against the
problematic U32_MAX boundary that causes actual packet drops - **Similar
Commits #3-5** (Status: YES) - All fix sequence number handling bugs
that cause packet drops/corruption ### 5. **Clear Error Messages** The
fix provides descriptive error messages via `NL_SET_ERR_MSG()`,
improving debuggability for users. ### 6. **Builds on Previous Work**
This extends the validation framework established in commit
`e3aa43a50a64` ("xfrm: prevent high SEQ input in non-ESN mode"), showing
this is part of ongoing hardening efforts. ## Risk Assessment **Minimal
Risk**: - **No functional changes** to existing working configurations -
**Only affects invalid configurations** that would cause problems anyway
- **Well-tested code path** (input validation in userspace interface) -
**Conservative approach** - rejects edge case that causes guaranteed
failure The fix prevents a **user-triggerable traffic failure
condition** with minimal code changes and no risk to existing working
setups. This perfectly fits stable tree criteria: important bug fix, low
risk, contained scope.

 net/xfrm/xfrm_user.c | 52 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b5266e0848e82..dd5fd42341d7b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -178,11 +178,27 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 				       "Replay seq and seq_hi should be 0 for output SA");
 			return -EINVAL;
 		}
-		if (rs->oseq_hi && !(p->flags & XFRM_STATE_ESN)) {
-			NL_SET_ERR_MSG(
-				extack,
-				"Replay oseq_hi should be 0 in non-ESN mode for output SA");
-			return -EINVAL;
+
+		if (!(p->flags & XFRM_STATE_ESN)) {
+			if (rs->oseq_hi) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay oseq_hi should be 0 in non-ESN mode for output SA");
+				return -EINVAL;
+			}
+			if (rs->oseq == U32_MAX) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay oseq should be less than 0xFFFFFFFF in non-ESN mode for output SA");
+				return -EINVAL;
+			}
+		} else {
+			if (rs->oseq == U32_MAX && rs->oseq_hi == U32_MAX) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay oseq and oseq_hi should be less than 0xFFFFFFFF for output SA");
+				return -EINVAL;
+			}
 		}
 		if (rs->bmp_len) {
 			NL_SET_ERR_MSG(extack, "Replay bmp_len should 0 for output SA");
@@ -196,11 +212,27 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 				       "Replay oseq and oseq_hi should be 0 for input SA");
 			return -EINVAL;
 		}
-		if (rs->seq_hi && !(p->flags & XFRM_STATE_ESN)) {
-			NL_SET_ERR_MSG(
-				extack,
-				"Replay seq_hi should be 0 in non-ESN mode for input SA");
-			return -EINVAL;
+		if (!(p->flags & XFRM_STATE_ESN)) {
+			if (rs->seq_hi) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay seq_hi should be 0 in non-ESN mode for input SA");
+				return -EINVAL;
+			}
+
+			if (rs->seq == U32_MAX) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay seq should be less than 0xFFFFFFFF in non-ESN mode for input SA");
+				return -EINVAL;
+			}
+		} else {
+			if (rs->seq == U32_MAX && rs->seq_hi == U32_MAX) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay seq and seq_hi should be less than 0xFFFFFFFF for input SA");
+				return -EINVAL;
+			}
 		}
 	}
 
-- 
2.39.5

