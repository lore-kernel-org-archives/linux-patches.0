Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22726313E13;
	Tue, 16 Dec 2025 11:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884293; cv=none; b=kZRTSFjynKBiu+ji9iO/UmevD2zdFgi9AgjJdJMJY0wE1QV5epYUn26YKXlrOEl40mtxJ1p7sGRZXyLS2x/et2WJbZmC3FBQPB69MXhcJg6Ydvr1s1Da1e+2Zp63hYLL2++Kvnx9IGuQa1QRoGwZ/ZqePq9gw0FNBHg7AmcDIsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884293; c=relaxed/simple;
	bh=N6r2JJNKMqaPWBpBB9FgHWg62B6XHZQEVNfbOLhBxbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDG10BXmQfZTqyO4IFDXTosm16cz3Hzn0nlBiVYPJYZVLTJ0uldrZnbe+LqNKh9yvFCkn2H6tYSMEwCLcOBhMy75o6uJRRS6BeGnv37Q43QHM71l37XKCONu37FJhE2MrAnjPjeGKiCwMUAnEXMVdOoIr6dEcR8ZKB81XInWM24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4X8YNbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4X8YNbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8676BC4CEF1;
	Tue, 16 Dec 2025 11:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884293;
	bh=N6r2JJNKMqaPWBpBB9FgHWg62B6XHZQEVNfbOLhBxbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4X8YNbnVn9ZXwSfteGtFi4ZSKp59xCmKRO0M4u7PM/eE2P/QppLuUEYEEq2alAxe
	 Ef1VO67gRmeifbcVd5XccEInvuDqYNLn7+In8biWYR2abIUQSshAEEt62OFiIjhk+9
	 yhIT6N2Uj7mRQMRq0Pjn4ga2sehkh7zpB/e3x4R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/354] lib/vsprintf: Check pointer before dereferencing in time_and_date()
Date: Tue, 16 Dec 2025 12:11:57 +0100
Message-ID: <20251216111326.350440062@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 372a12bd5df0199aa234eaf8ef31ed7ecd61d40f ]

The pointer may be invalid when gets to the printf(). In particular
the time_and_date() dereferencing it in some cases without checking.

Move the check from rtc_str() to time_and_date() to cover all cases.

Fixes: 7daac5b2fdf8 ("lib/vsprintf: Print time64_t in human readable format")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://patch.msgid.link/20251110132118.4113976-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vsprintf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a69e71a1ca55e..511c55d7b3abf 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1860,9 +1860,6 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 	bool found = true;
 	int count = 2;
 
-	if (check_pointer(&buf, end, tm, spec))
-		return buf;
-
 	switch (fmt[count]) {
 	case 'd':
 		have_t = false;
@@ -1928,6 +1925,9 @@ static noinline_for_stack
 char *time_and_date(char *buf, char *end, void *ptr, struct printf_spec spec,
 		    const char *fmt)
 {
+	if (check_pointer(&buf, end, ptr, spec))
+		return buf;
+
 	switch (fmt[1]) {
 	case 'R':
 		return rtc_str(buf, end, (const struct rtc_time *)ptr, spec, fmt);
-- 
2.51.0



