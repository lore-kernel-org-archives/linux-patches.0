Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EA823645D;
	Fri, 13 Feb 2026 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990816; cv=none; b=O9SncZOv0kugtl8alyTsMUb37dMPhVxHhVGQb1FirmDqkdG2/jRpcgANtodUjizklhfcd/ZYkvQPts0moqM8BHvCwJBDW8zm2EMpYk8H9iswlvvCDzCSv4wOQgdzyJ3bPWeK2wx3tt25XKvi9gM3SYtgn5dW+ryYDoY5z2j32DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990816; c=relaxed/simple;
	bh=QAeHQ/11yp+RC6xJfkDRd0NyLGORsWd5UHu1T5A0bW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNsk5dmC2g5RVHhHYEcyhmsXAap0UdLcksBvWQvP6ZGdmmcFEQ0dg60kFBKYf9zxYkMkGavHou8Bs4+1ZeAv6aYCQkPR6msgnWcAJk6OUMP1k7lGMuk5zjfkeHjczK5zHUdkU7NVnmdVc3NOlt7UQqysNqzt875u48m7f0tdwkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9KbTCzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9KbTCzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C70C116C6;
	Fri, 13 Feb 2026 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990815;
	bh=QAeHQ/11yp+RC6xJfkDRd0NyLGORsWd5UHu1T5A0bW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9KbTCzYYEilg695a5aRlliJIlcil8qGBkDpKkfo/MpWxuo927HEF+kXO139hPjmJ
	 CkFFLLGwQpEYjykN2ScfM57ntl+BvJCDrQTHsjjhG51zGm2Y9js9wcDtq+keWMU3oz
	 ztsPfJyxpJ0hpc84ZRKokP+qVPCSld2BprAtB6uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 31/49] crypto: octeontx - Fix length check to avoid truncation in ucode_load_store
Date: Fri, 13 Feb 2026 14:48:15 +0100
Message-ID: <20260213134710.021350489@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 5565a72b24fa7935a9f30af386e92c8c9dfb23b9 upstream.

OTX_CPT_UCODE_NAME_LENGTH limits the microcode name to 64 bytes. If a
user writes a string of exactly 64 characters, the original code used
'strlen(buf) > 64' to check the length, but then strscpy() copies only
63 characters before adding a NUL terminator, silently truncating the
copied string.

Fix this off-by-one error by using 'count' directly for the length check
to ensure long names are rejected early and copied without truncation.

Cc: stable@vger.kernel.org
Fixes: d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT engine")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -1326,7 +1326,7 @@ static ssize_t ucode_load_store(struct d
 	int del_grp_idx = -1;
 	int ucode_idx = 0;
 
-	if (strlen(buf) > OTX_CPT_UCODE_NAME_LENGTH)
+	if (count >= OTX_CPT_UCODE_NAME_LENGTH)
 		return -EINVAL;
 
 	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);


