Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050848;
	b=JsIYQ5ji1uWnERQR/DWGOuk97mbqfmVG2D/S0aDSTJ9nlebZXZTYB0jxL3nX71X4TMrY
	 V7lHcFP5wKuIbdwlVknX3y9HKk27B9b2siRRdptro7MHJ5HHry0Q5tY+xeKzX+Nj09WV9
	 Lq+VXfL+OxaJdBmE4P1au6A+gmQ61uCgAVTfAnXeYX+tp/RIPOUCmHNoJeVEtI10uajdv
	 aXBq+B1PfsxeSZVQ+Wwb0W8MKjyoz5uyHUJH92JwrDsdgUVX73QrIAR/aRe4Tqak4156L
	 77MvGYT5TFH5oKFokay3xm8i+WSnOc4H4rXPnBihev+CKBYm5NvDy/KTew2WONWKZQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=meug8wogszFTA/oQiyV6tVDknnkiZGzJcGGc+nybscU=;
	b=C41JyC3QbmwzLn+rZ4+Jo/Fs1ZohYLbYEylrdEudukVN+ItF4VozOPDFT/9tDV33rBEC
	 7iGLyEx5M75ogRVNGcH4HAle9WgthOm7dbwH+S7xAVdZ5fNYVZWUT1kS4vJ5mwoEzfmDm
	 S2+7SM/dCwbdnHoXCam/cyAldxIItTlIwQLpFo61kNON0b8M+tbh/4md1gGHXAq6UoFEw
	 V+ItBKTloPsbcgYKqX7vtW9AUACnoPwcb9VDH2cuVsxrovPeuXRGrSZSGtDzaLDd+9BU+
	 EGjSgWO8mBuZK2Ji5x1mDuh20H/k0M/UAD5HYAfl/aRJvsUm1Xl9THRCcLPsS25HP3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9D0ydtO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADD3606A32A;
	Thu, 19 Nov 2026 01:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9D0ydtO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1981F000C4;
	Thu, 19 Nov 2026 01:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050848;
	bh=meug8wogszFTA/oQiyV6tVDknnkiZGzJcGGc+nybscU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9D0ydtOun6VihD/sDmNdktDPDWSYKk9a0w2qQvZye4gBFDE/mkYj9i7e8/s3KIVM
	 Mnv/mPv/97Sz2pWYHZxeDx4doEZ11vJUiICBwW2aBCHROc/5DpFo8lYUSzoRAPi8c3
	 u+fOPeLIYXhIS9ElqR7OUTGXlBoe2Zd3wsP1oY+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 2855/2857] selftests/net: fix EVP_MD_CTX leak in tcp_mmap
Date: Wed, 18 Nov 2026 16:04:49 +0100
Message-ID: <20261118150344.377349646@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

commit f4ef35efbb49527293309f668ea73ec5de9b8e7a upstream.

In tcp_mmap.c, both child_thread() and main() allocate an EVP_MD_CTX
via EVP_MD_CTX_new() when integrity checking is enabled, but neither
function releases the context.  child_thread() misses the free in its
common cleanup block, and main() returns without freeing the context.

This results in a SHA256 context leak on every run that uses the
‑i (integrity) option.  Add the missing EVP_MD_CTX_free() calls to
the appropriate cleanup paths to fix the leak.

Fixes: 5c5945dc695c ("selftests/net: Add SHA256 computation over data sent in tcp_mmap")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Link: https://patch.msgid.link/20260702025949.442523-1-wangyan01@kylinos.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tcp_mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -297,6 +297,8 @@ end:
 				ru.ru_nvcsw);
 	}
 error:
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	munmap(buffer, buffer_sz);
 	close(fd);
 	if (zflg)
@@ -587,6 +589,8 @@ int main(int argc, char *argv[])
 		EVP_DigestFinal_ex(ctx, digest, &digest_len);
 		send(fd, digest, (size_t)SHA256_DIGEST_LENGTH, 0);
 	}
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	close(fd);
 	munmap(buffer, buffer_sz);
 	return 0;


