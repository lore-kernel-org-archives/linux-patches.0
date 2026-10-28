Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207315;
	b=1+DFKm1WHyWgCx4D4iYXy3NUIef+71PEFSquue32alMTLIGsFGXi9burq0y+3r+hxPsB
	 BeAcOmCwQ74w83QcZHw99f4nh+G2GIE/Fx+VQe53FMtbHZovEl4CW1H/QYWYQ6cup0chJ
	 t5ZiDY0yTKI6WtJYVCAkcKGeT9MhKtG0CMVAeiWsmwaiJ5esUVFteZgllgUW9QFGsP38W
	 6RNB+HD3bxpDc8v7d8eSJF9cPgEoe5jUS8XhS4ZmMNuBPYIrm41/fRAxb6y7ylR8XmmlR
	 +fcnkSg9I10E1gys4mR+XTq7CPtW7O9Kh22OQudXoCmCgabOgQW7jb/XAX4Zg/IA7/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4p+delEiCoeIL6oDKnpIYfooCjbMKyCclAFxTAOQDG8=;
	b=OO0/mIuCP00c+Lt0CUr2OgeaC3cZqPz4/jW9wu7/vMTq1pXxUCmByVuxeWG89bDvxvJs
	 sN7HRo0w6VG9yt3BHnFkr0F6yCTm4zVzzVfYTs090mM/4yBVHuTgvJLDtynuq3QTrgt2r
	 S5rK9euv/0JCUVm4xSV6aBdWwRS7i+bq9NXpb88VYzsGlbEd9oT0Zj690y+mjWYJ/nQsu
	 Ne1APesJE4/PiCP8V+vMSH1p9TrrO+ZoDLefEcFU4kEazmxtDpCoXR/cX7gtwE0KVdzsZ
	 iBVMAfFBIey9RD/hdn4AsXCp3XxYFJumQPpaaCZUodu1faiAX35fwgtE1mTn09y1ekA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZpJFbxs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C9D606A31E;
	Wed, 28 Oct 2026 17:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZpJFbxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438C71F031E4;
	Wed, 28 Oct 2026 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207314;
	bh=4p+delEiCoeIL6oDKnpIYfooCjbMKyCclAFxTAOQDG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZpJFbxso5ePBVThLjQi4vr735hQVlsC5UxiNbOfH6sVFPZtci5H0RQCcixWy1LIf
	 PzQMeOFLi23HVAbEMI5c0wwoZRyuKVMg8H80F+9bPc7ur5RKbUV1Zdy7Kobt92VXt9
	 /oP4S9f7SSm4qDQW3See3ymgOxcR+8mmOpMuajh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juanlu Herrero <juanlu@fastmail.com>,
	Anand Natarajan <anand@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 60/88] io_uring/poll: avoid retry wakeup loss when dropping ownership
Date: Wed, 28 Oct 2026 18:00:08 +0100
Message-ID: <20261028165943.524610850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,7 +330,8 @@ static int io_poll_check_events(struct i
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
+		v &= IO_POLL_REF_MASK;
+	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;


