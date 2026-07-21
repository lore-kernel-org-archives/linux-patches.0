Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED9544607D;
	Tue, 21 Jul 2026 19:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663325; cv=none; b=To7AUoXepHlKkGVYIrEKtQSznyWKUbE/v7K+tqhYMJ0Ksgpb6KvUOGEoBHx1KxvYHjGiQP/1xbGiPHTqHMHJgHRkSIYXgmgFI+ZyRobkgWB4D393C2PqUOTuwjmYrW/zcJ6hEvg/Q4kwYi2KUcJOlP9S/JKm4YQolfE4xARPIS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663325; c=relaxed/simple;
	bh=ITpI1PuoCymTgn4uR/nLoP+AjPDkv5rcw0Ca/gRnHSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqPwh4c/1zfl2ydN8UsdvmpqxXAfUCX1r35omGhDSE4LncTxLPyLUA7Ego2W2Gs/+bKDJ4RJ9Vin9A37IoAFc5CjxVbFhc9SzmWbLJI0Tru4Rim8ND7BKvYqFpv2lnQVnHzAj1fJ9atGng6oZDRBQb0ngE0l5ATISdZJp3+qTZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJU9iZfl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJU9iZfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F21B1F000E9;
	Tue, 21 Jul 2026 19:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663324;
	bh=0+ZuaBb1vS46rfKHs7JGtIrrm/0TemxhtSCZ6vMgqBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJU9iZfljJNE7M8v32EAEQF8X/bXmZMkGuBeIoslcm+zzgGzCmLFa6x7bGYEGP8bW
	 ZXL0CqQIrHSS28x5939DntRKwxQvJERI+WX44kPEmqQUA99Ce4QhjmUgGcft31EK+I
	 MhT8w8PbqLfg7SMzauvnEh0Xtg5ObLkwNTNoTwQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0778/1276] ring-buffer: Fix event length with forced 8-byte alignment
Date: Tue, 21 Jul 2026 17:20:21 +0200
Message-ID: <20260721152503.487754422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4deeb613c556a7..fcd2363d1296b6 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -277,7 +277,8 @@ unsigned ring_buffer_event_length(struct ring_buffer_event *event)
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



