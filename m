Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8872F0C74;
	Fri,  7 Aug 2026 15:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115432; cv=none; b=ii74jLeAm/gU5H4IIWJWsMxcrC46W3EmB31CBuiZw0bkvle+PDSxCC4/hX2fcLf94RiBNPB+bSvoyfG+9DNxI6uY+rBXkDIkGtj0dd2IkIVqdFU278lP34YWbaPMo8puLfRMFVfJ/96GmXMZz86pVSZs78NRn6D9N3394plz4d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115432; c=relaxed/simple;
	bh=kmIFmpqEU9uuZhPCjiEoDk+J8Eh0eS2WJVDP+zbjP8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MhPibwwMUHofPSvnM3zvuvF3nvMTfVD1jvqMddo9DyXxFiZJoTJZXie5cvS6ISwhE2eVjBP54dIeB3P2v2VqSNlbyFYTlECbB0VDo30EXq6+UuH5emlO9pzuL8ybbZvWIHjhGRifAHz4yO5pnpGC+XVg7zkfLmN6FlnjVO/SK8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urdB7AKp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urdB7AKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469A31F000E9;
	Fri,  7 Aug 2026 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115430;
	bh=/S1sW07V8phs32/b5/IxID9XFe1NeOOyX/UgTYmtr+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urdB7AKpuN7/71T7YZ5VMvHO4JmseZTehNKYbd2sx4YkHTTEGrAquejdW+aXkMk/N
	 byUahChWzzqOvflOdusVlup8K7FVzbUq2FLkqnwnT9RVFgLmB9BHTwSsfY7hh4cfHm
	 nDv4z6NQakQ7XHH3TOEHt9qWjw+58mLUQum8jI3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 273/396] s390/dasd: Fix undersized format-check buffer
Date: Fri,  7 Aug 2026 16:37:13 +0200
Message-ID: <20260807143430.143908681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit 7f40b346462f563a0d6e841a77b5163d2a882a04 upstream.

fmt_buffer_size in dasd_eckd_check_device_format() is declared as
int, even though one of the multiplicands, sizeof(struct eckd_count),
is a size_t. The expression

    trkcount * rpt_max * sizeof(struct eckd_count)

is therefore correctly evaluated at 64-bit width, but the result is
silently truncated when it is stored back into the 32-bit
fmt_buffer_size variable. For a sufficiently large track range
(start_unit/stop_unit are caller-controlled) this truncation
yields a buffer size far smaller than the number of tracks actually
requested. kzalloc() then succeeds with an undersized allocation,
while the subsequent channel program build still operates on the
untruncated track count and writes past the end of that buffer.

Compute the buffer size with check_mul_overflow() and keep it in a
size_t, so that a value that no longer fits results in -EINVAL
instead of a silently truncated allocation size.

Fixes: 8fd575200db5 ("s390/dasd: Add new ioctl BIODASDCHECKFMT")
Cc: stable@vger.kernel.org #4.7
Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260727142840.567286-4-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/overflow.h>
 
 #include <asm/css_chars.h>
 #include <asm/machine.h>
@@ -3476,11 +3477,11 @@ static int dasd_eckd_check_device_format
 {
 	struct dasd_eckd_private *private = base->private;
 	struct eckd_count *fmt_buffer;
-	struct irb irb;
+	size_t fmt_buffer_size;
+	unsigned int trkcount;
 	int rpt_max, rpt_exp;
-	int fmt_buffer_size;
+	struct irb irb;
 	int trk_per_cyl;
-	int trkcount;
 	int tpm = 0;
 	int rc;
 
@@ -3491,7 +3492,9 @@ static int dasd_eckd_check_device_format
 	rpt_exp = recs_per_track(&private->rdc_data, 0, cdata->expect.blksize);
 
 	trkcount = cdata->expect.stop_unit - cdata->expect.start_unit + 1;
-	fmt_buffer_size = trkcount * rpt_max * sizeof(struct eckd_count);
+	if (check_mul_overflow(trkcount, rpt_max, &fmt_buffer_size) ||
+	    check_mul_overflow(fmt_buffer_size, sizeof(struct eckd_count), &fmt_buffer_size))
+		return -EINVAL;
 
 	fmt_buffer = kzalloc(fmt_buffer_size, GFP_KERNEL | GFP_DMA);
 	if (!fmt_buffer)


