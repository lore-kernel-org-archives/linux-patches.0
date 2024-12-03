Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B9C1FBEA9;
	Tue,  3 Dec 2024 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240243; cv=none; b=dEtQyhsGUuQDhTeRm+o83vbJV+lJ9sm4YhmkD6aKkTcwz4D9l6zI/zeCzn4CGyPu1XWZ6DpupiQklrVWVaLI3nXFj8Wfp7/zneH+BC2+sBSJOKn1axPb5IWA2UscjmN1ZKsxu5mocaXakc18puS1POQ4kNr2I12Wqra8h599obU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240243; c=relaxed/simple;
	bh=2BZgBTRvuLk7bAmsCnv2ga5Wkpmoc6SNf5o2XjdUJzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDH8ZCgcRKisMRgPtguavIqWU6u0OcEh4iuw6+rbAOsZe+FOQSL47VoB5rWzn3zJmRKxVJjxbS/ke0HGOsSJd0U9c5Foz0D75DBzb886gMSEo5XatuULtuePlp0gymEf5RG4b1DdfrNQTM6ir8LaWtVhqlraIVmFB/ZEd3MOQm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzE9WbX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzE9WbX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3AAC4CECF;
	Tue,  3 Dec 2024 15:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240243;
	bh=2BZgBTRvuLk7bAmsCnv2ga5Wkpmoc6SNf5o2XjdUJzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzE9WbX2PRYYbS6L34HDIfp3DG1g3oCUMsnbFxqv3D83R+1C6L7l1mLL60m1tRTYt
	 NFU8WGQ7xI+1VtiIi8NTjyG9toNCQ120U2tNgKUqDPV/aE1Nv/ABRblw/tfyhYIkE/
	 Q7UGIERFIPjRhlHCDdR87FBaZvZXyYDDEVaWtO+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/826] crypto: caam - Fix the pointer passed to caam_qi_shutdown()
Date: Tue,  3 Dec 2024 15:36:08 +0100
Message-ID: <20241203144745.066860482@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f6111ee9ed342..8ed2bb01a619f 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -794,7 +794,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 
 	caam_debugfs_qi_init(ctrlpriv);
 
-	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
+	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, qidev);
 	if (err)
 		goto fail2;
 
-- 
2.43.0



