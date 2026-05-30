Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BA11DE4EF;
	Sat, 30 May 2026 16:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159177; cv=none; b=QUcD7hqv82nBmyLHIDoeNYula68RrIBDEi9KovvRk3BBwWYgW8KLQqzCAgQ2H/OxBabDRDBpMV+NiqBPyyA/WtTrn54Eev/EXcGlT/H0uUYrrhSvQM1ejG0FY01hQYCbXCgm49f7QXkb+nwgFdiFNwa0ERM466UrpRWslpsdJO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159177; c=relaxed/simple;
	bh=nKWY2FCR2jqDvUH3bvtbRqlwJY3+56y4dpVyqciXAjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYC5+AfrPjXccmW4g9uN/Rjl0bbYbiAm3eJmlZg6tXuNx9aBh2Zj8oa8va3u5EzTBrWrwziQ8XpglIUlle0h2z4qc2KxQPnwHUu3hiMR5umRCu46trWZINtULqkGxhGYGoKu/VKkq0ZMQeB10KnZB1qzZnmF01UcDIctNbN5Tkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHEAyndg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHEAyndg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85071F00893;
	Sat, 30 May 2026 16:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159175;
	bh=6SdnIXSHfE5HOVtqy2fHeP56Xo//yKWultCd1s3pqLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHEAyndgJrwLe3owEHSVo9b8YbmGpXoh9k8tEeBpGSVXSVJPqP39L2g89bbhCQCML
	 B9o/6GRWZU5x0yWanVwMtQdjG2SAcMPiGsl4RWzQY1PVh2/bYvJhaLsl4BprUbjbe1
	 EkKr9Q8/s2ffmbDSDGiGL//ddNfJZ4s5hub+53pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+96f901260a0b2d29cd1a@syzkaller.appspotmail.com,
	Yihan Ding <dingyihan@uniontech.com>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 107/969] media: vidtv: fix pass-by-value structs causing MSAN warnings
Date: Sat, 30 May 2026 17:53:51 +0200
Message-ID: <20260530160303.273744887@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

commit 5f8e73bde67e931468bc2a1860d78d72f0c6ba41 upstream.

vidtv_ts_null_write_into() and vidtv_ts_pcr_write_into() take their
argument structs by value, causing MSAN to report uninit-value warnings.
While only vidtv_ts_null_write_into() has triggered a report so far,
both functions share the same issue.

Fix by passing both structs by const pointer instead, avoiding the
stack copy of the struct along with its MSAN shadow and origin metadata.
The functions do not modify the structs, which is enforced by the const
qualifier.

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+96f901260a0b2d29cd1a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96f901260a0b2d29cd1a
Tested-by: syzbot+96f901260a0b2d29cd1a@syzkaller.appspotmail.com
Suggested-by: Yihan Ding <dingyihan@uniontech.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_mux.c |    4 +-
 drivers/media/test-drivers/vidtv/vidtv_ts.c  |   50 +++++++++++++--------------
 drivers/media/test-drivers/vidtv/vidtv_ts.h  |    4 +-
 3 files changed, 29 insertions(+), 29 deletions(-)

--- a/drivers/media/test-drivers/vidtv/vidtv_mux.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_mux.c
@@ -233,7 +233,7 @@ static u32 vidtv_mux_push_pcr(struct vid
 	/* the 27Mhz clock will feed both parts of the PCR bitfield */
 	args.pcr = m->timing.clk;
 
-	nbytes += vidtv_ts_pcr_write_into(args);
+	nbytes += vidtv_ts_pcr_write_into(&args);
 	m->mux_buf_offset += nbytes;
 
 	m->num_streamed_pcr++;
@@ -363,7 +363,7 @@ static u32 vidtv_mux_pad_with_nulls(stru
 	args.continuity_counter = &ctx->cc;
 
 	for (i = 0; i < npkts; ++i) {
-		m->mux_buf_offset += vidtv_ts_null_write_into(args);
+		m->mux_buf_offset += vidtv_ts_null_write_into(&args);
 		args.dest_offset  = m->mux_buf_offset;
 	}
 
--- a/drivers/media/test-drivers/vidtv/vidtv_ts.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_ts.c
@@ -48,7 +48,7 @@ void vidtv_ts_inc_cc(u8 *continuity_coun
 		*continuity_counter = 0;
 }
 
-u32 vidtv_ts_null_write_into(struct null_packet_write_args args)
+u32 vidtv_ts_null_write_into(const struct null_packet_write_args *args)
 {
 	u32 nbytes = 0;
 	struct vidtv_mpeg_ts ts_header = {};
@@ -56,21 +56,21 @@ u32 vidtv_ts_null_write_into(struct null
 	ts_header.sync_byte          = TS_SYNC_BYTE;
 	ts_header.bitfield           = cpu_to_be16(TS_NULL_PACKET_PID);
 	ts_header.payload            = 1;
-	ts_header.continuity_counter = *args.continuity_counter;
+	ts_header.continuity_counter = *args->continuity_counter;
 
 	/* copy TS header */
-	nbytes += vidtv_memcpy(args.dest_buf,
-			       args.dest_offset + nbytes,
-			       args.buf_sz,
+	nbytes += vidtv_memcpy(args->dest_buf,
+			       args->dest_offset + nbytes,
+			       args->buf_sz,
 			       &ts_header,
 			       sizeof(ts_header));
 
-	vidtv_ts_inc_cc(args.continuity_counter);
+	vidtv_ts_inc_cc(args->continuity_counter);
 
 	/* fill the rest with empty data */
-	nbytes += vidtv_memset(args.dest_buf,
-			       args.dest_offset + nbytes,
-			       args.buf_sz,
+	nbytes += vidtv_memset(args->dest_buf,
+			       args->dest_offset + nbytes,
+			       args->buf_sz,
 			       TS_FILL_BYTE,
 			       TS_PACKET_LEN - nbytes);
 
@@ -83,17 +83,17 @@ u32 vidtv_ts_null_write_into(struct null
 	return nbytes;
 }
 
-u32 vidtv_ts_pcr_write_into(struct pcr_write_args args)
+u32 vidtv_ts_pcr_write_into(const struct pcr_write_args *args)
 {
 	u32 nbytes = 0;
 	struct vidtv_mpeg_ts ts_header = {};
 	struct vidtv_mpeg_ts_adaption ts_adap = {};
 
 	ts_header.sync_byte     = TS_SYNC_BYTE;
-	ts_header.bitfield      = cpu_to_be16(args.pid);
+	ts_header.bitfield      = cpu_to_be16(args->pid);
 	ts_header.scrambling    = 0;
 	/* cc is not incremented, but it is needed. see 13818-1 clause 2.4.3.3 */
-	ts_header.continuity_counter = *args.continuity_counter;
+	ts_header.continuity_counter = *args->continuity_counter;
 	ts_header.payload            = 0;
 	ts_header.adaptation_field   = 1;
 
@@ -102,27 +102,27 @@ u32 vidtv_ts_pcr_write_into(struct pcr_w
 	ts_adap.PCR    = 1;
 
 	/* copy TS header */
-	nbytes += vidtv_memcpy(args.dest_buf,
-			       args.dest_offset + nbytes,
-			       args.buf_sz,
+	nbytes += vidtv_memcpy(args->dest_buf,
+			       args->dest_offset + nbytes,
+			       args->buf_sz,
 			       &ts_header,
 			       sizeof(ts_header));
 
 	/* write the adap after the TS header */
-	nbytes += vidtv_memcpy(args.dest_buf,
-			       args.dest_offset + nbytes,
-			       args.buf_sz,
+	nbytes += vidtv_memcpy(args->dest_buf,
+			       args->dest_offset + nbytes,
+			       args->buf_sz,
 			       &ts_adap,
 			       sizeof(ts_adap));
 
 	/* write the PCR optional */
-	nbytes += vidtv_ts_write_pcr_bits(args.dest_buf,
-					  args.dest_offset + nbytes,
-					  args.pcr);
-
-	nbytes += vidtv_memset(args.dest_buf,
-			       args.dest_offset + nbytes,
-			       args.buf_sz,
+	nbytes += vidtv_ts_write_pcr_bits(args->dest_buf,
+					  args->dest_offset + nbytes,
+					  args->pcr);
+
+	nbytes += vidtv_memset(args->dest_buf,
+			       args->dest_offset + nbytes,
+			       args->buf_sz,
 			       TS_FILL_BYTE,
 			       TS_PACKET_LEN - nbytes);
 
--- a/drivers/media/test-drivers/vidtv/vidtv_ts.h
+++ b/drivers/media/test-drivers/vidtv/vidtv_ts.h
@@ -90,7 +90,7 @@ void vidtv_ts_inc_cc(u8 *continuity_coun
  *
  * Return: The number of bytes written into the buffer.
  */
-u32 vidtv_ts_null_write_into(struct null_packet_write_args args);
+u32 vidtv_ts_null_write_into(const struct null_packet_write_args *args);
 
 /**
  * vidtv_ts_pcr_write_into - Write a PCR  packet into a buffer.
@@ -101,6 +101,6 @@ u32 vidtv_ts_null_write_into(struct null
  *
  * Return: The number of bytes written into the buffer.
  */
-u32 vidtv_ts_pcr_write_into(struct pcr_write_args args);
+u32 vidtv_ts_pcr_write_into(const struct pcr_write_args *args);
 
 #endif //VIDTV_TS_H


