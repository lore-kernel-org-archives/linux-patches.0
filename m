Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003B147986A;
	Sat, 12 Sep 2026 17:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232459; cv=none; b=TUOtvMVrsxTlKIkxcgWDXh6NDM+fjTxvu9tgwjFSQhCmj8zzPS+GdPlgZODtkrQ2IAjDaLALvyT2rWOuLF8qRDrZBYnCs90F/YqmAsd9/WI1v4+ax633kg+ioIkw6KfH93FQhh8q4VRh84D+CJuOXMUq1NUyRbVAapwUFoNLTt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232459; c=relaxed/simple;
	bh=wcCuu7M4RxNK45zqRCHJJNU6+llSVrqyNhX7j2EkY5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDRjWt5qtDOnGAdqTqGbzLgKXZVNvs8qMNx0GfZYJutGtHW0txv9QbyH/JGDzj/9eXOLuqt2HNGebOXReVg9dSOSMQQNQ3yXfHhlVBC3tw/i4DfsrMNrGvRDNlPKVMbqjXG0bVjqaWopp+Bj9Rw8o7HIc3pD4RjXjHSI55rbYIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTyDeO9e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTyDeO9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590FD1F000FF;
	Sat, 12 Sep 2026 17:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232457;
	bh=b04Q7WFxML2yg6414CMfZh8lENRdYrXZqa1AiwQ7EL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTyDeO9eHoS5P2LA9CGUn5ownwTUTYHp4c8Uu0mgwD4WWWdXwgcXgKYEWgu2sHe6F
	 ImFtTBEVUYVIrnkQKYutOvYCupmBNGy9tmDL13v1Xcph9LNnTorqNqw+fkiNcyKCQy
	 PX/FiJCi3LvF/F9wFFF3AJMulyNiKRpHCJ7bHkJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 5.15 015/935] staging: greybus: hid: fix SET_REPORT return value
Date: Sat, 12 Sep 2026 08:50:45 +0200
Message-ID: <20260912065527.188858715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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


