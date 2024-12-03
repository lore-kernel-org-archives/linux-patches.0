Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460411F76B1;
	Tue,  3 Dec 2024 14:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237861; cv=none; b=M96sCQ0PjkdKg7W+Azpqb7zhZtdfOuFu+dMDtTa61hogcK6owFfsdemKSCluVmlL8C8M8p3sx6jHLffdeUdkAMP+X0ai2srGALLhPq1W20WjXkI00W7mL0Ax1PkDUm4E1e4Va+UMMGMoxpEoLDddGUy432JRtPDQjVdFOLlEfWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237861; c=relaxed/simple;
	bh=QWR9z0dsQhz/+TybN7in/G2YbwQ3sZpvLa38XNlY4gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZObcVZw/dFq+WxaVzuwHHhLJ3W8IX+jBxJ8F0iRs67BAHLxQ1o/eWDlVpOGULQ3t4YEq02cty+9SzxZUMJerb8G8oRjyq1GEq4/92BWvJ/3qfxrkh9HZENovXHho54tILRnhr4WbJOV7yf/YnVQOQ0Kvq4uO1SbutK7WhbiQylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJtF+iqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJtF+iqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A847BC4CECF;
	Tue,  3 Dec 2024 14:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237861;
	bh=QWR9z0dsQhz/+TybN7in/G2YbwQ3sZpvLa38XNlY4gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJtF+iqwo7cu5vzhNIzZ/wig++AHpr/bSt0bMynTTEP4klL6eZc7LvJl9OJ+1qSEh
	 h8rWSySk98WBGe2ROcwInaSggDUay4U60QcFP65WZJAm4w+FhiTJFCJ1VHjR1XeOri
	 hnI1OsNiZGwggZuAjVYWPjKvO9EAcURHMdg1Gecg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 089/817] crypto: caam - Fix the pointer passed to caam_qi_shutdown()
Date: Tue,  3 Dec 2024 15:34:21 +0100
Message-ID: <20241203143959.174989918@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ad980b04f51f7fb503530bd1cb328ba5e75a250e ]

The type of the last parameter given to devm_add_action_or_reset() is
"struct caam_drv_private *", but in caam_qi_shutdown(), it is casted to
"struct device *".

Pass the correct parameter to devm_add_action_or_reset() so that the
resources are released as expected.

Fixes: f414de2e2fff ("crypto: caam - use devres to de-initialize QI")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/qi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index ba8fb5d8a7b26..dcb9069a254c7 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -793,7 +793,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 
 	caam_debugfs_qi_init(ctrlpriv);
 
-	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
+	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, qidev);
 	if (err)
 		goto fail2;
 
-- 
2.43.0



