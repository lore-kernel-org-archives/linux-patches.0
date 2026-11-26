Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704509;
	b=g2APfRVRzhGntzXiQZ82yge4bNaD4BV3Js5ogxwsuDqNc5s+1hkpQ5tWwx9R0Il5k/ic
	 aI75ef5EBE8jN1pJdMdVvI9UliLKjT++II4hrK+xrSlDe+0f5LU3M0PZlvYzTNKITzz57
	 /iCB1veYUCjUGmgM+bH4fjVrBcj3EJ5i0G0QMiEwObFC6AMlJFEYoeldqhB7mGvk/kVCF
	 qvIJqz/exEtBFpbcpes3/kWJuDdHcjaZeiaPL+guXBM0PNXaP3w9V+O3iCVd7BsKYwytr
	 bTkFKcRlaszmslTCKaMwC9yKSq9ulQ41HmQkZYgpviBfcBWdEdT/XVFdZmhSqnvGAuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YEZW0sHqpxLUjV/oq8O3e3B0AVOfoThfSqqPs5DYo6c=;
	b=QuuIFSx5maqe0dr/6WeeIjIUtyd6PxkR06fZLJfjzM1c/xmjVzi54vifKSFAK+tlVO/s
	 ayJeBYfCzkHWLtPIPRZcA+8fsKsdFLO5Rfkpbin0Vwfxktu1HBxjjUf6bDzpNFsVeNe6E
	 159Hxwu+x5QiuGXERJY8UH9fy/jNIE2BqbduILUpEQ07vAXw1msFk1vpmkKs9fS635IyZ
	 eTQ4NT/wfT+dZ706kMdhfBkBbM8Dj2mNrnz71Rjqc0GQfhEu042an8jwEuQaL4KvK8A6m
	 YsY7Z/y/tRRnYlrf9JoJnPLyJz6L3puJFuB5skE5O+LbrVm/2+5mrPhjApP9jHa1fHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U1/4xmTo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02973606A32D;
	Thu, 26 Nov 2026 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1/4xmTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018921F000CA;
	Thu, 26 Nov 2026 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704508;
	bh=YEZW0sHqpxLUjV/oq8O3e3B0AVOfoThfSqqPs5DYo6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1/4xmTovlrFI/5lhkX54WGSfAueUXRzWVmFDW56kzrvrGkJlZe+r495TU7QP0Ebw
	 w0GltUi8i/TUAQt+WKKhimQO8Wy4YHXS8UOeoeFO+rOime/wMguMxPnJyE6PTAb9bQ
	 GYgS1c87EtX5dhK3xxAvTnOefh7/YZgU+Ws9FeMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 150/265] aio: dont let exit_aio() return before complete() is done
Date: Thu, 26 Nov 2026 15:38:00 +0100
Message-ID: <20261126143615.558874800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit ac4b449b39e605123c12ea10042cafc9b6f39603 upstream.

exit_aio() kills all contexts in one go and waits for them with a
single on-stack struct ctx_rq_wait. The count starts at table->nr, each
killed context drops one count in free_ioctx_reqs() and exit_aio()
subtracts the empty slots afterwards. Whoever drops the last count
either calls complete() or, if it is exit_aio(), skips the wait.

With a full table skipped is zero and atomic_sub_and_test(0, ...) only
tells us whether the count already hit zero. free_ioctx_reqs() runs from
the percpu_ref RCU callback, so if exit_aio() is off the CPU long enough
the last callback can have done its atomic_dec_and_test() but not yet
called complete():

    free_ioctx_reqs()                    exit_aio()
    atomic_dec_and_test() // 1 -> 0
                                         atomic_sub_and_test(0) // true
                                         kfree(table)
                                         return
    complete(&wait.comp)

complete() then locks and writes a completion on a stack frame that is
gone. So hold an extra count for exit_aio() itself. Then the last count
is always dropped by exit_aio() after it waited, or by a callback while
exit_aio() waits for it. An unprivileged user gets there with four
io_setup() calls and an exit without io_destroy().

Reported-by: Kyle Zeng <kylebot@openai.com>
Fixes: dc48e56d7616 ("aio: fix serial draining in exit_aio()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261030-work-aio-exit_aio-v1-1-83942022a4c4@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -894,7 +894,7 @@ void exit_aio(struct mm_struct *mm)
 	if (!table)
 		return;
 
-	atomic_set(&wait.count, table->nr);
+	atomic_set(&wait.count, table->nr + 1);
 	init_completion(&wait.comp);
 
 	skipped = 0;
@@ -918,7 +918,7 @@ void exit_aio(struct mm_struct *mm)
 		kill_ioctx(mm, ctx, &wait);
 	}
 
-	if (!atomic_sub_and_test(skipped, &wait.count)) {
+	if (!atomic_sub_and_test(skipped + 1, &wait.count)) {
 		/* Wait until all IO for the context are done. */
 		wait_for_completion(&wait.comp);
 	}


