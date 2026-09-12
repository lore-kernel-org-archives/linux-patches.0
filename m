Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E761369D61;
	Sat, 12 Sep 2026 19:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241053; cv=none; b=InkV4Hpu7C83u26qEoNS1AE8aU1SClmKl83g/02bREs9qQsES7p/GBZLvUomenYTYCr4CVn5QQxjBY3QebN0shxklQGU7KEaN1KVXJxqFGqW6uaa5ZopeHYZrxdTM+HqbdCXpveYOFppO+cr2i2acStk4XcxpCjVWwsK10PImgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241053; c=relaxed/simple;
	bh=K5nHwWxAm2vh3id/tVT/nH7UyXO7v+8xnmz1tazncHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHmdAbedAPHxlRNinHrIkDjuempjEkWtHMQPUjN6CjrMShT5lqjJt3kHxlyErxSGUJmNVYwooVyy/3C3SRNKod9otPBNZfkmj+rf56P5/aahJoJFJiG8aASdaZq1SHTeIaBwafqnYPXSwr0iefEZbZx8zbJ5e76tCddMa7zOcFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQfZ40TI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQfZ40TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B79B1F000FF;
	Sat, 12 Sep 2026 19:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241052;
	bh=L75loOtJ/r8f2u9xWBEqortxwlDxpzqgFJ6q78Ftsvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQfZ40TIYFJd01eOoRCLLqN82wi74DxHMEMcI6On31w4apzqboQ9WsfzaSO0i4XTm
	 Z7dU0T+9/i/zgxuxsI6isB3WqxJBWJ508trFfiR/pqalrJtoZuxEqyY71uQva4vb+w
	 +3bidXK6MYG+mhisg8IRJRL50+pKBgBTg/X926jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 5.10 014/798] staging: greybus: hid: fix SET_REPORT return value
Date: Sat, 12 Sep 2026 08:54:02 +0200
Message-ID: <20260912065517.287229715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 		ret++; /* add report_id to the number of transfered bytes */
 
-	return 0;
+	return ret;
 }
 
 static int gb_hid_raw_request(struct hid_device *hid, unsigned char reportnum,


