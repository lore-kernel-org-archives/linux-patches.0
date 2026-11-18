Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047253;
	b=3tyBoHydX3l0QUduc+LU6rElinq2rHM8hO+htZUbjrlX/iIcnAlvSqm9gEUCjjOFhHJt
	 aY7uWhY/tOJObXYs575tpGOIjf1ixQkT5z1FUlKvCpdOJfPl0aWaJ41bgWa45U8ebkevd
	 4dsSjUGUMbdk1KnvUjScj5TNWkOsZs6bPAkESF/Fwdp94Co+Wx243VYWURdK6sPCD3Uih
	 I4TONQGCuJxRo/m+f4elnwITp9MdEbts9ABFLejaIlpawc8A+W++oeS0dTkmCB4q13YEq
	 SQvcH4Q05iPFbeqQyc2lIyaW/Se0XfTjC60+WKCDjd62WDasJz0X8niS33P5mp1Z88Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQBSmL409VqwG9o6mPr3OW8JtYNGtRw+ch9/fjYGjiI=;
	b=Bd30zJmt/odoyUPzbd45Ww64nRSQrTV6pJtL5sZ69QGWuvKpYIwWHcURMxLeZ5dOYrZb
	 ENG/OK4/qDj+CYow8qzfytqCosVqMy7VsbRnbCTPxZALRGkpPaLsXnQHcnVToxMKgZiIP
	 fL2h4kKiz5mzJvfUxE8DRuEfrs+P642BRQys87EmeqkDERn5hGLV/2EBSIo0t6uiOOjlk
	 KJkflvFSoqKb8irg1C0jtpRKFqPklm4OegLxz/8k+PZX/GTHukuLuWINrMMfVdhrDbh8j
	 Si/7Mi2gqY0nxTsEd7794ejwkWWjg2Clzpfgz2NKb+kGuAZl+nyBmT3t2t+fVntqbog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wapcYXCE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B496D60A2600;
	Thu, 19 Nov 2026 00:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wapcYXCE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51BE1F000C4;
	Thu, 19 Nov 2026 00:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047253;
	bh=bQBSmL409VqwG9o6mPr3OW8JtYNGtRw+ch9/fjYGjiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wapcYXCEsl1YGY7VzcvHU7V1Vahm3XJyPHuI/+AO7u4Dfa/oMnDCGY7UZ0O7JURyl
	 3YteFf0cwGVEgINlE9V1jFXBlgQjuRMWIiaEzq/Js6Hi5n6Xb1m5hhGqX+onjbNaFY
	 IiyzAKG/sUYRKvOFYX6dGrksmhBwVTtTQeGr40X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1573/2857] iommufd/iova_bitmap: Ensure that iova_bitmap_set() handles the full IOVA
Date: Wed, 18 Nov 2026 15:43:27 +0100
Message-ID: <20261118150258.021911877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted error propagation to the older VFIO window iterator using a newly added bitmap->err field ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/iova_bitmap.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index eab0de7799fa2..fc9d4ef74ddda 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -112,6 +112,8 @@ struct iova_bitmap {
 
 	/* length of the IOVA range for the whole bitmap */
 	size_t length;
+
+	int err;
 };
 
 /*
@@ -380,11 +382,11 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
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
@@ -407,6 +409,18 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
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



