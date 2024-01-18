Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2288F1B96D;
	Thu, 18 Jan 2024 10:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575455; cv=none; b=B33wTM/uKxsOmhqZxtJ+A+9mYWcvbxUfRqoMlX6B4Ofh+t+maXXgp7yflqK3ssbEzeN4jOMejayewYB+6QIkNT+SP5onMQcGfknt57tyCYGRWy5ezp5Mp/odJYq3j+UAqM/8wSUO3n7ua915TnX09ijjsfXe/s6X/HpKiWDUdN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575455; c=relaxed/simple;
	bh=nCWpcWCvlMEv0dGs5fTVCoVpRIWI7h/dP8cIhqtUioM=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=XVj/VFDBYy1fb+WqzIZwdbDTSYAHYtpc4/vb9Ba6a1iyfHa1vLt3fX8ywP18sHRjau+8nDGdrun37vI514DAjuktNnd3tiVLX/R/veh6ZBwcym/9AI0towhAoVvh9cDtMKt+FSGSKholcm1R7+IdDba+Vk7pZK86Pd+1hU30Rjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvvXo5RM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvvXo5RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B138C433F1;
	Thu, 18 Jan 2024 10:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575455;
	bh=nCWpcWCvlMEv0dGs5fTVCoVpRIWI7h/dP8cIhqtUioM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvvXo5RMWSAH4gRQ941a9nmQ6EBfovDjDUm6rdFFgKcmGZCUohk2u7Ah7QmcNIYFu
	 APzDYipUdK2InuX4sy587lLY9jnBDxJozWQzcol8ibFeJs1qyY2CteHcJEuQT/Db+4
	 ST4Bw+zfPZZXyGnqpXqvsY2S5/ds6G9Tf6f07VUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.6 139/150] binder: use EPOLLERR from eventpoll.h
Date: Thu, 18 Jan 2024 11:49:21 +0100
Message-ID: <20240118104326.488056519@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


