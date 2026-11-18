Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038663;
	b=Od/RvPtT0uN8vcE0+w+ydrJZ+NzoPuBfSCLUqk8E8XB3sMtSmU9R9fvHXp6dysopB9Ea
	 hgCHyXPrAEPS3d/z+u5vKb91gYPIYzwGWnQ782io+qeBtDkOJ5IYiJQJzqu1NKVHI0xtV
	 wIcGLot3Xqe6Bq8ogUydxRRuBwXDuTOg70JVm+yeWVDNsNfDgazoh8nYiaqnf6kA79iGM
	 t5Plj5RmW07ZWJuBLA0Rn6wHl6v/G3N+X6Ms9FDRuLdAjstT4O1MF65hNYfOYUjQm/I/V
	 qTKJTnxfIYh1iayILAANOMkUYP04dDD49r5hwV/PsjTHBoB3NtMz9aZ2alFtCXIN0XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sd7B7m6w6ujWSQRBBrgk77FcJpVx/8NZMtWh3QdZq/0=;
	b=qCLk+pjIe5ilWuEXupBAohurFkKtup9eLd2kl3aT+jl13pVCYYbglmaA9+YfnjORXQjt
	 EoB4tH8kni4wXrGgT2aHnuoo3w5aPI2/K7wrl02w4oGOGSCJYNLka84I68Xm5CJd5RN6V
	 3Km+Uz/RISjGgmEJkFSkAgrHCMddiv/AK8EM07DpG0AFNYx0B03StJyOWwjuITqu1NsxN
	 5UmSqFgv/EX4l1TuojPn6fDjCWKhIINMyaPSw7P2leDPmVIz6pZm+EHWYzI62vHa9s7+f
	 uqJcw9HgwTfA085XKKCd9NgmhudXAApMLSzBm10X7d7e8S2lYwIoFrw3cdn9Yoa5X7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcQWQrCZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBB9606A31C;
	Wed, 18 Nov 2026 21:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcQWQrCZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14851F000C4;
	Wed, 18 Nov 2026 21:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038663;
	bh=sd7B7m6w6ujWSQRBBrgk77FcJpVx/8NZMtWh3QdZq/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pcQWQrCZT1WsXg10WLEoiOZ14mwDLorQjtoaBIVDvRXHdQDuq9NBkoI5fsgR2DarB
	 9LLfZEzNHc2dKTKtRRNjgdLtL7OiOfN+x2S3ORjRn6yMdrwE4acExSj9HtX4vOgGnC
	 M29UhiNPv/WI2mhPMT4/zt7ueA8HPhApgVsu1lrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1821/3318] iommufd/iova_bitmap: Ensure that iova_bitmap_set() handles the full IOVA
Date: Wed, 18 Nov 2026 15:40:43 +0100
Message-ID: <20261118150416.493667990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit e21952d72b4740f08a272d694cca223b6b0099ca ]

Generally userspace is going to step the dirty bitmap through the IOVA
space. However if the bitmap ends in the middle of a large PTE this is
problematic. The first step will clear the dirty bit and report dirty to
the end of its bitmap while the second step will see the clear'd dirty and
report clean for the start of the bitmap. If it happens this ends up
losing dirties.

Further this function is missing bounds checking so if this does happen
ther is a good chance it will write memory beyond what the userspace was
expecting.

Return an error code if this illegal condition happens.

Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260925161142.189813-2-parri.andrea@gmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ sashal: Adapted the VFIO bitmap implementation by adding the missing error field and propagating it through the existing iterator. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/iova_bitmap.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index 3f48125e2b9f0..e78cb1b4e7364 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -113,6 +113,8 @@ struct iova_bitmap {
 
 	/* length of the IOVA range for the whole bitmap */
 	size_t length;
+
+	int err;
 };
 
 /*
@@ -381,11 +383,11 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
 	     ret = iova_bitmap_advance(bitmap)) {
 		ret = fn(bitmap, iova_bitmap_mapped_iova(bitmap),
 			 iova_bitmap_mapped_length(bitmap), opaque);
-		if (ret)
+		if (ret || bitmap->err)
 			break;
 	}
 
-	return ret;
+	return ret ? ret : bitmap->err;
 }
 
 /**
@@ -408,6 +410,18 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
 	unsigned long last_page_idx = mapped->npages - 1;
 
+	/*
+	 * If the range cannot be recorded then the system call returns failure.
+	 * This is to prevent loosing dirties if userspace is expecting to step
+	 * the bitmap through the IOVA space.
+	 */
+	if (!length || length > bitmap->length || iova < bitmap->iova ||
+	    iova - bitmap->iova > bitmap->length - length) {
+		if (!bitmap->err)
+			bitmap->err = -EPROTO;
+		return;
+	}
+
 	do {
 		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
 		unsigned int offset = cur_bit % BITS_PER_PAGE;
-- 
2.53.0



