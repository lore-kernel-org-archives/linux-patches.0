Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929922AD04;
	Tue, 26 Aug 2025 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215075; cv=none; b=b/H4pKHZ4U7QoHOiKGbXyM27tU+Amxb6k207I7NkusEOC3ag+dIt9vBmTngzn1JsNUWrN/yjzxTShvNFEFb7tDnKBoZx/1ElzXO5DLfFEYpnmkH5HmccTnnJVfSOQ6VswpGbKAPMd/eDJMmzHP37O3FY/XHj9/i0XZFcAdY8RnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215075; c=relaxed/simple;
	bh=JrC58ynnqjIrrpJ8oAjoRZEzWRv5/9kXerUcWlWNLyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVNySjhCvnwzyP0RQq94Bo1GGmBSahP7WZzeZ1Meqh6jZz/G+pLu5u423p1n83HiBDXR/Gp61S+zXzhNmgMsr2GGk6kUNs9dj0+u5d/SA1wSDc+bQ7LF8r1Tp+foGoUPKfWrNj9jhEPB17mdFJAWsyp+HBBbThXPIHgGF4g2t/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+LeCC+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+LeCC+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00AC116B1;
	Tue, 26 Aug 2025 13:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215074;
	bh=JrC58ynnqjIrrpJ8oAjoRZEzWRv5/9kXerUcWlWNLyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+LeCC+PEHEHF+V5jC2xcTirihnOhztz0hU4ZOOq4S+tNJxfRaIsIP1b1yUNBgSmo
	 yh2EB/oaX53EdLW6AZXYBo1noXXR7PdoWLmklxpfz/JAgy2elqKiVM/gTcUTpwpG7V
	 1u6bCZtVTCnt3jJ1wclMMdYXMwHpJu0J9o1YqUmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	William Liu <will@willsroot.io>
Subject: [PATCH 6.1 377/482] tls: separate no-async decryption request handling from async
Date: Tue, 26 Aug 2025 13:10:30 +0200
Message-ID: <20250826110940.144511996@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sabrina Dubroca <sd@queasysnail.net>

commit 41532b785e9d79636b3815a64ddf6a096647d011 upstream.

If we're not doing async, the handling is much simpler. There's no
reference counting, we just need to wait for the completion to wake us
up and return its result.

We should preferably also use a separate crypto_wait. I'm not seeing a
UAF as I did in the past, I think aec7961916f3 ("tls: fix race between
async notify and socket close") took care of it.

This will make the next fix easier.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/47bde5f649707610eaef9f0d679519966fc31061.1709132643.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ William: The original patch did not apply cleanly due to deletions of
  non-existent lines in 6.1.y. The UAF the author stopped seeing can still
  be reproduced on systems without AVX in conjunction with cryptd.
  Also removed an extraneous statement after a return statement that is
  adjacent to diff. ]
Link: https://lore.kernel.org/netdev/he2K1yz_u7bZ-CnYcTSQ4OxuLuHZXN6xZRgp6_ICSWnq8J5FpI_uD1i_1lTSf7WMrYb5ThiX1OR2GTOB2IltgT49Koy7Hhutr4du4KtLvyk=@willsroot.io/
Signed-off-by: William Liu <will@willsroot.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -274,9 +274,15 @@ static int tls_do_decryption(struct sock
 		DEBUG_NET_WARN_ON_ONCE(atomic_read(&ctx->decrypt_pending) < 1);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
+		DECLARE_CRYPTO_WAIT(wait);
+
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  crypto_req_done, &ctx->async_wait);
+					  crypto_req_done, &wait);
+		ret = crypto_aead_decrypt(aead_req);
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			ret = crypto_wait_req(ret, &wait);
+		return ret;
 	}
 
 	ret = crypto_aead_decrypt(aead_req);
@@ -289,7 +295,6 @@ static int tls_do_decryption(struct sock
 		/* all completions have run, we're not doing async anymore */
 		darg->async = false;
 		return ret;
-		ret = ret ?: -EINPROGRESS;
 	}
 
 	atomic_dec(&ctx->decrypt_pending);


