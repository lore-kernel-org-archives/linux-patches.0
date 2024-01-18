Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC27E2376B;
	Thu, 18 Jan 2024 11:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575748; cv=none; b=nsSJOMw375t+kRsGfDI/jyjuj8N2/9S4uzhQGiQ8rG82u7FB7K9gHSjja1N4qopQ/8hn8hSB8rFdqtHWNFaH9EcRTGBKX4MpIdWV9lsu0Wb9aTzOhD7k+4he9Yts5VFHa20vDMJiPPPtymfwgOznyM7qDQ4Z+nZJR9YWSh7jcLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575748; c=relaxed/simple;
	bh=sMZjwi/XSA1FpRairV2pPYFyC1jLA0cCLlJoT75fhZs=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=sDydx+X7XXH2JbDCOg0Pb7o2FWbg0BdFAnSzlj4ME424yV4feC0ZNeWY+lhmWMbQ4ATahTftzjj0vfPI7TkOr2YwxJ6xNb/JPB7JMiKbzF/LwLvFxSVbdb2KSkmieCHQ9DgKvorqQwHJpcdWyyp5kA4HsWHQfjKOO7ipltt8MYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahkGhDy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahkGhDy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F689C433C7;
	Thu, 18 Jan 2024 11:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575747;
	bh=sMZjwi/XSA1FpRairV2pPYFyC1jLA0cCLlJoT75fhZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahkGhDy/x0454sFKC5AnU7f0nMjk5qi/pEH2B9+X+uPwO5yI3UIXzZvJXIBoAF7hV
	 GhNpJ97r5Mz+kjEBwYu8Zw3QQQnxgN+SZWt1szYu3fwimCELMrDmc+0ojDijyOhHbJ
	 qKacEE/7TCabRFJZH2gF+1qAWn1FwEn9l266GiLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.1 090/100] binder: use EPOLLERR from eventpoll.h
Date: Thu, 18 Jan 2024 11:49:38 +0100
Message-ID: <20240118104314.823129832@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5005,7 +5005,7 @@ static __poll_t binder_poll(struct file
 
 	thread = binder_get_thread(proc);
 	if (!thread)
-		return POLLERR;
+		return EPOLLERR;
 
 	binder_inner_proc_lock(thread->proc);
 	thread->looper |= BINDER_LOOPER_STATE_POLL;


