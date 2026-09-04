Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9EF41A54B;
	Fri,  4 Sep 2026 05:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500627; cv=none; b=r06IeoLUxTtX+IzVM+NALhOszWlblimx4q8BNvFmR+qSlkeHdKlirM6HOlM+AvEHjZ9TKX4F56tg291+Vt8/P87Msy6sqZaVmluJaeIAUV94ZE5eaHrNhaiOjPZjKrtJnItvIX/YkWS3Eo7hPr1oNQqoc9ctwA4oNxyFc6j/0WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500627; c=relaxed/simple;
	bh=AysQHSIA4Eq0EvRE1tY1uSiwhP8eobR1CCj/JAGJ1ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HA1lhdSd9CHg/e+2CLv3WjNqCFDSwTdArcUAy3c30CMqDr1DPOpIZZbfJo5sGE/jajDjKyb9fOkQRNen2RlxYwmepys0GPS9vWQacylwyLCI2Uk1nQc4JNjrJxshmrQYvxq17piaoLZ0ig49Lh6NdRUHoAUtwvTjGetVQilaBSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qq1Tx7gF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qq1Tx7gF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904CB1F00A3D;
	Fri,  4 Sep 2026 05:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500626;
	bh=LqFZ0ah7D1yWAydRXH2tM4F/6tfyHju6KNaXwqwSLno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qq1Tx7gFm7LiGCnQRkZg3DPJGWxmcZSlPZkTESr4w0sU3sZTv2IsMe11ku1jsuJ0I
	 Z0Y3boql33s/JFcsv4Z+cslHGyUMpWvgf+3hgPp59mBvQml0NzAhBnFIafGjH9al8g
	 ESi1R7uheicDe57KoI0M9IYe5tl0As+ki2qK8qB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 6.18 070/552] staging: greybus: hid: fix SET_REPORT return value
Date: Fri,  4 Sep 2026 06:53:47 +0200
Message-ID: <20260904045749.435637030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit 6d45195a9626d8aaaaed212c55638829a9c624a3 upstream.

__gb_hid_output_raw_report() stores the result of gb_hid_set_report()
in ret and even adjusts it to account for the report ID byte, but then
always returns 0.

This hides Greybus transport errors from HID_REQ_SET_REPORT callers,
and makes hidraw report zero bytes written to user space on success,
although hid_hw_raw_request() is expected to return the number of
bytes transferred or a negative errno. The sibling GET_REPORT path,
__gb_hid_get_raw_report(), already follows this convention.

Return ret like the other HID transport drivers do.

Fixes: 96eab779e198 ("greybus: hid: add HID class driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Link: https://patch.msgid.link/20260704081613.434445-1-alvinhuang0603@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/hid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/greybus/hid.c
+++ b/drivers/staging/greybus/hid.c
@@ -256,7 +256,7 @@ static int __gb_hid_output_raw_report(st
 	if (report_id && ret >= 0)
 		ret++; /* add report_id to the number of transferred bytes */
 
-	return 0;
+	return ret;
 }
 
 static int gb_hid_raw_request(struct hid_device *hid, unsigned char reportnum,


