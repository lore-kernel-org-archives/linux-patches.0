Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C1C439336;
	Tue, 21 Jul 2026 21:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669821; cv=none; b=cOqYtXRLzH2ElIJxrJ+VEhO9Dls2RaHwOxIgQXye46TURoQl0KIQQ/fsN3ZSTQmhEtfBuF4i+jjsN6kYauTFKt1frh6SRrmZpgzIRbix6WakR2qRGMJhqPnX+XdUz+EoNCHFEl4MI3iII0LgXm0jk84XvCu/RTTFpxkoTudxZnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669821; c=relaxed/simple;
	bh=FTAtSvCkLBTZl7HZNyvI0z91o4FN38z5MzX95JgRBcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNTRSm+AZYEv1+2lmodrQlNUS9U9bRegyWvMn4+rZJh94dMRulJ31nQKZoCWRk33JOQsSdKE1nq6CCTvLDvHkxlQY8OdPTuTiRyF3OPb7SNJwjzJga57B2ictSvDWMBeErP0bfItj8kPxibNXl9w7gAjHAZUr1+X5JtZUtiTpT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaYy59wj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaYy59wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CCC1F000E9;
	Tue, 21 Jul 2026 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669820;
	bh=Tu9C1dbqMZjIGegbPNvkPdRcVxpGgT7ZFJTK6KBX12Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaYy59wjgAY1e1/k3j/yWTbPzwkIEFlsX4Ep5YguGVtGS4A/pM3I5++sdiDzvrhEc
	 3sYAvxEKdc8roLnnOJ9BQopq+b04H250AhgRoBxiCGhMAffKKzbU8tg7Pz9eGloPtE
	 Pj+i/AdEmSXfGwH5Uue3y4QzF8AeFX2t4MRYVsaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0697/1067] ring-buffer: Fix event length with forced 8-byte alignment
Date: Tue, 21 Jul 2026 17:21:38 +0200
Message-ID: <20260721152440.185522739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit c37e0a4b79a6bbb96ce5ffe279d7c001e20529e0 ]

When RB_FORCE_8BYTE_ALIGNMENT is true, rb_calculate_event_length()
reserves the space of event->array[0] for placing the data length and
rb_update_event() stores the data length in event->array[0]
accordingly. As a result the whole event length will add extra 4 bytes
for sizeof(event.array[0]) unconditionally.

But ring_buffer_event_length() only subtracts the
sizeof(event->array[0]) for events larger than RB_MAX_SMALL_DATA +
sizeof(event->array[0]). As a result, small events on architectures
with RB_FORCE_8BYTE_ALIGNMENT=true report a data length that is 4
bytes larger than expected.

To fix it, add the RB_FORCE_8BYTE_ALIGNMENT as a condition to subtract
the size of that length field whenever RB_FORCE_8BYTE_ALIGNMENT is
true.

This issue is observed in a riscv64 kernel with
CONFIG_HAVE_64BIT_ALIGNED_ACCESS set to y, when we run ftrace selftest
trace_marker_raw.tc, we get the weird log: for cases where the id is
1..100, the number of data field is 8*N, but once id exceeds 100, the
number of data field becomes 8*N+4:
 # 1 buf: 58 00 00 00 80 5e d1 63 (number of data field is 8*1)
 ...
 # a buf: 58 ...                  (number of data field is 8*2)
 ...
 # 64 buf: 58 ...                 (number of data field is 8*13)
 # 65 buf: 58 ...                 (number of data field is 8*13+4)

After applying this change, the number of data field keeps being 8*N+4
consistently.

Link: https://patch.msgid.link/20260607072431.125633-2-hui.wang@canonical.com
Fixes: 2271048d1b3b ("ring-buffer: Do 8 byte alignment for 64 bit that can not handle 4 byte align")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 5edc4126d0c6ba..089c49f17398e5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -255,7 +255,8 @@ unsigned ring_buffer_event_length(struct ring_buffer_event *event)
 	if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 		return length;
 	length -= RB_EVNT_HDR_SIZE;
-	if (length > RB_MAX_SMALL_DATA + sizeof(event->array[0]))
+	if (length > RB_MAX_SMALL_DATA + sizeof(event->array[0]) ||
+	    RB_FORCE_8BYTE_ALIGNMENT)
                 length -= sizeof(event->array[0]);
 	return length;
 }
-- 
2.53.0



