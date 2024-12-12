Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185712210E5;
	Thu, 12 Dec 2024 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020433; cv=none; b=QfIGpUp3+3fk5t6DhjH4TuDRTJsz9ZkwG0IVU5mtz8k2M5iAlzBYH4LQP8RWWJewXEYbjX9JqETw4U2rfTC/aJ7t/ZYcSXwjFvVjIHSsLd5PQb4NKZ8W42hQfCNObbayX1d4grE/ytC1ajOECzThZ/n2alZG8w8hUo509jr74W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020433; c=relaxed/simple;
	bh=yizy/JhUdBmArzSQOO2jRU1LdgDUshjRe4pg7zcpdG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JD68LwGukTc4gMkjJqyll+msg6IhXQDUoDIyM+g42I7ZbYeqs7zrTFJHZ7xYgBSfkWCiJut5lVIdR2GKlVS8w6iINLX/kv95A2cNqWT44rja0AfJ+IkiLcJGvh5fAyvYHdgQXGrsiJY4IVDHKjuH6ImiZ+fs3i8dLyBmP1KcOFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhZTIi1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhZTIi1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01943C4CED3;
	Thu, 12 Dec 2024 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020432;
	bh=yizy/JhUdBmArzSQOO2jRU1LdgDUshjRe4pg7zcpdG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhZTIi1i+q51569WtzKzfSQ1SkwDfpgwWGIo65w7KRS3Ik8Qsad4wy1ZR4DFeNM3S
	 qEGBeQZaMjanpErenSHd37bIm+YnMV7HJum3LW+ZrBVyKIR0Pes9073+XiFI2SH6yx
	 fXoJppvgMkwCh5522xIqQFcHWcM0G4TqDntGr+Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 467/772] media: gspca: ov534-ov772x: Fix off-by-one error in set_frame_rate()
Date: Thu, 12 Dec 2024 15:56:52 +0100
Message-ID: <20241212144409.229615379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit d2842dec577900031826dc44e9bf0c66416d7173 upstream.

In set_frame_rate(), select a rate in rate_0 or rate_1 by checking
sd->frame_rate >= r->fps in a loop, but the loop condition terminates when
the index reaches zero, which fails to check the last elememt in rate_0 or
rate_1.

Check for >= 0 so that the last one in rate_0 or rate_1 is also checked.

Fixes: 189d92af707e ("V4L/DVB (13422): gspca - ov534: ov772x changes from Richard Kaswy.")
Cc: stable@vger.kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/ov534.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -847,7 +847,7 @@ static void set_frame_rate(struct gspca_
 		r = rate_1;
 		i = ARRAY_SIZE(rate_1);
 	}
-	while (--i > 0) {
+	while (--i >= 0) {
 		if (sd->frame_rate >= r->fps)
 			break;
 		r++;


