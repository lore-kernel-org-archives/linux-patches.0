Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C05C34B1B4;
	Tue, 16 Dec 2025 11:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885714; cv=none; b=ugJqf40Ts6hvVPQxsP5bDVPprL/VPET2+OdqoOZyHFJxqjlZCRtorcyH2wYp0zceOC+S4cmMde1Kbf8fQ+B1fFXJSPTlMcAitdxBSbBEBaKuuq3e76TSGXhcFCGly2HK2Gb/YepqZxYbMR/rkFeBzS2YA4OwpTOfpTbA1vKFY6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885714; c=relaxed/simple;
	bh=LYdl5Fnww+pqk3BiWz+RgcexLrQJ7GsgOalBXOSbmiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5KrkuQuHspG7U0rdA0RwHNwYMCXOjdZndiuf4LOo2kofrCfmxouYiqzwxpNayWzRP6vowgykR3tjCguVNsliWWzXAFrLaXSbC01NAuC45eBHWtgwWZuu4eC18vSwnCUm75KBwSOddoZITOQtM5v2HIFTluoonGkOHMXhv9bZR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LX72++Ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LX72++Ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBBBC4CEF1;
	Tue, 16 Dec 2025 11:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885714;
	bh=LYdl5Fnww+pqk3BiWz+RgcexLrQJ7GsgOalBXOSbmiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LX72++Ct7cZ8fPbN+paEtn458xU2l/CmNIN/P+k9q2QwpFG99frN0KUtjDhLcigab
	 CQcwhv/wQmeMPJDI0SspXgKDfKI1XQe37g8esM+Pu2YYkYb9erUwS03CvQ6Q1dn7Ka
	 oGL/dAKZDjPfcjXXbJ+H9W1BY4lTSsrtVHFv9vAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 223/507] lib/vsprintf: Check pointer before dereferencing in time_and_date()
Date: Tue, 16 Dec 2025 12:11:04 +0100
Message-ID: <20251216111353.584473713@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index eb0cb11d0d126..a356965c1d734 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1928,9 +1928,6 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 	bool found = true;
 	int count = 2;
 
-	if (check_pointer(&buf, end, tm, spec))
-		return buf;
-
 	switch (fmt[count]) {
 	case 'd':
 		have_t = false;
@@ -1996,6 +1993,9 @@ static noinline_for_stack
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



