Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208098;
	b=qukavZP5GavfQIkkYoskXTI0Z+3oIqHhsOroa/lY4rgbZqR/F2F3JuktX93FgJF09Xi7
	 /o68Na99DTvyURun5kLf6B6d7WgKubm8gBNRicSzBF5rL3KkNBS1oWGs2UWxEiXNGTXzc
	 ZAOstmacHqAjFOsnD5tQczDFIWuvp0dKdy/TSdiS7Ev5upfsO8UY9Xf6SwB73wDvgsOf3
	 ItM2tn61kpni6RLJPg3zz/BJlvTDkksFrvYJlf20cuFs4QEQJpi//RveSKALQyaSKAHt6
	 4NVjSeSh8e2zXj1B6/ZK+SK0BFR/MjfDLd6HxzqKy5D4gI+nbN0yurkah9ttwHb62qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ViczhDchw0FoZ2UWUo2Chmo0rhCZ+G12IJj+cBg8zK8=;
	b=n1RiNjWXdf656MJR4c/p6uG2goU8beZt5miJL8UqYpqYmnX5whK1wBhecdc2+pw5/R5u
	 mKFQhqvNPOkQtwe2TWrjXZcPGTxnDz8yHeWi78nVwTeWvJtcZSZfFJ3dXs26obWsxgz3L
	 nOk85oRSk60y+2h/BkzTDv1oXlhV/PEe6YJ9lAbp4uCbuL4jgXwUmAsi3KCyLXHkH8L9w
	 7GcJsNVnHq1aG7OuD+LluR34JJOX7OoKmi7Ov2yDD5A/Q6cl/VkDsrbR+TFxpRzXa5VJf
	 2wsxq9f6jKq1y0lI7pZrC0pH9fJ0tyLewPnebBUQuh/RQhy1yD5o+t0MxIP0cuVJ3ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dPhqqufZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12330606A31E;
	Wed, 28 Oct 2026 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dPhqqufZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266091F01825;
	Wed, 28 Oct 2026 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208097;
	bh=ViczhDchw0FoZ2UWUo2Chmo0rhCZ+G12IJj+cBg8zK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPhqqufZ0VaWkfM8v24facuSZBu5ZzCcheZYNQvwc/t0WHiFi5F4VQzPD+jON6400
	 3VnR+NyjnDuWkOfmYYPNvNC9j1Nhp3b0rhsvwpvTCibvLD/6KBHLJDv2HINC4q2oI8
	 0trVyNSXuReugGpEBKsL4PFJdzETDEXyDOqyTOJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juanlu Herrero <juanlu@fastmail.com>,
	Anand Natarajan <anand@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 222/247] io_uring/poll: avoid retry wakeup loss when dropping ownership
Date: Wed, 28 Oct 2026 18:00:25 +0100
Message-ID: <20261028165952.678531165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juanlu Herrero <juanlu@fastmail.com>

Commit 937d38dcacd675dc0572d6c9b6743960df3128ed upstream.

If a wakeup sets IO_POLL_RETRY_FLAG between the owning task consuming
the existing instance of IO_POLL_RETRY_FLAG and the loop check
of io_poll_check_events(), then we stall on processing the request
until an unrelated wakeup comes along.

Using atomic_cmpxchg instead of atomic_sub_return to guarantee both the
count v and poll_refs are 0 and no wake-ups are missed.

Cc: stable@vger.kernel.org
Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
Signed-off-by: Juanlu Herrero <juanlu@fastmail.com>
Assisted-by: LLM
Suggested-by: Anand Natarajan <anand@meta.com>
Link: https://patch.msgid.link/20261013-pu-cmpxchg-v1-1-4ddc10fd8a03@fastmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -350,7 +350,8 @@ static int io_poll_check_events(struct i
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
+		v &= IO_POLL_REF_MASK;
+	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;


