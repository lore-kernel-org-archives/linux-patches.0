Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509242C0F83;
	Thu, 15 Jan 2026 17:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498998; cv=none; b=lVbBZOSdHqaWwdqW+xepfcOFIIg9EVbpF+Jcq5g8+GGi/LJMjJUHM8A62it5FqpnKSXFLXYFK9gSr2Q0h48WiLZb+Ucp2Iu1thb4nv3rvySP33bABR99Zve3lkIhogZSqGJaVo8ZBHqHmsx2fJ6Z9rwX9ACNhn/fIEsIuPUOYy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498998; c=relaxed/simple;
	bh=DCZpaptyWFTAuNI/R5R8IQL83Xcy9YKOqGCOLAOeTO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBIRIBHcVicJ+rQIUdA2ubZZaz4W30em9VNKhbiFkaYstsBmH61jSNT4Yj8aD+yE5RxgGnZS4rCwlxrjQ2mOUV763g8UWPAsIHTIz4XhP75jHriRmJ7OGFiaEF4usUdSYCAaokEVFmmPjbR308UMceI/l6xIXHKZAHZCoKK2Uj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+4vsEZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+4vsEZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14BDC116D0;
	Thu, 15 Jan 2026 17:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498998;
	bh=DCZpaptyWFTAuNI/R5R8IQL83Xcy9YKOqGCOLAOeTO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+4vsEZAMOi1E7g9jgM/TII5SwSTHYrCVhMESu2jx3QYNdw6jS2YXqePi3rhhxrXi
	 OdzoofE2KDJnrYEqcEfESlUjwx/iGJycZJqLpf3HM09dH8KzW5TrT87LXmkQ++ALHv
	 ppOLo1FDJhDXEprqA6IcQuoSb1j8QSDZv+pMtc/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/451] lib/vsprintf: Check pointer before dereferencing in time_and_date()
Date: Thu, 15 Jan 2026 17:44:33 +0100
Message-ID: <20260115164233.505278154@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index 90372391ce908..b643012ae47f6 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1829,9 +1829,6 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 	bool raw = false;
 	int count = 2;
 
-	if (check_pointer(&buf, end, tm, spec))
-		return buf;
-
 	switch (fmt[count]) {
 	case 'd':
 		have_t = false;
@@ -1886,6 +1883,9 @@ static noinline_for_stack
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



