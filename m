Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F94F5DF7;
	Thu, 17 Sep 2026 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664134; cv=none; b=VN9JfgOK4tjWCM6IkaKxb5aF9/XtRbF06oc5FCgv3KymGchOH8USJDCGsuCpfwg3MY+AjxmOery0O7OrNeZO7hhCcvON/NDrD+xXMxhyTWwGrBBIxxiZILbS6KzXapoykOJpVbLLoxL5d8vnf85C1vIgL76zqFVrcJAXk0rA77o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664134; c=relaxed/simple;
	bh=3zYM3gcQ0ymZR0rZ9haDDvAhoqa1HEk5AhfmJEpFps8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7x335eBEYtdshEBME6xrX+wArlLKhQjDL70MGv/mbHlExARjTwzms2AnwaBcZPiez8yS5DvZ+XfLnI1gBIwbfY1OUZMa9XfqN0ZTYPdoPolINafjYuQWC8vuyMMZBSNU6MQ5mwBTmKknRgq0zSmI85za1gO/abT1sqOi2tddK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdlY0pD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdlY0pD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED041F00893;
	Thu, 17 Sep 2026 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664132;
	bh=5HLf5yi38AGoQvWUNLkXtcQjv56b2fIIhQ+HoGAK9FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdlY0pD/us6OHjCPW596TEIQprbJlOEwf1c3hZqBcpmqyEmoGKECiGQyYaLwWcagl
	 SX4md3GcGdzkhx+TCxOJbVyDV7daCAffgpZCpPCzcaHEh8a37hO4qLGbUrDF/47DBW
	 EHgs9KShsORghowOlXEq1KOW+Y9gEWDzVPQWwJyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0253/1250] scripts: modpost: detect and report truncated buf_printf() output
Date: Thu, 17 Sep 2026 16:00:48 +0100
Message-ID: <20260917151559.011978858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit d7231d8cb262b1e350c00271bf53d54414b4f3b1 ]

buf_printf() uses a fixed-size stack buffer. vsnprintf() returns the
number of bytes that *would* have been written to that buffer, which can
be larger than the size of said buffer if the formatted string is too
long.

The problem is that whenever this happens buf_printf() currently passes
this length, unchecked, to buf_write(), which silently reads past the
stack buffer and copies invalid data into the output buffer.

Fix this by detecting vsnprintf() failures and truncations before
appending to the output buffer, and report a fatal error instead of
producing corrupt symbol names.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260527-nova-exports-v2-1-06de4c556d55@nvidia.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 31f81f25968fa..1bc11585e41b3 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1679,8 +1679,17 @@ void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer *buf,
 
 	va_start(ap, fmt);
 	len = vsnprintf(tmp, SZ, fmt, ap);
-	buf_write(buf, tmp, len);
 	va_end(ap);
+
+	if (len < 0) {
+		perror("vsnprintf failed");
+		exit(1);
+	}
+	if (len >= SZ)
+		fatal("buf_printf output truncated for string %s: %d bytes needed, %d available\n",
+		      tmp, len + 1, SZ);
+
+	buf_write(buf, tmp, len);
 }
 
 void buf_write(struct buffer *buf, const char *s, int len)
-- 
2.53.0



