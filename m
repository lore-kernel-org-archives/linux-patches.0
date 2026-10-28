Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207065;
	b=wZZ02RPDeuCnyjwrAROoZgTP4Q1GSSmL2aXjKAlEJwlKdnjM9fVkw0curigrvrEDotCl
	 bn2+tqIaQlnWw0z9U1Z2fD677wXnDAMkY3ur2iAlyQ2UBa7mWYFdMtaoiF0HBFWQ7MhM+
	 kXWFhq1Y1YvMpbIvvw58+N+rKqO2TUWyKmTLT1KL5YQQP8ci/9oYrRD/j/vawLTkeSuSL
	 VcYCQBeqAzia1OF9f320aKFihBquX5PHJ59rJQoX96DfVMCk0ENzkFMWRJGUnZqkcStcN
	 QZwuMx6ILs4fCnC9/BbjGCvHgRIkOmxIGwMI7ikblSFePZ2P+LNMXfIFj9poWrRulBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wpbMM9gjmPEAR7Bvn86tDNwVmkEiN+5q2IGPp52p3o=;
	b=TOVB9cx+LtmiJ50rLuEcfCy1JSB2qhpyLyA3xkychzCzmPd2E7belQRm4sCyp+ygFR4Z
	 0uFxMX61PJDvWDtvkM43b98hXwgEW+dVErUhfCOF2+XvyLv2spMqHkZAfI/Dw4R3gjSo0
	 fEVKYZo1ih2M4wU4+E8Qss2c2SZZPeFc6ZTHhV2M+UbK3NcvD6UGwaY6UyEQHm7YoXW+2
	 CJvvrBZ3b+/7SsJByssOiRc59E3GesbS4pWadkSOI8wQyBak7WByHxEGVPkr/ePxppjxM
	 fF0l/3Don5eroW2tNXKXZ01PvSfiNa8FMpnB7695B5rGSzZgAwDTPRl6fzu7eTaAwkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KZweeko8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA13606A31A;
	Wed, 28 Oct 2026 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KZweeko8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870A41F01825;
	Wed, 28 Oct 2026 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207065;
	bh=9wpbMM9gjmPEAR7Bvn86tDNwVmkEiN+5q2IGPp52p3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZweeko8aEMSINcafxUSVP9+0K4IbJv3GdYbYRCf+AbbqdVacuw219vyxQY8Dlk2D
	 hJhrBt5oH6iWjQL8hY8AZGeNwRcZjqC5Svyj5KFg6kWyZ6Gym4GnO6UZ0ZzNLIRCkw
	 Ub16y8qiEjI369Lh9NyF7bsa0e3N6hGtXwl1HtY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juanlu Herrero <juanlu@fastmail.com>,
	Anand Natarajan <anand@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 14/38] io_uring/poll: avoid retry wakeup loss when dropping ownership
Date: Wed, 28 Oct 2026 18:00:01 +0100
Message-ID: <20261028165940.759766255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juanlu Herrero <juanlu@fastmail.com>

commit 937d38dcacd675dc0572d6c9b6743960df3128ed upstream.

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


