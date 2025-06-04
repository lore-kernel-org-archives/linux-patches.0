Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7556812B73;
	Wed,  4 Jun 2025 01:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999231; cv=none; b=YnE7/DJJDT3rdKoLZeyX0tY7RFVE8El0Pb8Bz4t7XBZOYT5M/POHfroHjToOIoN7m/CT73n8lNSLJnbdwu9icUIQaNhkIs0LMGZ5rNUnu8G0n0gOEqs+CmHuWpayIwJqf0r6agPcPvBkbNLOILTLbRI/v9RYKEbkOSBP2F0WCEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999231; c=relaxed/simple;
	bh=uZiVtJtJElkZQ9XP1c8FaO68zfLJjauPxcW7nH4veqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdMk8WVWAsOcfsvcjTdAhhophqZJa+nTZIjYcopCHSvRz3li/Cm16KD2HD8Lx7vdWBs3PvtGhc3tV4RjjtcJvM3GotQhB9Q7v0sXwHkPqr2Lu0O4k4T77p78JqMPbxchWiBKYtkzzbSc9jOeD7wK4yhBTSin+iQRSZELh3+CYa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uu7FNiMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uu7FNiMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491C1C4CEEF;
	Wed,  4 Jun 2025 01:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999231;
	bh=uZiVtJtJElkZQ9XP1c8FaO68zfLJjauPxcW7nH4veqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uu7FNiMw85Q/dzfLFJK7ZkN8rKoy9ctzr23OaJHJAqmCrf9tjOJwndhhdzfPeocD7
	 do46Or29ej19aV6CswKn4NCVaqj6NftElN/yGUup6S8Sc2hDjYdOtl+SHWGpyQq1mH
	 3QgBE/u1Tyc8eqnBt8MPuMc5+BSaCwlSKW49ozDxkeKmp5ImaMB7kL8VktKX4smCYs
	 8sAJZlBeOCWVad5AznqYYuQAqjdyW067yO+zFGULhe24P7jIxjTEpUhg26mYvS74Cn
	 rtrTxprX+DXLqrD9SmxnJ1PwDUonQOnPrvWNiglWvjFCuxKRm5oiulnZN7Fli/jlA7
	 N+Fw6sPQ9z8Eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ajit.khaparde@broadcom.com,
	sriharsha.basavapatna@broadcom.com,
	somnath.kotur@broadcom.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/20] emulex/benet: correct command version selection in be_cmd_get_stats()
Date: Tue,  3 Jun 2025 21:06:49 -0400
Message-Id: <20250604010706.7395-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010706.7395-1-sashal@kernel.org>
References: <20250604010706.7395-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit edb888d29748cee674006a52e544925dacc7728e ]

Logic here always sets hdr->version to 2 if it is not a BE3 or Lancer chip,
even if it is BE2. Use 'else if' to prevent multiple assignments, setting
version 0 for BE2, version 1 for BE3 and Lancer, and version 2 for others.
Fixes potential incorrect version setting when BE2_chip and
BE3_chip/lancer_chip checks could both be true.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250519141731.691136-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis, let me provide my determination: **YES** This
commit should be backported to stable kernel trees. ## Detailed
Analysis: ### 1. **Nature of the Bug:** The commit fixes a logical error
in command version selection for the `be_cmd_get_stats()` function in
the Emulex be2net driver. The original code had this problematic logic:
```c if (BE2_chip(adapter)) hdr->version = 0; if (BE3_chip(adapter) ||
lancer_chip(adapter)) // <- Missing "else" hdr->version = 1; else
hdr->version = 2; ``` The bug is that the second `if` should be `else
if`. Without the `else if`, if a chip satisfies both `BE2_chip(adapter)`
AND `(BE3_chip(adapter) || lancer_chip(adapter))` conditions, the
version would be incorrectly set multiple times, with the final value
being either 1 or 2 depending on subsequent conditions. ### 2. **Impact
Assessment:** - **User-facing impact:** This bug could cause incorrect
command versions to be sent to the hardware, potentially leading to
statistics retrieval failures or unexpected behavior - **Scope:**
Affects all users of Emulex be2net network adapters where the chip
detection logic could overlap - **Severity:** While not a critical
security issue, it affects driver functionality and could lead to
network statistics reporting failures ### 3. **Code Change Analysis:**
The fix is minimal and surgical: - **Single line change:** Only changes
`if` to `else if` on line 1612 - **No functional additions:** Does not
introduce new features or change APIs - **Low regression risk:** The
change makes the logic more explicit and prevents multiple assignments -
**Clear intent:** The fix aligns with the comment stating "version 1 of
the cmd is not supported only by BE2" ### 4. **Backport Suitability
Criteria:** ✅ **Fixes important bug:** Corrects incorrect hardware
command version selection ✅ **Small and contained:** Single line change
with no side effects ✅ **Low regression risk:** Makes existing logic
more explicit and correct ✅ **No architectural changes:** Pure bug fix
without design modifications ✅ **Subsystem confined:** Only affects
be2net driver statistics functionality ### 5. **Comparison with
Historical Commits:** The provided historical commits were all marked
"NO" for backporting because they were: - Version string updates
(cosmetic changes) - Code simplifications (non-critical improvements) -
Driver version removals (cleanup) In contrast, this commit fixes actual
functional logic that could cause incorrect behavior. ### 6. **Stable
Tree Compliance:** This commit perfectly fits the stable tree criteria:
- Fixes a clear bug in existing code - Has minimal risk of introducing
regressions - Affects a specific driver subsystem - Does not change
user-visible APIs or behavior (except fixing incorrect behavior) The
commit message clearly explains the problem and solution, and the change
is straightforward to verify and test.

 drivers/net/ethernet/emulex/benet/be_cmds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 9812a9a5d033b..d9bceb26f4e5b 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1608,7 +1608,7 @@ int be_cmd_get_stats(struct be_adapter *adapter, struct be_dma_mem *nonemb_cmd)
 	/* version 1 of the cmd is not supported only by BE2 */
 	if (BE2_chip(adapter))
 		hdr->version = 0;
-	if (BE3_chip(adapter) || lancer_chip(adapter))
+	else if (BE3_chip(adapter) || lancer_chip(adapter))
 		hdr->version = 1;
 	else
 		hdr->version = 2;
-- 
2.39.5

