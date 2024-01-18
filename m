Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B3422F06;
	Thu, 18 Jan 2024 10:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575071; cv=none; b=ecgvd3Qp5s0AAI4lMRGZOUV7eVQnlYlW9nExJLgH448GP/yLR7a/xfy43/ZUsyHvxNSv0udWkhFaFy7LA0PhjrYeO4cuqfLYbIHfSvqRH+3NBw/xxZKzWEdXNiDFdX5+gQd7dxDtIN0v5c5cS5E2tn0syhOcqn8eNBtugMPicxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575071; c=relaxed/simple;
	bh=FJWzcH+SICKuUkTSFs7q8uJe4FqJYwWusw/9A4qViOE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=TSZxADTrqPR1KxWnUw0/kxUZLkAhlVnUz+g4dMsWkFjpHcg/w2girRcXq/x5JURWf5/FVdsFFJxdTpS57e2FHFGcqwinPxJAOOFutKhc4A7AZIhC5DKwsf9saZ0Sh/wHixczZvXpxSonzMr4uVCfUYWGEmax7NbjXa2Dexu8wt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3rAxfO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3rAxfO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982FFC433F1;
	Thu, 18 Jan 2024 10:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575071;
	bh=FJWzcH+SICKuUkTSFs7q8uJe4FqJYwWusw/9A4qViOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3rAxfO01NGMgFEn+o/vT3xg29BbszCDpu9/p53kPE6SE8+A2I6Bto9dqnK9DSSe6
	 9S5nTOnKMnrObyq/y7TfY5mPBE4ccDdNX2gwwANef9q2SwfwApjX6eXm5CIb61W8qp
	 V8xoxgGxYlIldG0O0E5tNeH2Tcop23eCQm61kJ0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.7 16/28] binder: use EPOLLERR from eventpoll.h
Date: Thu, 18 Jan 2024 11:49:06 +0100
Message-ID: <20240118104301.785323812@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5030,7 +5030,7 @@ static __poll_t binder_poll(struct file
 
 	thread = binder_get_thread(proc);
 	if (!thread)
-		return POLLERR;
+		return EPOLLERR;
 
 	binder_inner_proc_lock(thread->proc);
 	thread->looper |= BINDER_LOOPER_STATE_POLL;


