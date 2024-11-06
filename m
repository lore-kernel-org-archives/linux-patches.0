Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B4E1D5AD7;
	Wed,  6 Nov 2024 12:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895071; cv=none; b=rYVAw8zAYlyRS3MoaBtc8J9o2xnnqjZg05KbWk7mBavLeeYIZUG7M1gjNdPwlk0Zz7yJj66xA13/neoAAu1k+LesJhRmePpSYOenXrcv/hizm/g4nkqxd6JGUK4Ab/DBmyjXYSgR+rHHkPJ5lgvkfaXcNF/oeqVrnje2Nwe58X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895071; c=relaxed/simple;
	bh=dmJHD/KF/m6L9oxSsxE9KNp555yshKvoStopIJhp65E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0bkm6Bm0ivvs98tYm+bosos2TvfiP6jv402PVYqygGj14uUc27H7w1ungxYFCI/xQ6j6AYUPk51diphipkNm3z3jjC3Bn+FfAdTouKZc74i30PKVDS0Vu8VKPGZv9fh59rZ4Lm3nt8uhUacKjFIKpWUpliW2EmV6wuzFIW8odE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSItzI+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSItzI+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD4DC4CECD;
	Wed,  6 Nov 2024 12:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895071;
	bh=dmJHD/KF/m6L9oxSsxE9KNp555yshKvoStopIJhp65E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSItzI+gtiVYg0dlYDujrMzWIfX1gZUY7HlIY1cACS5atA+wNj6bL1AsEh5oVnb7O
	 gcy+Q9uM2oyjTuQDvEx0oSIlDU9dYro1VYBHemfFs0QvQV5bdnEABRiFlioRuD4san
	 /741sO5ng1oAwUtyT1VRPhB+s6Eupav88eywDiJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/350] fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
Date: Wed,  6 Nov 2024 12:59:37 +0100
Message-ID: <20241106120322.102180381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9230db9ea94b7..47ec02a38f76c 100644
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



