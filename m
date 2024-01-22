Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B25E62800;
	Tue, 23 Jan 2024 00:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971117; cv=none; b=MhON9h7EUZfLBrVwVDqXhZuYDeBL3Ax7A0sIs7lSXfh2d/hMYZsQKUTdhiUoLNQgfo0NeERI0ru9VViKvUIqI4gpQw+wpFh697xiu0+xljFC2a1lW3dqVAB6omdnvQLtABYTCf3bL+oEEcGuC7+IMLXf+sVzPjScnlUBJkZEUHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971117; c=relaxed/simple;
	bh=fhgtEubQm2iQg3o3ywCcodhaoYHRKUMVyBlsigcRT5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9xNYBMILHentW4rCgHMJao13+xeADUCfeLo8gqAzmYqKcfi5HhU0q8MJ8l9STyanfc2ynHCy4aMU+lhI3vf174d0ou5N7NqoLX7eZHojC3HXxeyBA9ntS7AVHIINjo1H98OajNxPRNbve7TKkaTJx119E1SG5OK7+VmmTK0mSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTUo1LTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTUo1LTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AEDC433F1;
	Tue, 23 Jan 2024 00:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971116;
	bh=fhgtEubQm2iQg3o3ywCcodhaoYHRKUMVyBlsigcRT5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTUo1LTiqmK5F/jbsYMJYa5/AT+jsy1xLeQkXMYuVDGshNc+N+zpdHx22qy69y8Qr
	 GupfipvH8v6Xr8NPPXksqA1ahpw43sUVLckRbuEMRmg+GTTWof8a7YbZ7bQey6c7QE
	 EYPYsMoly+8l46heThW72SfYBs1SZO2kCPEll2fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/286] crypto: sahara - fix error handling in sahara_hw_descriptor_create()
Date: Mon, 22 Jan 2024 15:56:37 -0800
Message-ID: <20240122235735.538812055@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit ee6e6f0a7f5b39d50a5ef5fcc006f4f693db18a7 ]

Do not call dma_unmap_sg() for scatterlists that were not mapped
successfully.

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 855c232d66a2..3cd872d282b4 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -483,13 +483,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 			 DMA_TO_DEVICE);
 	if (ret != dev->nb_in_sg) {
 		dev_err(dev->device, "couldn't map in sg\n");
-		goto unmap_in;
+		return -EINVAL;
 	}
+
 	ret = dma_map_sg(dev->device, dev->out_sg, dev->nb_out_sg,
 			 DMA_FROM_DEVICE);
 	if (ret != dev->nb_out_sg) {
 		dev_err(dev->device, "couldn't map out sg\n");
-		goto unmap_out;
+		goto unmap_in;
 	}
 
 	/* Create input links */
@@ -537,9 +538,6 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 
 	return 0;
 
-unmap_out:
-	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-		DMA_FROM_DEVICE);
 unmap_in:
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
-- 
2.43.0



