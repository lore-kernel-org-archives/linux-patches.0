Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F511F8F04;
	Wed,  6 Nov 2024 12:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897197; cv=none; b=WRroorhFy6bfbUL2rqxRaAmoR2hgufyw36disocisYtDyPb2EEBo/SjVqfVGgogrY4yW4p095B+sMoZoGu5oaDJwDvypHNaTlB4cC5Wp8DvS9O+icMHDNJLlTxEd48NOr3H9b+nqIVcCiINxvMxM4SvrdvCl5Ka42ZibyOEHdeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897197; c=relaxed/simple;
	bh=lyiGBF/RZAzki9FBv4Kn1/lQn+EqnRATAQabvrejhdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLVTmxrXe+2FFqihR6g4hggif83dJIdo4jkZtf+3WFAV+k7B5bXSg5ZvizF7FXxnr4UbbnTs5aDm6r696Ijc6qhRI3wHKYMalax+ufRr1bsjNU5OUKPvst61/T0WZQBSd/9f0MJfySqlfMnvWY2MLGzSxM+ukV2Mk2lHmqAMFjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/3wEPZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/3wEPZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC67C4CECD;
	Wed,  6 Nov 2024 12:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897197;
	bh=lyiGBF/RZAzki9FBv4Kn1/lQn+EqnRATAQabvrejhdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/3wEPZlvWg7NK2kTdcXR3XvGv/fiNQFe9RlGe+/vu22BAbzVLTp5oxR8rXGhv09V
	 JFqFXreg681/Xpm1Tg2f0lznWu31S5FckNor0KGpdsBmvT4dv3As3ZeB9fLive+yf9
	 J9bDtjgYUIIGHTdL1iniPgsW/QahuX9FWKsahhgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@maxima.ru>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/126] nvmet-auth: assign dh_key to NULL after kfree_sensitive
Date: Wed,  6 Nov 2024 13:05:00 +0100
Message-ID: <20241106120308.741406099@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@maxima.ru>

[ Upstream commit d2f551b1f72b4c508ab9298419f6feadc3b5d791 ]

ctrl->dh_key might be used across multiple calls to nvmet_setup_dhgroup()
for the same controller. So it's better to nullify it after release on
error path in order to avoid double free later in nvmet_destroy_auth().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 7a277c37d352 ("nvmet-auth: Diffie-Hellman key exchange support")
Cc: stable@vger.kernel.org
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@maxima.ru>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index aacc05ec00c2b..74791078fdebc 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -101,6 +101,7 @@ int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, u8 dhgroup_id)
 			pr_debug("%s: ctrl %d failed to generate private key, err %d\n",
 				 __func__, ctrl->cntlid, ret);
 			kfree_sensitive(ctrl->dh_key);
+			ctrl->dh_key = NULL;
 			return ret;
 		}
 		ctrl->dh_keysize = crypto_kpp_maxsize(ctrl->dh_tfm);
-- 
2.43.0



