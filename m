Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF2330567C;
	Thu, 30 Jul 2026 15:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426205; cv=none; b=W6dYkP4JA/kXsK4Pu/9cKMAf8pGhVaidg1BU6B0CdxTYH5lB4v55A7pTmqITaAJrIEjXgsOyadthY2xhvqNVK7FvlfCHGLWu7Z3NGY/OanRKQvayI5Gpvt2fBG16i2O8dWQoZK3nzt/yzx3KyC65c25/o/KSentcT1/LWZeh6do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426205; c=relaxed/simple;
	bh=lVKyTLBD5LfPFqwg2aUV+bKoIFMrQ207F15JI2m0zxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYtAjkoVyuc6CF7i4eNK3Ej1dOOi5TOdWb27N4KqOGP78Gck2ig9A2b1BRDM5it4it5o2vWvesm9QCyk2WxCH5uYqydtooH84TguUK7UIoICQF3Cy2IXhfDX+g1L8Kv6jUS/Di5De7QrAlIgf3aedjWumsrJ4Kzz6fG0QfQyAzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWwRdC6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWwRdC6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBE41F000E9;
	Thu, 30 Jul 2026 15:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426204;
	bh=prBFWMe0GG2q9RGqBzWSGyIa3NRN1ht0AuzARknYYNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qWwRdC6Idia7jEnNQrxk0zwB3T7U7Ejwoaixvo+R+DAt15VlopLbdvByrbTtHP52D
	 RiIT6fgjEG4aOnaG9U5LeWT3JuQPlwfDTBOceIaQB150eQkkhtjMp3ZEHiL2FDoeXm
	 x9q/kh8PCVvFNlatJmHOz2zuSBnzHAXdZ5KWbYQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 338/602] media: vimc: fix reference leak on failed device registration
Date: Thu, 30 Jul 2026 16:12:10 +0200
Message-ID: <20260730141443.064363054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 33e2b833c66b890a0d71c4fa82d4c97143f7f75f upstream.

When platform_device_register() fails in vimc_init(), the embedded
struct device in vimc_pdev has already been initialized by
device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  vimc_init()
    -> platform_device_register(&vimc_pdev)
       -> device_initialize(&vimc_pdev.dev)
       -> setup_pdev_dma_masks(&vimc_pdev)
       -> platform_device_add(&vimc_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 4babf057c143f ("media: vimc: allocate vimc_device dynamically")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/test-drivers/vimc/vimc-core.c
+++ b/drivers/media/test-drivers/vimc/vimc-core.c
@@ -424,6 +424,7 @@ static int __init vimc_init(void)
 	if (ret) {
 		dev_err(&vimc_pdev.dev,
 			"platform device registration failed (err=%d)\n", ret);
+		platform_device_put(&vimc_pdev);
 		return ret;
 	}
 


