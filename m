Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7DF15CD55;
	Mon,  2 Jun 2025 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876910; cv=none; b=iXfDEwG+Ft0TwsuvByV2RFdvejgkTke4xHXj7bLNdlyG+PK6VSzvWjxRbAQG8xGG8hNsQyf5/g36xwLsrUQmAjuIb77n/d2uI5mNgYBd6eOrHEKZNQrecnu8mKhZ0O0z70YOWZ4LrgkggNsFbr5DXMoNxPzD84RY1PdAiGGMYW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876910; c=relaxed/simple;
	bh=eWfI8LkyUIYyDNF1Dlba1Bg1BphkX2SlKF+3eD8dJ8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYYQWt5GF9Oz4vZAaojVdIQ9uAgwkeSuN9DrFe9BAPot18zwHw073ITJQkVz18J8cw+a4hVMHQN/hvWoba4HG+SM1HgGdx11CR26xpUe8nYnoIPGaz4xhIUp7+vwEN5pqFDiXGMZFecP7L/9Uvgfg5usmM6qx0NgPJhb933HnWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lyu34wvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lyu34wvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C7CC4CEEB;
	Mon,  2 Jun 2025 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876910;
	bh=eWfI8LkyUIYyDNF1Dlba1Bg1BphkX2SlKF+3eD8dJ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lyu34wvZXNGRWDZV6fV3+/FXghYaEmRwowsDrpSznOfeaOVQYNYd3kww7ZAM84+1E
	 X3Su9i4oAkMMglK8wD795xI/eJft1fwSgQZeYPjNme66PTg7KwsPN9cRoPIHa2qo5r
	 cs/8BdegbuKNAKxQDkln+rU9PVAWAoerndJg9xj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Gupta <shashankg@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/325] crypto: octeontx2 - suppress auth failure screaming due to negative tests
Date: Mon,  2 Jun 2025 15:45:48 +0200
Message-ID: <20250602134322.711242965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shashank Gupta <shashankg@marvell.com>

[ Upstream commit 64b7871522a4cba99d092e1c849d6f9092868aaa ]

This patch addresses an issue where authentication failures were being
erroneously reported due to negative test failures in the "ccm(aes)"
selftest.
pr_debug suppress unnecessary screaming of these tests.

Signed-off-by: Shashank Gupta <shashankg@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index 811ded72ce5fb..798bb40fed68d 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -410,9 +410,10 @@ static int cpt_process_ccode(struct otx2_cptlfs_info *lfs,
 				break;
 			}
 
-			dev_err(&pdev->dev,
-				"Request failed with software error code 0x%x\n",
-				cpt_status->s.uc_compcode);
+			pr_debug("Request failed with software error code 0x%x: algo = %s driver = %s\n",
+				 cpt_status->s.uc_compcode,
+				 info->req->areq->tfm->__crt_alg->cra_name,
+				 info->req->areq->tfm->__crt_alg->cra_driver_name);
 			otx2_cpt_dump_sg_list(pdev, info->req);
 			break;
 		}
-- 
2.39.5



