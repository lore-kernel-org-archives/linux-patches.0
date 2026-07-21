Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7876543D502;
	Tue, 21 Jul 2026 22:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672188; cv=none; b=GXHtY9WQKd+IxTgQnmYB8n5pZaWsyQ+mPh/vbCX5AS5zbveVz4OTBH6piSv1MORWrysReQmLqPUJD3dpIAnfLissaWvCGaI/bByWuZKblSmgxRMw//nJn1jHoBZNZXLA5v1Y8qTKNWg0WCjO7HmqOvnrFCFAOJyUE3y3Row+tTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672188; c=relaxed/simple;
	bh=VXt6mNxVuV2kqsstArwI/e70s1NER0Z8N4f+xrHqTtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRFqG/L8ea0vBUZlsJywfaTndcCGiuahxri8uRccxAEgcAFoP85aBMadkWCHuXcoJwbUmsT9bHyIwsncrxJoC2DBjPDpAbuv6qoOXM9EgnXFav/U8lMQdsLJsSqfSaTe4hxisJfe+mBc8tO60SJWafQKbPoMex+Ax1hZvG19Wlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuozYQbY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuozYQbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7051F000E9;
	Tue, 21 Jul 2026 22:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672187;
	bh=ON2+3kEa0QJedt57dErGpxVQf6ZaaGh+yOg1tonhnA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuozYQbYp96QvoRIQKvlYH/sr/BGdmRP/n/Hm59Tf7ptclcrO/hi4fvIL+KjPMMC9
	 xWquZ9jJj5Njh2bpm0iRmKRNp/EleX932YnckbM0Mr9FhtAO0p35AJbO6BW9WuAyWe
	 NFEUG00lc43hFj3LFK3O2vPgakbtv7xXv1/W9Mhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 529/843] ring-buffer: Fix event length with forced 8-byte alignment
Date: Tue, 21 Jul 2026 17:22:44 +0200
Message-ID: <20260721152417.930310509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e7c472729542d9..a1c30bca23ac07 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -247,7 +247,8 @@ unsigned ring_buffer_event_length(struct ring_buffer_event *event)
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



