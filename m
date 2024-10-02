Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272E81D26E8;
	Wed,  2 Oct 2024 14:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879483; cv=none; b=hhrNeFPx4ZOD9ezMdWfoJCiVBD6EBj5hFZT2RXi1Px0gG28mMAZ1wyaOzs431LGU256zSNih2OS2kkmdwN2x1J8hS8kHl5B5Se+F/+eY6F61UHEjd6qjfvGQRycvJOwnuRC5c7yEhyzQ3IIie+l8qZwUfTYkmY3UErprqzCsPeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879483; c=relaxed/simple;
	bh=9IJAZgm02O+e2eCpmTxtnSvkrltcqsaiZck+gm+cvME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F06/OGt9l0Y8yCiGUvloPgD4+unI2Bf/XBVoC/VQQgLpJLtn1zmAnmJ/F7bCnfDkiPLj/zpF9rfVeWKrPw1nbSkXLX8bZRDU0UQ1y1CCoRNNjsavVE6okgYkdFHbtgomWZVynSKBPAGkwUMlm3QHvXM84f5riK8PQx36YqmtYmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TniyyHvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TniyyHvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B4FC4CECF;
	Wed,  2 Oct 2024 14:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879483;
	bh=9IJAZgm02O+e2eCpmTxtnSvkrltcqsaiZck+gm+cvME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TniyyHvic7vH9O+Ki89Byy34EJIsBvV3j+28SxM1DlIHOtx0B7RWhoRQV1tG2O9Ki
	 Tdpg9jI7Nmy0ELQBNGrzMJxFQhDvESmX9MzJejO0POopXmTyyTkDeJW6PECxFx8O6l
	 LDN5P8XN7ahcto+Ix2xmFQvSngYPatVTfFxhEmLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/538] fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
Date: Wed,  2 Oct 2024 14:56:06 +0200
Message-ID: <20241002125757.257036030@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit aa578e897520f32ae12bec487f2474357d01ca9c ]

If an error occurs after request_mem_region(), a corresponding
release_mem_region() should be called, as already done in the remove
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hpfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index 406c1383cbda9..1461a909e17ed 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -343,6 +343,7 @@ static int hpfb_dio_probe(struct dio_dev *d, const struct dio_device_id *ent)
 	if (hpfb_init_one(paddr, vaddr)) {
 		if (d->scode >= DIOII_SCBASE)
 			iounmap((void *)vaddr);
+		release_mem_region(d->resource.start, resource_size(&d->resource));
 		return -ENOMEM;
 	}
 	return 0;
-- 
2.43.0



