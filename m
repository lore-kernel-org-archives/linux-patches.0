Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A9425A651;
	Wed,  4 Jun 2025 00:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998774; cv=none; b=ELLgjrgpzpfwWwKxtP5vRsbdpSX7kbb2PwE5ZnVOBpUkxeLSlpBUTWq5paC0I8gIZMYEm49V+6nJGIStcSURIuxgwZTK8wDzFlP2krJpgz2yDFX41vynJSzxM0F6WmRBnyvAFCNjERwDirQCO5rYUX8lGlfUv2mTqrrx+5J2e60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998774; c=relaxed/simple;
	bh=fXrYMMfa0NgRmAMwX+BnbrVqHPqHnTvujaltLjalPyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tt4AFdA6bASCdzVeTbb/4y4UaApJC+fpvCW7RThMMmYvaqfDfJj3GHfm+x/pClbb7vatsa1hwo+vyrPoP4qI/ZnigC7QvM9cq/3+UmY1bueCfLLNlA7lxU3d/X60xyU+RDsMBk0jPucM4QvIRx/Bz5unZhf8pEF+nyw+SnBAoyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmPmunlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmPmunlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4E7C4CEF1;
	Wed,  4 Jun 2025 00:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998774;
	bh=fXrYMMfa0NgRmAMwX+BnbrVqHPqHnTvujaltLjalPyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmPmunlR4MYMc70C1rhgtrf6etABracn0H7rpGGO9FMEwlb/VSeWnlFTgPoYGAWEZ
	 9dkk05aV6ET9TXUZDNyz7QMGXY/ccV3OFZb1Qjz6pQ+O+LmkfxB77LgIYkfHYlnqV1
	 0ElIW+nCjgXiTSnwwVbK5X0TmLU8RPe+CuEZBaFFXgW3hP7rVfGtQ5LA1khJUw7V8H
	 NZ9WeDTQhmaOrZOu3huYj4UYUpk5b94g32cThbJV4VOGSemP2NoLrFCt5GR4mxEni0
	 ZUye0bNg9tx9MeXQ2btNpKDizxUgiAbMYxKz5Yw8lynb9kgHv4dysDJUIuzh2p65ev
	 exLuQGsub7Oaw==
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
Subject: [PATCH AUTOSEL 6.12 09/93] emulex/benet: correct command version selection in be_cmd_get_stats()
Date: Tue,  3 Jun 2025 20:57:55 -0400
Message-Id: <20250604005919.4191884-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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
index 51b8377edd1d0..a89aa4ac0a064 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1609,7 +1609,7 @@ int be_cmd_get_stats(struct be_adapter *adapter, struct be_dma_mem *nonemb_cmd)
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

