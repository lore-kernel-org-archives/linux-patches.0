Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622865;
	b=ZXkoM4AntPTz1R9Flu3yAsCD4XxKN5VaqzGJSORmTyyGo5NmA9f/j3sU5oEQQade09LX
	 WvopYhuIJVIpo1eBAOh//M73lscsQcYoCUyoZjCWqZ9j9OvFhj6MZIhHOdc+zd0wdGFTM
	 C/cO6rmC5oOR3goOkPUy0j1VBgLrAT3+y/Qre4lfw9HJ6E9qOoxKKfzvUGKVcUXUw8c1n
	 5SzAYhtGLrA3UTniQoY6RTn9fb5UV+w/TSxZhaB5cnUwWiSPVLRf1fglfViEteC0scb9b
	 EPJ0GmY9fKlz3/OaN5cTmN9hYTEzxGVX+VnDdEP8GeiUsfiPVEr8HbL/vU/MNcWJMgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dbX2mwNZ6Cg2vkMGPBdkhWu7kwmQOYItvPyg/+cS8lI=;
	b=n90Kz3spl5y2KXQm/k8xWKiWXR80HRPD8TWedM0KoJb+Qb/f6VtXoEwcvIbi5D/tPkgX
	 Scs5FJu7My3ngCTmd9KRHPdYLt2fpOr8kBYCXFa9c6Fp98qi4YjqTE9vvOgfoTzTyLibz
	 9xoomZ9gM2/WC/VhrCkgIyopglOfG6YxRmtw1OY2Mkb9h4PvmTUTXonFnU91ecKgHQPq+
	 FOiBazqOzuX3CgYsY+dQcFM3iEIV7GYj+FTSLeDVqi4Nim7ZtMDtcKQ7sA0Hx+qwc4B8D
	 21HhSW4tRMQiKkU3Hou0c8Wv5poGLr+66lCef07KdY+RGYilfh0MnVtAlcs/Bi/bDcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aU6E2p7T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2EC606A321;
	Wed, 25 Nov 2026 16:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aU6E2p7T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84561F000CA;
	Wed, 25 Nov 2026 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622865;
	bh=dbX2mwNZ6Cg2vkMGPBdkhWu7kwmQOYItvPyg/+cS8lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aU6E2p7T/iGwD3iSlKKxaM6BmGMyLXgXC/TvQbUbG6vz8p7WE1GIXhTwKZ0RJ/OCb
	 If0Be1Hck2jcwVIrmbU+VOd8MDWLSVF3m3qZNDB3Hi6N6Rndj/F6HAU2bPTxdjREAi
	 XeFu7jtjl4OOi44xfGE6WEDG2nvRNzOU4VRpusi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 673/990] aio: dont let exit_aio() return before complete() is done
Date: Wed, 25 Nov 2026 15:34:00 +0100
Message-ID: <20261125143837.851026866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -910,7 +910,7 @@ void exit_aio(struct mm_struct *mm)
 	if (!table)
 		return;
 
-	atomic_set(&wait.count, table->nr);
+	atomic_set(&wait.count, table->nr + 1);
 	init_completion(&wait.comp);
 
 	skipped = 0;
@@ -934,7 +934,7 @@ void exit_aio(struct mm_struct *mm)
 		kill_ioctx(mm, ctx, &wait);
 	}
 
-	if (!atomic_sub_and_test(skipped, &wait.count)) {
+	if (!atomic_sub_and_test(skipped + 1, &wait.count)) {
 		/* Wait until all IO for the context are done. */
 		wait_for_completion(&wait.comp);
 	}


