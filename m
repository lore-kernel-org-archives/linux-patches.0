Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF387BAF3;
	Mon,  8 Apr 2024 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583931; cv=none; b=jDqFuXmWjDhyDZH5fg76mFXujVwlQwcUY+IC4SZMeUCTro/aiJmEuyccysIwCtGEu2KVvyliCkF8CDb/xkTRdOJPEv4XZP6fgYW+6d6DRgTy6mw8GlkSgtvFhA1cETFRF1k9SElWc8dFuufz+YcZmRTRRzOfr5L9Bfn2C8pNHOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583931; c=relaxed/simple;
	bh=2VY5pJhvHxFwya9twm7yA13ytmfyMV6llqQi2vuynfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UU/yct/jGiXO0kIl3OPUZz8PzG8eYnRqCWIuv09qwbs5XycYBdJdjLLdwk9d4QiQ/N4Dac0A2L+gc13Tgo/8VafI+aYzDPF4hypNCCdTeJay820es1X1G7ieBJ8EmvasqECtyIUCOE6OhN4VVQGbCL4pIfgnNKzNmjRfZ6mZHE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAc0lJhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAc0lJhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389EEC433F1;
	Mon,  8 Apr 2024 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583931;
	bh=2VY5pJhvHxFwya9twm7yA13ytmfyMV6llqQi2vuynfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAc0lJhzhVImxGMg7gZSepK4oFgB+6nRPzmIyLEdh1ConVn3Op8L29hPmlnZ62Wuu
	 UPRpe+hC4y0OQ1MuUREf25CDz9X8Mf8Yoo8CxWivQPnB1TKdvT2Wc6CEi8ubCe8cX6
	 77wSqhvKElhl444lWkkYeyJBueHGwKQWNn614Ngk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.8 235/273] aio: Fix null ptr deref in aio_complete() wakeup
Date: Mon,  8 Apr 2024 14:58:30 +0200
Message-ID: <20240408125316.728929030@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit caeb4b0a11b3393e43f7fa8e0a5a18462acc66bd upstream.

list_del_init_careful() needs to be the last access to the wait queue
entry - it effectively unlocks access.

Previously, finish_wait() would see the empty list head and skip taking
the lock, and then we'd return - but the completion path would still
attempt to do the wakeup after the task_struct pointer had been
overwritten.

Fixes: 71eb6b6b0ba9 ("fs/aio: obey min_nr when doing wakeups")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-fsdevel/CAHTA-ubfwwB51A5Wg5M6H_rPEQK9pNf8FkAGH=vr=FEkyRrtqw@mail.gmail.com/
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Link: https://lore.kernel.org/stable/20240331215212.522544-1-kent.overstreet%40linux.dev
Link: https://lore.kernel.org/r/20240331215212.522544-1-kent.overstreet@linux.dev
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1202,8 +1202,8 @@ static void aio_complete(struct aio_kioc
 		spin_lock_irqsave(&ctx->wait.lock, flags);
 		list_for_each_entry_safe(curr, next, &ctx->wait.head, w.entry)
 			if (avail >= curr->min_nr) {
-				list_del_init_careful(&curr->w.entry);
 				wake_up_process(curr->w.private);
+				list_del_init_careful(&curr->w.entry);
 			}
 		spin_unlock_irqrestore(&ctx->wait.lock, flags);
 	}


