Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1274912A17F;
	Tue, 23 Jan 2024 00:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968864; cv=none; b=psz22551VQ8gHKB1jiQn2qLv37R8dr4D2jWLMk3zgTMa2gSl784/vGL2sDrCCkMfe7HyAzaXZqNiHU3Zw2uuYw/1LS/r2hxhIZiy6yCxqXbJ/q+nxPxIW0QO4XKvYqePZxXLafH9z0+SULvy4OEEINv29w0uPg342WfAwsqO9xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968864; c=relaxed/simple;
	bh=jX48O2SySGWbgYavGxKXhPOPWgi8aLpxEGnWEl+fYsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiRrqDsDqMB3WVt7QSBbdkjKN8JOYuOoBCCOFUnBlhmfKZ+rg8Rv20bL0FgBllBK4TtE+YldHYoNEjbBuFe1Kztwg3/9W8hY0Il1sz2wM5ttc+1JESphHH//GefpA6NAXIg9qXWtSXsaTPDXCvU5ev+/8gumI4Ug5GXzTUwW+Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm4BWgoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm4BWgoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BABC433F1;
	Tue, 23 Jan 2024 00:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968863;
	bh=jX48O2SySGWbgYavGxKXhPOPWgi8aLpxEGnWEl+fYsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qm4BWgoawtRM5iWbMYPKET0qzPVwPMwrn3SgzzBwnal4Dyfyn9KDe/2sNoNbz+GnR
	 ZT3JaOIYii1lIqZKMcdjQf67GdCI67HLPd/Vnc6rQGI9ovgYsqFmOpvjFtxqKNe5vn
	 R52NbCbsJ3QNhBI0w/gKOjWA/DzG7UCjatKh9Kjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/194] crypto: sahara - improve error handling in sahara_sha_process()
Date: Mon, 22 Jan 2024 15:56:44 -0800
Message-ID: <20240122235722.409074649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 5deff027fca49a1eb3b20359333cf2ae562a2343 ]

sahara_sha_hw_data_descriptor_create() returns negative error codes on
failure, so make sure the errors are correctly handled / propagated.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 7d24e802d382..dbccf9264406 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1003,7 +1003,10 @@ static int sahara_sha_process(struct ahash_request *req)
 		return ret;
 
 	if (rctx->first) {
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[0]->next = 0;
 		rctx->first = 0;
 	} else {
@@ -1011,7 +1014,10 @@ static int sahara_sha_process(struct ahash_request *req)
 
 		sahara_sha_hw_context_descriptor_create(dev, rctx, req, 0);
 		dev->hw_desc[0]->next = dev->hw_phys_desc[1];
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[1]->next = 0;
 	}
 
-- 
2.43.0



