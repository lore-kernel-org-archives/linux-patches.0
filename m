Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984567DA7F;
	Wed,  6 Nov 2024 12:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896396; cv=none; b=Ew2VZi8A7rsGtlf6z4WBze125sm4+GdYULY5y0yRFAX2qfea0ET3n0mnzgCUIt6/1UhYMaYa882r8TdSOG3BzBHH3BgIm/v2gI/TWtxJQmkSuKEh8PE3kRDaGYY5STLaSJ0LYCAqvqdMcSs1hrCvS9NX/itDgGG+VYZQrhSthTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896396; c=relaxed/simple;
	bh=kEP2Mp/9V/yn/0RTT+/v0trWdia5WwGtqhCrE8RTPc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNL6qw9U6HkNx1XmMkzL4jfdaJE3q3MUv6MglneaV85x6F08oPJfmE1UikxKhbuxeYwxKqID/NmnHe7ERFPWGboQTnO52SfDK9cIo2mBqfb4YDZq7j7MRnXQLsw0fD3+ngEyEsq7/fJebDw80WFRCZLDNKRs6AFaq6WSBzvNx64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVYSkelr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVYSkelr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21992C4CECD;
	Wed,  6 Nov 2024 12:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896396;
	bh=kEP2Mp/9V/yn/0RTT+/v0trWdia5WwGtqhCrE8RTPc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVYSkelrqb0wXnq6wOHW2efwhnA8tAzUTxsIpjTxyEb+ylI7ZK5+WtspHBztqd/Mm
	 XzXYqsaEgl1G5Ioo/sHbn0OdcmVq2PCLXloer/LWNyN1b+eZaRKddZhXnNt0RaSceE
	 jvNqSPhE38ik5uFFTkY257pwgLQOmngflhZBuHKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@maxima.ru>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 187/245] nvmet-auth: assign dh_key to NULL after kfree_sensitive
Date: Wed,  6 Nov 2024 13:04:00 +0100
Message-ID: <20241106120323.845486199@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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
index 8bc3f431c77f6..8c41a47dfed17 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -103,6 +103,7 @@ int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, u8 dhgroup_id)
 			pr_debug("%s: ctrl %d failed to generate private key, err %d\n",
 				 __func__, ctrl->cntlid, ret);
 			kfree_sensitive(ctrl->dh_key);
+			ctrl->dh_key = NULL;
 			return ret;
 		}
 		ctrl->dh_keysize = crypto_kpp_maxsize(ctrl->dh_tfm);
-- 
2.43.0



