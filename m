Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5531127BF8D;
	Tue, 27 May 2025 17:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368247; cv=none; b=iHRYX+/+j3yAgfxlrccDJIyj2IwPTPBCgpUaq71BAHxuWIC0Nz8wvuHCw/kKBOYm5136HrL7n+VBnJ0RVDw2yDkw7rybvcIs2aGqT7dumOJMz5Hw7WlxKl/Wx4FqhNNAOY1PvrHfiDkLDzsmr9Tjj2vpdg8YvYLYmKvpD6pcoPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368247; c=relaxed/simple;
	bh=2Adm7+Tpu8XnShht4dyMqa6QC2MfQxih0LoXXIYB9+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHzPNzTsg7SI9h2VF9Y7hmEBJFEpRe00JUDur0QmH5TmgAI7fLtc30ASZk19JfF7snHmq0ROli6lCHVaUT1S+Jvzb9ntTaOcjUQdU5lpi+fFHKseylCc1HDZSrJPOct2jbzwqEkLAHjGUuGY2yq41e0hRr+hvR26Vhh+Ta/wkzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpZMVgdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpZMVgdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87EFC4CEE9;
	Tue, 27 May 2025 17:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368247;
	bh=2Adm7+Tpu8XnShht4dyMqa6QC2MfQxih0LoXXIYB9+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpZMVgdJDR6n6NY3K92O/CFS8rH+U0pW0w172d+OSEHFCLD33670cw7hF/uAzV4l5
	 FkolaJRbdGjOgeTxlP8z7nbkk3cBaLdoDnIOhMRHV2uGACd7dS5dlaFPJ4pniA364R
	 N1fcasr+29fznD2hcUmU2KkB2KvzvqN+5l1kHijM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 615/783] drm/ast: Hide Gens 1 to 3 TX detection in branch
Date: Tue, 27 May 2025 18:26:52 +0200
Message-ID: <20250527162538.195798659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 87478ba50a05a1f44508316ae109622e8a85adc9 ]

Gen7 only supports ASTDP. Gens 4 to 6 support various TX chips,
except ASTDP. These boards detect the TX chips by reading the SoC
scratch register as VGACRD1.

Gens 1 to 3 only support SIL164. These boards read the DVO bit from
VGACRA3. Hence move this test behind a branch, so that it does not
run on later generations.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250117103450.28692-6-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_main.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index bc37c65305d48..96470fc8e6e53 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -96,21 +96,21 @@ static void ast_detect_tx_chip(struct ast_device *ast, bool need_post)
 	/* Check 3rd Tx option (digital output afaik) */
 	ast->tx_chip = AST_TX_NONE;
 
-	/*
-	 * VGACRA3 Enhanced Color Mode Register, check if DVO is already
-	 * enabled, in that case, assume we have a SIL164 TMDS transmitter
-	 *
-	 * Don't make that assumption if we the chip wasn't enabled and
-	 * is at power-on reset, otherwise we'll incorrectly "detect" a
-	 * SIL164 when there is none.
-	 */
-	if (!need_post) {
-		jreg = ast_get_index_reg_mask(ast, AST_IO_VGACRI, 0xa3, 0xff);
-		if (jreg & 0x80)
-			ast->tx_chip = AST_TX_SIL164;
-	}
-
-	if (IS_AST_GEN4(ast) || IS_AST_GEN5(ast) || IS_AST_GEN6(ast)) {
+	if (AST_GEN(ast) <= 3) {
+		/*
+		 * VGACRA3 Enhanced Color Mode Register, check if DVO is already
+		 * enabled, in that case, assume we have a SIL164 TMDS transmitter
+		 *
+		 * Don't make that assumption if we the chip wasn't enabled and
+		 * is at power-on reset, otherwise we'll incorrectly "detect" a
+		 * SIL164 when there is none.
+		 */
+		if (!need_post) {
+			jreg = ast_get_index_reg_mask(ast, AST_IO_VGACRI, 0xa3, 0xff);
+			if (jreg & 0x80)
+				ast->tx_chip = AST_TX_SIL164;
+		}
+	} else if (IS_AST_GEN4(ast) || IS_AST_GEN5(ast) || IS_AST_GEN6(ast)) {
 		/*
 		 * On AST GEN4+, look the configuration set by the SoC in
 		 * the SOC scratch register #1 bits 11:8 (interestingly marked
-- 
2.39.5



