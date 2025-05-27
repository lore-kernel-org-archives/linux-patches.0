Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977BF194A45;
	Tue, 27 May 2025 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366799; cv=none; b=HcoaiwLcV6pBSyRrbKZCZiKXaTJ7CgDjaVTvosqIea5+Mo3nC8a0PiOIxxGErhq5XU3eSJ4q+oL881m26jaeP+F7vcN72j7bLroTKOKqIkQnd3crGlEQ0y26b1ibWLVvjunw9SJg6YncZK+1us3kmA5HZlLTf66VCBbQB9uq9Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366799; c=relaxed/simple;
	bh=8ktLA1czLN1AjVbnk+zeNFNIIEcS+YZ+97mOu8q3CVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G26nLeT5m8bYZf7nyFCCSxCJeZ+Cr5vE4AxgQLffSuBXUXSFHqEubEoc2qKblKP81tsQ8m7jNluvx0YWyke0YTseD0DTqIrMzVUyLaaOvR2KrXr8o6+HHTzSZe0LCSsSGRqP1+YCVJXIg/RFg1p28ciClj/9ZKj3MEnZn46YwFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck3DIY74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck3DIY74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3CBC4CEE9;
	Tue, 27 May 2025 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366799;
	bh=8ktLA1czLN1AjVbnk+zeNFNIIEcS+YZ+97mOu8q3CVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck3DIY74KKOV6pleLc0PhhELYtM6XUEzCFl/g0nP4x4su1ZcgJUDZFde839RcjQXw
	 B/lMjoaHTyYaWTzXuGGCMQCFqjY7gxxd+MHVnFxIN0idcVX5QgYv8dpkUAmQBOPnXX
	 L3Gje7YxY5s1i9J39KkWIEbCwfiXGsRo0BCJKuEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Gupta <shashankg@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 179/783] crypto: octeontx2 - suppress auth failure screaming due to negative tests
Date: Tue, 27 May 2025 18:19:36 +0200
Message-ID: <20250527162520.449628808@linuxfoundation.org>
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
index 5387c68f3c9df..4262441070372 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -264,9 +264,10 @@ static int cpt_process_ccode(struct otx2_cptlfs_info *lfs,
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



