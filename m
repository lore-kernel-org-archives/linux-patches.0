Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079FE54BCE;
	Mon,  8 Jan 2024 15:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b68x90C8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCC4C433CC;
	Mon,  8 Jan 2024 15:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728606;
	bh=XLHFUnM7XRwDHfWg0WG3vvRNlkS6fzSqYjM6dl4GLZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b68x90C8W8lrc1itWPD4td9JbjnOtCrnxKTHNbdBE7LZnIMsUIv+aV+x9CiQy8uL1
	 IXWFgyyrhAkEE3mgMVAP0lgx32JX0yHb+Vo+6jM27av9WU/68QkQjNFzGWskvFn5CC
	 hhTfi0pSFcniPDqQerbhlH9hVU13Ajg4fwnCL4WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/150] ring-buffer: Fix 32-bit rb_time_read() race with rb_time_cmpxchg()
Date: Mon,  8 Jan 2024 16:36:22 +0100
Message-ID: <20240108153517.222777699@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit dec890089bf79a4954b61482715ee2d084364856 ]

The following race can cause rb_time_read() to observe a corrupted time
stamp:

rb_time_cmpxchg()
[...]
        if (!rb_time_read_cmpxchg(&t->msb, msb, msb2))
                return false;
        if (!rb_time_read_cmpxchg(&t->top, top, top2))
                return false;
<interrupted before updating bottom>
__rb_time_read()
[...]
        do {
                c = local_read(&t->cnt);
                top = local_read(&t->top);
                bottom = local_read(&t->bottom);
                msb = local_read(&t->msb);
        } while (c != local_read(&t->cnt));

        *cnt = rb_time_cnt(top);

        /* If top and msb counts don't match, this interrupted a write */
        if (*cnt != rb_time_cnt(msb))
                return false;
          ^ this check fails to catch that "bottom" is still not updated.

So the old "bottom" value is returned, which is wrong.

Fix this by checking that all three of msb, top, and bottom 2-bit cnt
values match.

The reason to favor checking all three fields over requiring a specific
update order for both rb_time_set() and rb_time_cmpxchg() is because
checking all three fields is more robust to handle partial failures of
rb_time_cmpxchg() when interrupted by nested rb_time_set().

Link: https://lore.kernel.org/lkml/20231211201324.652870-1-mathieu.desnoyers@efficios.com/
Link: https://lore.kernel.org/linux-trace-kernel/20231212193049.680122-1-mathieu.desnoyers@efficios.com

Fixes: f458a1453424e ("ring-buffer: Test last update in 32bit version of __rb_time_read()")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 06d52525407b8..71cad4f1323c6 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -646,8 +646,8 @@ static inline bool __rb_time_read(rb_time_t *t, u64 *ret, unsigned long *cnt)
 
 	*cnt = rb_time_cnt(top);
 
-	/* If top and msb counts don't match, this interrupted a write */
-	if (*cnt != rb_time_cnt(msb))
+	/* If top, msb or bottom counts don't match, this interrupted a write */
+	if (*cnt != rb_time_cnt(msb) || *cnt != rb_time_cnt(bottom))
 		return false;
 
 	/* The shift to msb will lose its cnt bits */
-- 
2.43.0



