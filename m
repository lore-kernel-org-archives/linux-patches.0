Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6D433E36A;
	Sat, 30 May 2026 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162046; cv=none; b=E1ELIKiKFr+6izZVYFNNTYHfSBn3+6pHlQLe3FuPddqgeejrs8K9QlxKTAJQinhrBZckLcDjHcpqakgukFQJR75Ktbb2eDmkQ0XvOSpiXKonbKfYH9kigNQW2qXePWKoxjtjGDRrRYecgb2jHXIouq4Bj0prxmN/FcPjOQN8Ql8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162046; c=relaxed/simple;
	bh=dktG7vUzhn3jPisHLNDNKPJhE3DwuzFy527jxitmfBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pafTJ2wIORV/hJKrNFXNMsbuniZfcIsXQZrpTdHM0GRrmGRogDXY+PcLPolzRS9aNysQoSRnsOJFjl+Ig55nuy8r9+s5MIwUy6Bj4E5Q/of3VgdMGYGmqFZWucHWYbS0Fubr7CJyNbaGrFjTzIWRSXsZZ0rLspNUz6JHDp3snOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+mceqYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+mceqYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DA61F00893;
	Sat, 30 May 2026 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162045;
	bh=fzo9zuoEKTIMrGQhyY9bDcuxKrKsAvpKjBz9lSVgTL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+mceqYLTkq1911W8hXAAiJxQHEh0Pb9A6BxGGEbC8I5MG39vWbFD//k6kwUuxkkC
	 AtnpPH6t9ig0eni0MOQ3ao3KhYytcxVu9msi3urXAMC/M6McIUR4GmFJPJs5nkiZc/
	 8C1XtGhR39S6Ds1deaRNVQDfrymYQYFUlC3PPMM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 805/969] crypto: af_alg - Cap AEAD AD length to 0x80000000
Date: Sat, 30 May 2026 18:05:29 +0200
Message-ID: <20260530160322.859980917@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit e4c06479d7059888adf2f22bc1ebcf053bf691a2 upstream.

In order to prevent arithmetic overflows when checking the TX
buffer size, cap the associated data length to 0x80000000.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/af_alg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -475,6 +475,8 @@ static int af_alg_cmsg_send(struct msghd
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
 			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			if (con->aead_assoclen >= 0x80000000u)
+				return -EINVAL;
 			break;
 
 		default:


