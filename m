Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30902380FCA;
	Fri,  7 Aug 2026 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114296; cv=none; b=JuR48wHh2E9YvglKZsBkZj88c3inCdR1xRywDjYFYzG7MSbGe5tF47aKDnuyndx3Q9WPhG5tRwHNhoilhJgpz+E3U8MPPtPhABGcvCzzaCLShZgXpw+vCsw7Xoh8opFeLpgZDGoAl6LGbqUx0cQCe2EWkvMt3WPyQ98CO6IYusM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114296; c=relaxed/simple;
	bh=z1CVpvM1r++XnDpOlQjCFVWtv0qrJDL9MYhkN6RRN6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j2e0YCOmfXmFJomrdjOXpc9RSciUZBjctWD2zzR+rd1sefeFZmm6EdTyonUUWuOCqqN2xm8LcGNTZOHPxeU1BMWwIaHkclQr1oXlawQNmwxUi2BugR1oqO2G3VGRzY1113WHzn5yXz/YnWjEuTKNZrl5DvY1pOtw+Aez9wXuue0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkSYhFG/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkSYhFG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6BA1F000E9;
	Fri,  7 Aug 2026 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114294;
	bh=D+aUfEklQrme5DjwdYfXi4S5VKFoJaYA+c41wdgzwpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkSYhFG/4KYuxl46Gsh/Fiu0o939IkQAksSurs7NAJumWHi8qeMKFRqMKMgpXJdMP
	 ZjPrWDuQaCzXyhSjMf1/mZPy1+PCptKhjmKZY+h/QwddfOjBUfVfe7uEbPuz5+Gb3A
	 OcgOwr2qHQiS7zg7Y2Rvph0Rm0KMgZQNv4ia3h/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 211/337] s390/dasd: Fix undersized format-check buffer
Date: Fri,  7 Aug 2026 16:36:54 +0200
Message-ID: <20260807143423.129513107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 #include <asm/debug.h>
@@ -3475,11 +3476,11 @@ static int dasd_eckd_check_device_format
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
 
@@ -3490,7 +3491,9 @@ static int dasd_eckd_check_device_format
 	rpt_exp = recs_per_track(&private->rdc_data, 0, cdata->expect.blksize);
 
 	trkcount = cdata->expect.stop_unit - cdata->expect.start_unit + 1;
-	fmt_buffer_size = trkcount * rpt_max * sizeof(struct eckd_count);
+	if (check_mul_overflow(trkcount, rpt_max, &fmt_buffer_size) ||
+	    check_mul_overflow(fmt_buffer_size, sizeof(struct eckd_count), &fmt_buffer_size))
+		return -EINVAL;
 
 	fmt_buffer = kzalloc(fmt_buffer_size, GFP_KERNEL | GFP_DMA);
 	if (!fmt_buffer)


