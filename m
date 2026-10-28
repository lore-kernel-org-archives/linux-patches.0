Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212150;
	b=LX5HGzJ+LlDKZnSjuoMy2jGH7Q1dTRVbnOUsROr3IEHO5aScsp8JgeJMNV6vApyqQX2X
	 k9Oew50qLB7WM9X2PhjNTWp/j8ld2bw2BK/LgNCYpxS1JNTJP8kjooQ3/2a4VAYJ85bxr
	 CCxN+0t/EGZYdoMc1B2slcoSeQ+2Kvbh7h7g7eyauHzCa9yvcH42bZFkd3zIpTxdFZ9Mv
	 TJg/z/2B5Ib8mCrbmtVJ3eYunrUj32Bx7yFeELMtMsXMwReZeeqepc53b8GL240t6EsSc
	 jrsU7m75syEdm/NYw2T9sORNrhIJXF5VtzXMBrus2YYXEZhdpmaXiImgDX5XeR3s2uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8mh6V8N04NxKH1CMT68qmc9yy2lsiLWtvYYYaKgilaM=;
	b=HJNss/EucObLLjEHSxBASQ+zs0VRktkiIDaMK2Dqpgf45Vb9vedsAeUlR4jaWuy920VG
	 RPV4eqS9pVVq/bq+tZJbeBk1/3JS+oeCelh3R6kVNDmv/KCIovyn0PvPdPHYiPRbtvrLl
	 bls6ph60iKCzEv8G0mbGtWAbwPU+nQLQzrCr8dKoxhHKR8jJAZlSw0GVVgOj/I0oOvqIG
	 lY4tE2eWyP5Eo7va4jJT2UZpFebl3rKpqsCLVJleebLXJaShVhYJdy5Wf3tgUhwi6asM3
	 BWR7U4kCe/RURrHFRk4T1sqaz6if0WWYHK16ycpW6soh+d5PcpIzktu2ZHqJHY2lbtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMamV8n1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B1F606A31C;
	Wed, 28 Oct 2026 18:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMamV8n1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B121F01825;
	Wed, 28 Oct 2026 18:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212149;
	bh=8mh6V8N04NxKH1CMT68qmc9yy2lsiLWtvYYYaKgilaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMamV8n17xpBN3mPs0LOuImo+BwW/KADhSDZ4ySVZy6SvXj8cc/I4ds4ILgg8u1vY
	 n7eeHCv93AwqaCk3yk3lb41IHzaxXAnCWUnkf8IniJGPAGkRsp8MU4Bd+88vSUGZB0
	 RBveAtx5vtz6pIpF53M5hGiDs/y99Hq0zKPXV2vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juanlu Herrero <juanlu@fastmail.com>,
	Anand Natarajan <anand@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0018/1887] io_uring/poll: avoid retry wakeup loss when dropping ownership
Date: Wed, 28 Oct 2026 17:35:14 +0100
Message-ID: <20261028170459.636886941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/poll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -325,8 +325,8 @@ static int io_poll_check_events(struct i
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
-					IO_POLL_REF_MASK);
+		v &= IO_POLL_REF_MASK;
+	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	return IOU_POLL_NO_ACTION;
 }


