Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B3023BC;
	Tue, 23 Jan 2024 01:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972162; cv=none; b=T7qMCKaa62fomYx5hhFz2jBC02+uT84wbRRfRMUaxALdB5Mof7C3g8Zw133+i0oTKu9BHVOnUGHCQpZj4y3Vn/RN7919tUgck8DBPRQhhjN1E8WeSV8TXjbp7im1lIkddK0KbG/vK/OfN3ZpAHMSCAv5LXDC7UUhuX9W2RKPnOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972162; c=relaxed/simple;
	bh=7X0mcwtiYK+/v9vTXZClEi1RSYZEM9YNydLotktvJ74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rR8JmKU4rjls2NZPNqx+hsuAswC1OZ3HIjd9XhlnPAeMdcCL0p3VL+Tg6b9plUnYwTTJP5BYbt1/2/lMeo1EV/aIOxtFsTjlv6EywyDyxyAVkFDUd9UvqAKLMh2uDn5NMw1MfkbjIY444KNiTv3qwAwX8+eOuUSINB99TX/EQSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxz3LGH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxz3LGH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1692FC43390;
	Tue, 23 Jan 2024 01:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972162;
	bh=7X0mcwtiYK+/v9vTXZClEi1RSYZEM9YNydLotktvJ74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxz3LGH9OpKG5H9kZxzNjMrP6GsefTX1Iwrx4kVMjTef+xPbbQ9ZgQ/R/Rat20F7d
	 vY/t2xbwfGAKYbojodZ1PaQ4VZU/SVd0Vr8TBYkaHzM150EAvfr1iDXmrErSeEPEcQ
	 aJuSE7VvGGQbqQx125GJMgmrgb7svt/FzFfFep9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 055/374] binder: use EPOLLERR from eventpoll.h
Date: Mon, 22 Jan 2024 15:55:11 -0800
Message-ID: <20240122235746.522072018@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 6ac061db9c58ca5b9270b1b3940d2464fb3ff183 upstream.

Use EPOLLERR instead of POLLERR to make sure it is cast to the correct
__poll_t type. This fixes the following sparse issue:

  drivers/android/binder.c:5030:24: warning: incorrect type in return expression (different base types)
  drivers/android/binder.c:5030:24:    expected restricted __poll_t
  drivers/android/binder.c:5030:24:    got int

Fixes: f88982679f54 ("binder: check for binder_thread allocation failure in binder_poll()")
Cc: stable@vger.kernel.org
Cc: Eric Biggers <ebiggers@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4836,7 +4836,7 @@ static __poll_t binder_poll(struct file
 
 	thread = binder_get_thread(proc);
 	if (!thread)
-		return POLLERR;
+		return EPOLLERR;
 
 	binder_inner_proc_lock(thread->proc);
 	thread->looper |= BINDER_LOOPER_STATE_POLL;


