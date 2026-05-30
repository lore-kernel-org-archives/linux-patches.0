Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9711D63E4;
	Sat, 30 May 2026 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166898; cv=none; b=S5fNx80yN5dBg1dnh5QMJ0nsvy2BwiT0nxKrKXqb8TcejLBvv+0IXbRcQt6EqkJscW+rChqnFu44ru+gf/XwCeLrhGYv8IIwznvmGUC4ftFvD8GCnHiuRb3+xD5BuisSsmV2UJk+FAs0BrAH9MMQeQIhJvGKlLWA9H/aD79UH48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166898; c=relaxed/simple;
	bh=jpAO6/pvKce3UHf6N0tfCRJd7IWKOB9gPeOVNcWIV6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5YpbPWiIJJqzUXmAlUf0Re2Q1Ocrm6vkon492hFeOmEanmpbE/jp1fEkULeAKcEU10mKsq7kQk7QvyJhBNTr6f8BylMjoi/NcsCraTEmFrHrMJITPOJQUWDwSvvpJdx5QaoRMMX8so+9MrfmtqqLMUz/swzE03llJRyeX6rwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INORkEGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INORkEGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A077C1F00893;
	Sat, 30 May 2026 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166897;
	bh=udnp6IVZSclSgjnUI552Eep4JMMIEnN0NEXHP0m52Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INORkEGWmV/j7uns0UxJjfoRotphyNAieov+zcMHX7gHmvf+JcaVYNArkCvOwA43t
	 Kcn8VpbnYsS0BkXjJjPG1zTLSFAOX2sk4TA8zI/YJJKvbltKxv4B7ibLmweARue+Tf
	 8CH8OSZUh24ric6NMmNvvjFtDV4T1vXUcDKUw6vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 503/589] crypto: af_alg - Cap AEAD AD length to 0x80000000
Date: Sat, 30 May 2026 18:06:24 +0200
Message-ID: <20260530160237.827417882@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -478,6 +478,8 @@ static int af_alg_cmsg_send(struct msghd
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
 			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			if (con->aead_assoclen >= 0x80000000u)
+				return -EINVAL;
 			break;
 
 		default:


