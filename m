Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E4715B10D;
	Mon, 28 Oct 2024 06:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097772; cv=none; b=dVQlwV8KxMJ6JHSLpYUrWRmhbtbAbr7rzl/P+XzPYCdJvnQhuAcfczH8ERFtFYHRPWJj0AJRsr6vgNf50x+ASuqS+In4F1zmNnpFacJB6bUSYSai006H9YA7qkzVoCM1PEQj7Zfal6I5xLj8hYd1fOAF+1OoW4bzg2jFEBBu79M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097772; c=relaxed/simple;
	bh=WYkxWD+TqtTfkP75AcrjM6G9eJieZecFohxIrp0OJGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AU9T9aKpTUSHgMpnv2jgGSW+xIYJN6sqIXCGCF+3C4VIilPjI8U/21miJO+M1ys1x62xmkIvSPHFYBUrbeNHQ0+jstxyr4IZD27mxdHMnYxA9e2W5MQeZpHgDzWTNJyxTUx32aT80+z2HmPze98HdK6vAA5/9G27vDEOfzyNvnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6c/5Dqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6c/5Dqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3662DC4CEC3;
	Mon, 28 Oct 2024 06:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097772;
	bh=WYkxWD+TqtTfkP75AcrjM6G9eJieZecFohxIrp0OJGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6c/5Dqz3WxnS6Y2l1BhG9HxK16RmtGYtZMUnAIWG0k+vIOVpxzAdkU75lzOB97LX
	 T9qS9UOF8zexl0EBlI/TpMq9VX9Pc8LlPqer4RA2j1kvQO5xw8+ZEAgAiAJ2raz8lY
	 F8O1qXnG5laDovH5grIu1ji3sYmW199FNuvQJaPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/208] usb: gadget: f_uac2: fix non-newline-terminated function name
Date: Mon, 28 Oct 2024 07:24:43 +0100
Message-ID: <20241028062309.196053173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit e60284b63245b84c3ae352427ed5ff8b79266b91 ]

Most writes to configfs handle an optional newline, but do not require
it.  By using the number of bytes written as the limit for scnprintf()
it is guaranteed that the final character in the buffer will be
overwritten.

This is expected if it is a newline but is undesirable when a string is
written "as-is" (as libusbgx does, for example).

Update the store function to strip an optional newline, matching the
behaviour of usb_string_copy().

Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://lore.kernel.org/r/20240708142553.3995022-1-jkeeping@inmusicbrands.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9499327714de ("usb: gadget: f_uac2: fix return value for UAC2_ATTRIBUTE_STRING store")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 55a4f07bc9cc1..79d1f87c6cc59 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -2060,7 +2060,10 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 		goto end;						\
 	}								\
 									\
-	ret = scnprintf(opts->name, min(sizeof(opts->name), len),	\
+	if (len && page[len - 1] == '\n')				\
+		len--;							\
+									\
+	ret = scnprintf(opts->name, min(sizeof(opts->name), len + 1),	\
 			"%s", page);					\
 									\
 end:									\
-- 
2.43.0



