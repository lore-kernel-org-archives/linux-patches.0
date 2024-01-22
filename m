Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B91612A17F;
	Tue, 23 Jan 2024 00:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968817; cv=none; b=WGZrIJOJnFKxEFZ+uKC+joV3ft3LF7ERPQTuj718y/bUlNjIsucXMF2m7axJdw45dJzFsZrDW0Wa+Di64oKM1JcWMTSORudQjeQQlgL1e5J6RRrKcWw9AySqBGPsWcHxjkKMzHSPvQ6nffCaN5s1j6Y/w7UGTkcFvR1mnujo//k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968817; c=relaxed/simple;
	bh=otERdlNGVWSIAxjuUUD3ETnevjm21FNA7vyNfk1JmlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1DTvzgLxeBAzh5lVAS9WwTrW/sMJOh0DvHDW+J2lnMDPOMfuEPjsizTTp+onfJPz+LCyJONvMmb+Fw9AILmm6H4Q2SablIZ9acgIDEUKLC16HX2mvqLWJwevVSnyTazdhBZE3wlupnccQJXvAzK1Ub076UqAFNntYDdCpy2up4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ktyod8jA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ktyod8jA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8FAC433C7;
	Tue, 23 Jan 2024 00:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968816;
	bh=otERdlNGVWSIAxjuUUD3ETnevjm21FNA7vyNfk1JmlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ktyod8jAg24Pnv3VSOLIBmwv9bt9l15BAxeUoPEVvQkGSBdOkwbLPIL/hNZMX5ph2
	 /wgqIwS3GBOfMxfK+p/HAzPtUgIhIU+VD9xOZuxUVp5D0DcC1hfpPRiN2bKSsip1eC
	 mnLPyZekFMVgN5Se6Ev6odo6H2uY6yUW1UBdliGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 033/194] binder: use EPOLLERR from eventpoll.h
Date: Mon, 22 Jan 2024 15:56:03 -0800
Message-ID: <20240122235720.633150473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5177,7 +5177,7 @@ static __poll_t binder_poll(struct file
 
 	thread = binder_get_thread(proc);
 	if (!thread)
-		return POLLERR;
+		return EPOLLERR;
 
 	binder_inner_proc_lock(thread->proc);
 	thread->looper |= BINDER_LOOPER_STATE_POLL;


