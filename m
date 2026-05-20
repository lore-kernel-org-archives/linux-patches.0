Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB39332EBD;
	Wed, 20 May 2026 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301629; cv=none; b=rMRtlPEkEnZJzgoTA+X4ZIrs9RGDVJCFXSsKS0sitZmLTMD4QNLpO3F8NjoyH/im4jh60xfJ+FvVBgJjYuzXc3KQQyNR94eCLXTpkptVBq5GX+ptqBdpgZvkFuNpX03SVBS3a8by59YjmgG4ADEcKorIFV0DdHdAxaAR8fGeGww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301629; c=relaxed/simple;
	bh=ObLIzGM1sdZOSj8KkaY1JzeH9T9c9FnimX3TsGrq39k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAoAeSZLOhQoPaRHTuarlIB0qxS3Ez9WSnMzTUSie6rK/I1/FiN0PYWu1FoNuxdzaCzkuDjDuTezHK0mrbnRIWjrayKjegTikT966a0g8h8XuUC3Jwokg3//g2VNffsdTl4QelCFqbziUCjUrBVL8+Va7Qd2iDhVYwIdUw5J7Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtG7xeZe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtG7xeZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE271F00898;
	Wed, 20 May 2026 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301628;
	bh=kHtD79nHGcW3HHQ3YZpRmPBtv3yupFFWwCZ6xXsvHVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtG7xeZe3DxYuuwCC1dQ9337eTm/SdUf645Es7Gmpx8Rs0WDu9jceTX6AzvpYfHci
	 o8z5Wg13SGbK2LFQJAhDm14sgA6aENJRBADKbR5GDh/U1FSvJembVXIEUXKXHTtvGw
	 eCr/USJXYQrtFJBliF7TNsdhhUeal9DgVqKD/T7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 610/666] crypto: af_alg - Cap AEAD AD length to 0x80000000
Date: Wed, 20 May 2026 18:23:41 +0200
Message-ID: <20260520162124.492270124@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
@@ -586,6 +586,8 @@ static int af_alg_cmsg_send(struct msghd
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
 			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			if (con->aead_assoclen >= 0x80000000u)
+				return -EINVAL;
 			break;
 
 		default:


