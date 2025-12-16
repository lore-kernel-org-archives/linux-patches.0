Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A069345CCE;
	Tue, 16 Dec 2025 12:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887547; cv=none; b=YWTysIkYlApIGcPCGg48eR76mL3a/lHqcq3pOOcG1E7/b/EBEGJ7WWPiOMK99vDWKdp8b3kVirV5bmtP9bhMIh8Ce9vvptS+nzvmmJzg78XNfAiXzbf+wkKXiN1FbkxoQFLAiV1h1cPmI1N5ZFZozsmWOxawQi5PzvXMFSEGNpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887547; c=relaxed/simple;
	bh=OLbd0UZAu0T7czPYBayye8+w1Ftg7hdpbe8Y4m0mGGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOds8sKGuzwiLkNQRQJLL6jlkXyN3jKYRVkbdl0nbSQXON8iZhrY187Fgayyf43UJFsB3OutmrbuVF7IMdZ/l07CxkyIn/cDBAPyElRrlvllZMTDC3oSx5GQemPHxDYZlTm0leHDiNexJAs64nJ80i4FXk0ytTY+8PCTz4oJp2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXWm0a0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXWm0a0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16B2C4CEF1;
	Tue, 16 Dec 2025 12:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887547;
	bh=OLbd0UZAu0T7czPYBayye8+w1Ftg7hdpbe8Y4m0mGGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXWm0a0g0WHk317hulUeB87/dskrt6zbaUNiCoKx/Cce5VlRTK4RMl420zgQYorKA
	 6znh+TuH5XphfEwV6WcvcyL03oZ914ZKzJu5o2voL0inTbph4EV4pu7SgEkaAy7hU1
	 s97MbxPw5GrEfsVTVCOC5cOP/LIlVTrFbPv2OKoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 263/614] lib/vsprintf: Check pointer before dereferencing in time_and_date()
Date: Tue, 16 Dec 2025 12:10:30 +0100
Message-ID: <20251216111410.902271311@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



