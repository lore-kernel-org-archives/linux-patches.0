Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31BD53816;
	Wed, 21 Feb 2024 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521803; cv=none; b=MX6smQiGOSbTwXYdpoQY6S9gP3La125/zGqtptWY5QHXB3sNJLmPHPomM/ioT1j6NKcpXIrxnMl/Ra51UCx+p8xs0ie0BKfh5Y/ss9NlZf1uffsgJ8aIP695CnSZs3nQhiPQ5A9I4r/rXi/txzPoORIEO/5manJtUdXV/JZ9HaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521803; c=relaxed/simple;
	bh=RExbldwi9CnWdKZ/9VmcumkSMVlO+pPaR9GUNMQMgyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wm9R71VTIwMfSPL4S4Pe3yCOKEnwJ2JtDgn4JyHDsQ66rzhWHdY0cEYNV0RkJm2NQvwMvt9VgEYC6MP6MSykg4/x6jy9hLu994vacz2xtPH/Z6bcBuGZxYoH0rQ4Rf5foWMR/hYb4cYV/oocBwd1MMIDQG1trKAIzOFB0lHHh+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg1bn0od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg1bn0od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE2FC433F1;
	Wed, 21 Feb 2024 13:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521803;
	bh=RExbldwi9CnWdKZ/9VmcumkSMVlO+pPaR9GUNMQMgyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg1bn0od0urvZw5LrA1nK+epcJl3nheT8UGz0JaZJMFjQEW2b9mrj6fDkLuYlWIdG
	 fBqoPJ22R8EWqlOIxPqcoVCVV/mozwK9hirLSwbomuAlbRq73bT3xjJ7fx2xVVNxmc
	 gL19LS9sptddDfjdkWMCqeWlZ+xMIUVyoscSkiqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 4.19 202/202] netfilter: nf_tables: fix pointer math issue in nft_byteorder_eval()
Date: Wed, 21 Feb 2024 14:08:23 +0100
Message-ID: <20240221125938.309881970@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit c301f0981fdd3fd1ffac6836b423c4d7a8e0eb63 upstream.

The problem is in nft_byteorder_eval() where we are iterating through a
loop and writing to dst[0], dst[1], dst[2] and so on...  On each
iteration we are writing 8 bytes.  But dst[] is an array of u32 so each
element only has space for 4 bytes.  That means that every iteration
overwrites part of the previous element.

I spotted this bug while reviewing commit caf3ef7468f7 ("netfilter:
nf_tables: prevent OOB access in nft_byteorder_eval") which is a related
issue.  I think that the reason we have not detected this bug in testing
is that most of time we only write one element.

Fixes: ce1e7989d989 ("netfilter: nft_byteorder: provide 64bit le/be conversion")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[Ajay: Modified to apply on v4.19.y]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_byteorder.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -41,19 +41,20 @@ static void nft_byteorder_eval(const str
 
 	switch (priv->size) {
 	case 8: {
+		u64 *dst64 = (void *)dst;
 		u64 src64;
 
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = get_unaligned((u64 *)&src[i]);
-				put_unaligned_be64(src64, &dst[i]);
+				put_unaligned_be64(src64, &dst64[i]);
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = get_unaligned_be64(&src[i]);
-				put_unaligned(src64, (u64 *)&dst[i]);
+				put_unaligned(src64, &dst64[i]);
 			}
 			break;
 		}


