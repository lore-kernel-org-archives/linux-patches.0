Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61792C3268;
	Thu, 15 Jan 2026 17:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497589; cv=none; b=qpfmTYVR0xO9WMZIVgRd7KTuMnGyVPhTgbWm8L+9C2+2uU71hORx4zVkDzNkI5ysnYO0nvPpZ15OgJQKcs0YtVz1BytuzXO3H58wbT7awQLNpxRiUPG8L39zRm2cCVALEyPd+09q9ZxCZqKbQwDm44hQAEsl4aPNkzs/lgMpdVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497589; c=relaxed/simple;
	bh=gQJOjZvJclWPDw02cR5OTx40r5s2/QA08Huv1gG4yaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvMaWMi4Qw3cGkjqp0XSrqXAG0Xd64ZleCbAoyryed/U1OQ7+6doGs7TP9Ls87DTvxIrtC2D08OWIhHGdvYco/QjY5oR86TIUS8Mo+X/EbqxXKWqwdD5KrePm8vyGXH/AgeeEG/viyNwnDoaDq0+bffSxGvtKjNF5LbQX1FbUJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QqNSHJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QqNSHJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC4BC116D0;
	Thu, 15 Jan 2026 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497589;
	bh=gQJOjZvJclWPDw02cR5OTx40r5s2/QA08Huv1gG4yaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QqNSHJp2Pdjg32LyFeBDKmVvLQtCjJgkmiXEZ9eC/2uK0JBNd9Hoi0bSgvKowr4l
	 YotziJBkfUZ/yBi2vEoodKN+onkcDEDy6Aa+NQ0yXso4T/8Xrn8Fm9UWGysx07pt86
	 jRDmDCER26JwHOIQHjeEqollgTZLxeJkX/2wpjdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/554] lib/vsprintf: Check pointer before dereferencing in time_and_date()
Date: Thu, 15 Jan 2026 17:42:47 +0100
Message-ID: <20260115164249.906401703@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index e46eb93c115dd..fc1cf66fffdb3 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1889,9 +1889,6 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 	bool found = true;
 	int count = 2;
 
-	if (check_pointer(&buf, end, tm, spec))
-		return buf;
-
 	switch (fmt[count]) {
 	case 'd':
 		have_t = false;
@@ -1957,6 +1954,9 @@ static noinline_for_stack
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



