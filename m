Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43402F12D4;
	Fri,  9 Jan 2026 11:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959806; cv=none; b=EVKC5ZeIfrRtrJz5LeiV7Ee8XKEmkCXsF0juMAmGzn1sbbU/t7gK5ZDeJmnsgFNJxYfhLwnGrFRbuz3SBohPKgkX6u6Vmtvl0zZPojsmH8zgCzE2cTkSXvnidhzZK+4hZZh5Hhk6uk/jOlGcJOIA7jOfLm5IIKyadKUFhAoLGi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959806; c=relaxed/simple;
	bh=iH2Dil4KB2t1QwrNkP5/l2cCzkcUOJW66R4gUafds+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROPXqH7DnxbEn0qJaioVJOXxoDrHqo71fewHFWFhO05lwhWzDmJifwL/5ugqNDOtyPZywRLCpnZuSTTN3T0aWXauhVER29wo9JyhrZIB86ziN2x3/fccRb3qFwSVuzfgC8gnAkVaLpjYBneE9fUNWaiiSJTUpk9kphV7gTdjsNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1CX842N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1CX842N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FB5C4CEF1;
	Fri,  9 Jan 2026 11:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959806;
	bh=iH2Dil4KB2t1QwrNkP5/l2cCzkcUOJW66R4gUafds+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1CX842NHG8gLFK50/bNRYtdDSVkcIEA/eAmbOvhum0RzhVpWtla36lYBg7JyhOUM
	 9q4boW2PxkUexbdtFJaAmkebyfJMB1hdefpuYXZORrhKsUr3aklCTSdTemju4Rq4aW
	 LzYINpb6SlCLSYnuCSSEeGvYpc96hYTxoeiVI1R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/737] lib/vsprintf: Check pointer before dereferencing in time_and_date()
Date: Fri,  9 Jan 2026 12:34:47 +0100
Message-ID: <20260109112139.565580796@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f4ab2750cfc12..fc5ffc1b16903 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1859,9 +1859,6 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 	bool found = true;
 	int count = 2;
 
-	if (check_pointer(&buf, end, tm, spec))
-		return buf;
-
 	switch (fmt[count]) {
 	case 'd':
 		have_t = false;
@@ -1927,6 +1924,9 @@ static noinline_for_stack
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



