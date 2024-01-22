Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB760257;
	Tue, 23 Jan 2024 00:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970900; cv=none; b=pwzo7yRJ4HhHzBDga6krPPAKTjVvd0VuVR/Xk69wqGdiZCYG/N9QmptIwY+eUhstvjN62miDGo2GaSxlPG9wlHbK84STTqFQpBYoHJsNliiTekRwlMEunjodDd02G5qndma5D2unX3eoHBPq3e2iLUH8H3Xt3EPVLvmghzCD3AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970900; c=relaxed/simple;
	bh=M+A2ZSJf3s8Jdd3Ojzf/2tWd7q7eDK5hbN0qC0ZMqoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+zdpkAKNjmzyBVa6nICrmVd6iX4qToK8Dc0tMyOJ993lFuNrBcEy08Eyzkp4WY7kICDa7HfcxDvAOmKMBbllYXDbMcEy6CJsowWdQYhAxce+dpJ7jgi34wHF1VOcw6HLjwfViNHIw+xkCQdJQUcFx1UdCpEuQ+Vd7IDG8h1Fmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwC2iTZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwC2iTZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4722DC433C7;
	Tue, 23 Jan 2024 00:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970900;
	bh=M+A2ZSJf3s8Jdd3Ojzf/2tWd7q7eDK5hbN0qC0ZMqoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwC2iTZ1CBE8R7Vy7AaI1FGMqxNvBXzVgdscTsVw4yFfFcOWjlujlVMMcrRsyrMcN
	 wcf/g7rLz4ylBa77CbgSkhri10ZUb/zndjRsJCfTk1rp/CL+IWOpdoT2uNHPAkiEvL
	 Gsi+l3NeiZe7J4i0MDT46SbA/CITsSaIjyIkX+zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 041/286] binder: use EPOLLERR from eventpoll.h
Date: Mon, 22 Jan 2024 15:55:47 -0800
Message-ID: <20240122235733.591406582@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5173,7 +5173,7 @@ static __poll_t binder_poll(struct file
 
 	thread = binder_get_thread(proc);
 	if (!thread)
-		return POLLERR;
+		return EPOLLERR;
 
 	binder_inner_proc_lock(thread->proc);
 	thread->looper |= BINDER_LOOPER_STATE_POLL;


