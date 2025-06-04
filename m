Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9548C19DF4A;
	Wed,  4 Jun 2025 01:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999130; cv=none; b=QPQgWKcj+nwwLx0vevrjS5awNUaOjryr2o4glOTi55VICbgfg/Vg+XkVPtk5ZbRYW3PMc8/SldnCpPOhIRmLjzgfpwVBZ929Eil+H2JFDFUdeWJPR5bWlzHUEMvT4kO/2o2RS11dNO3311AT+HYpkLsTQ697C8KRSR+Bcswi3xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999130; c=relaxed/simple;
	bh=arsGoctjdfs7YW2d+V+OpzBV7DxMlpMXWSkNfLdqhi8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWFm7otcQ0wVa8pDg2cx5YQt0gm/K3dNMZy2zf57BYonxYqVYsWAvfB5VTIGFit3UthOjaQzJxFQNFgo1PssfUH/BbYKALjXlsJ326qdxUMkiOu1rU9dlJrASa0io1PlHRqBgppfq23HI7uSAnaPN/Rei5JazsWUU4vXR4MbzPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/BmkEqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/BmkEqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76554C4CEEF;
	Wed,  4 Jun 2025 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999130;
	bh=arsGoctjdfs7YW2d+V+OpzBV7DxMlpMXWSkNfLdqhi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/BmkEqYnG9SfZ+PcrouaCoezyWdA8OzEi/c9PXWE+ZrpMqKoZDDPUXMKquCLfO3M
	 4JElF3ZwYIho1m+2J2nAw54yRJDct3PaO1WLB8sGO4IyI0zgRHe//GvNaJMS0TKNpj
	 6+XYHsLMhRhUCfz4oA3dXDSmTgBE7vKcYf5u4Hjv6rkG26miFzZnnF5srEPUcbGmKH
	 pjhZ5Rc+KgzKW8O+Pq7FdZzAZZuZMxOKGa7UcniEY8pzxjutGP3wJhn84lLs7kTxy5
	 0tX7MAUSglnWg3nyP9aT7kUgZyoNrML2tE76mZIaFPg01xjePKFvGGvjIplvN3AJJF
	 Kmb1LreTsPjBA==
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
Subject: [PATCH AUTOSEL 5.15 04/33] emulex/benet: correct command version selection in be_cmd_get_stats()
Date: Tue,  3 Jun 2025 21:04:55 -0400
Message-Id: <20250604010524.6091-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010524.6091-1-sashal@kernel.org>
References: <20250604010524.6091-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.184
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
index 88f69c486ed09..1cdb7ca019f57 100644
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

