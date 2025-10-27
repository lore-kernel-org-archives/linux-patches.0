Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1191B202963;
	Mon, 27 Oct 2025 19:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593234; cv=none; b=XjzmalykfKiWld7Gl5EMwxmUhD7IQs3um+wqqKSmoaUoeT+zNK/Rbq79LjvWUoHFOfkmOH9+plHgo6kKlXlNjClfDjFDCB+wZiUQR/7lnYn0OUm+Xc7dT+pYp7qns5E5wBq/HxkeCNxpJP6xwM03nABJd79hg1wC7Exc2+l35+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593234; c=relaxed/simple;
	bh=934bB7yTD5RWvHouy1T4/k1lxTm5Sw9TFeBuvcpBjbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPEJ930Nb4I7oHooIxGudyrTzjH0khSbviLUIH8BsnHVFZ3FG9/M8Oi13d766jjpcKa6sLUIMt9qZBxGW3c2vrOmZnQR6hcxlTmUE+EAWAoHDB6sXe1VlQr9R9/0ot8e5wmYOS1lJMacPxFeCWeLuOL7pBENs544KgdNyBftTRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNTKSsmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNTKSsmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0ACC4CEF1;
	Mon, 27 Oct 2025 19:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593233;
	bh=934bB7yTD5RWvHouy1T4/k1lxTm5Sw9TFeBuvcpBjbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNTKSsmHOPs5z4T08bzZgpV9XtIiA+XfZT/iFwFT4AoDMyG0Tkdh3QE5IcDGTcaWA
	 06HGtiQSbFGiEP4qX73551R5Wst8oSWSplT2eJ6hIhqbMrTvzArkXO0gNR9LKTR9fk
	 WfhDIbUygckLyBEzls0cnZNChUeyUiqxXcBWK8UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Yang <lance.yang@linux.dev>,
	Eero Tamminen <oak@helsinkinet.fi>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Ingo Molnar <mingo@redhat.com>,
	Joel Granados <joel.granados@kernel.org>,
	John Stultz <jstultz@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Mingzhe Yang <mingzhe.yang@ly.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	Yongliang Gao <leonylgao@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 063/184] hung_task: fix warnings caused by unaligned lock pointers
Date: Mon, 27 Oct 2025 19:35:45 +0100
Message-ID: <20251027183516.586562060@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lance Yang <lance.yang@linux.dev>

commit c97513cddcfc235f2522617980838e500af21d01 upstream.

The blocker tracking mechanism assumes that lock pointers are at least
4-byte aligned to use their lower bits for type encoding.

However, as reported by Eero Tamminen, some architectures like m68k
only guarantee 2-byte alignment of 32-bit values. This breaks the
assumption and causes two related WARN_ON_ONCE checks to trigger.

To fix this, the runtime checks are adjusted to silently ignore any lock
that is not 4-byte aligned, effectively disabling the feature in such
cases and avoiding the related warnings.

Thanks to Geert Uytterhoeven for bisecting!

Link: https://lkml.kernel.org/r/20250909145243.17119-1-lance.yang@linux.dev
Fixes: e711faaafbe5 ("hung_task: replace blocker_mutex with encoded blocker")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: Eero Tamminen <oak@helsinkinet.fi>
Closes: https://lore.kernel.org/lkml/CAMuHMdW7Ab13DdGs2acMQcix5ObJK0O2dG_Fxzr8_g58Rc1_0g@mail.gmail.com
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Finn Thain <fthain@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yongliang Gao <leonylgao@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hung_task.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/hung_task.h b/include/linux/hung_task.h
index 34e615c76ca5..c4403eeb7144 100644
--- a/include/linux/hung_task.h
+++ b/include/linux/hung_task.h
@@ -20,6 +20,10 @@
  * always zero. So we can use these bits to encode the specific blocking
  * type.
  *
+ * Note that on architectures where this is not guaranteed, or for any
+ * unaligned lock, this tracking mechanism is silently skipped for that
+ * lock.
+ *
  * Type encoding:
  * 00 - Blocked on mutex			(BLOCKER_TYPE_MUTEX)
  * 01 - Blocked on semaphore			(BLOCKER_TYPE_SEM)
@@ -45,7 +49,7 @@ static inline void hung_task_set_blocker(void *lock, unsigned long type)
 	 * If the lock pointer matches the BLOCKER_TYPE_MASK, return
 	 * without writing anything.
 	 */
-	if (WARN_ON_ONCE(lock_ptr & BLOCKER_TYPE_MASK))
+	if (lock_ptr & BLOCKER_TYPE_MASK)
 		return;
 
 	WRITE_ONCE(current->blocker, lock_ptr | type);
@@ -53,8 +57,6 @@ static inline void hung_task_set_blocker(void *lock, unsigned long type)
 
 static inline void hung_task_clear_blocker(void)
 {
-	WARN_ON_ONCE(!READ_ONCE(current->blocker));
-
 	WRITE_ONCE(current->blocker, 0UL);
 }
 
-- 
2.51.1



