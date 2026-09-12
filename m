Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD0D3314B7;
	Sat, 12 Sep 2026 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226655; cv=none; b=kZUA+YtDz9tMWlJX9XJ53FTe3Qr/6+qf58n8++FuyzhvnzNAeB5iBgQb6mlj3g0eDA/krDF7C3bsFLDu0YBG1yOGCr0ztllfpY0ci0wBJidtFlxU2drbH31x4ysrD5wOS6ghvML8qhZzTqpSI4Tk4QTQQLTzIdj05xgyUO6zkFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226655; c=relaxed/simple;
	bh=6CcB2XtNEGVQWYezdHGEozPYEs+eUgcN9n4ucRUwGUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjbkvGbdTFye2voZ8cmPuEQvgPHydy3+dclKTRVDV6BvXNzmhju2p0XZU/I9dgGLS+73vsPZq8WDbmQl3ni5AC0encW7BrICoZTdNxp1ryEGW6Wjz7OG5p5trPN234VxgDE8NTBocUG77t57XGLAEjd14VEF+pWMYAI9z6o1+/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffTxWpUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffTxWpUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2781F000FF;
	Sat, 12 Sep 2026 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226654;
	bh=ExQGrKaLQ/AB5INHsmE9BdnyMX2A2NIbbKdEcLyA/OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffTxWpUb0nXhuqi8Ezs3hdv9uFTvNDEch37yNkTDRygW/sLJALIq9nNyCYDEGMo1k
	 Uprv2vjOVDx3F/yUdO1iaOw0WqXZGI+fEz6brXm5w2i1cczyHshUhMiwRWb31BkI6M
	 yRG9AfP79n6Bm4HzWGZ5mgEBjab1N9oM4huXS/NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 6.1 0022/1191] staging: greybus: hid: fix SET_REPORT return value
Date: Sat, 12 Sep 2026 08:45:50 +0200
Message-ID: <20260912065548.615510259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


