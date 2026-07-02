Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3EA3A1E92;
	Thu,  2 Jul 2026 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010867; cv=none; b=si83Lu9jfTohUeAynW36e8Y6i8ND5LH4w16CE74DK2UnoR4Cx1XWzJ4iI8jwn6Muu1/3GxMxvGrUd8s6yU9PtSsRvQnG3jdR8Kz1QSjWaxfH6wXVc0Iy0kMrBdArTGJXs5YoSo8CEjmljvcOlBaFffc3VSvUI4OjIGcYe2U/wXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010867; c=relaxed/simple;
	bh=HXk1E4qezyr/7+mwitNpBkD13jG/hvy84a372DPU+hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/2GrVxPSRsWU/T1jw7AT+tGIE4AjTCunqeksaNrqAKHDwHxtaHW00Qyvt4Oe/Ja7m1pXxNuyXFCW9dIvH/vjeFlx2WIZxczPeS/QXAFI+EDRssiP+ZDXTAmlx+2Fg9PU1zr9sLNuJoXlxLCT7eoXkDG1luTxY0ybyXETi11EPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUJHhNPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUJHhNPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC521F000E9;
	Thu,  2 Jul 2026 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010866;
	bh=6ZigGjI92MuvJT4or0sUy7Rf5a6+BuACiYUyaGRimoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUJHhNPYFnyqrqGytTt09kBHD8Osf4dZ2zktYYOA3PN+9ISkwJuXoYIIV5SMsQsbH
	 GZAgmD/+y/vQ7TORUdUx0W3Q3C2mJDrFU+Vo40fH/7EGiAguNx4AJ5RmuXYd6da43W
	 w3+/Z1IbtHPof4rEhqAxVeLMe8NSpP1cx1MlF2aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.6 067/175] ftrace: Check against is_kernel_text() instead of kaslr_offset()
Date: Thu,  2 Jul 2026 18:19:28 +0200
Message-ID: <20260702155117.205597497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit da0f622b344be769ed61e7c1caf95cd0cdb47964 ]

As kaslr_offset() is architecture dependent and also may not be defined by
all architectures, when zeroing out unused weak functions, do not check
against kaslr_offset(), but instead check if the address is within the
kernel text sections. If KASLR added a shift to the zeroed out function,
it would still not be located in the kernel text. This is a more robust
way to test if the text is valid or not.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>
Link: https://lore.kernel.org/20250225182054.471759017@goodmis.org
Fixes: ef378c3b8233 ("scripts/sorttable: Zero out weak functions in mcount_loc table")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Mark Brown <broonie@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20250224180805.GA1536711@ax162/
Closes: https://lore.kernel.org/all/5225b07b-a9b2-4558-9d5f-aa60b19f6317@sirena.org.uk/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6528,7 +6528,6 @@ static int ftrace_process_locs(struct mo
 	unsigned long count;
 	unsigned long *p;
 	unsigned long addr;
-	unsigned long kaslr;
 	unsigned long flags = 0; /* Shut up gcc */
 	unsigned long pages;
 	int ret = -ENOMEM;
@@ -6578,9 +6577,6 @@ static int ftrace_process_locs(struct mo
 		ftrace_pages->next = start_pg;
 	}
 
-	/* For zeroed locations that were shifted for core kernel */
-	kaslr = !mod ? kaslr_offset() : 0;
-
 	p = start;
 	pg = start_pg;
 	while (p < end) {
@@ -6594,7 +6590,18 @@ static int ftrace_process_locs(struct mo
 		 * object files to satisfy alignments.
 		 * Skip any NULL pointers.
 		 */
-		if (!addr || addr == kaslr) {
+		if (!addr) {
+			skipped++;
+			continue;
+		}
+
+		/*
+		 * If this is core kernel, make sure the address is in core
+		 * or inittext, as weak functions get zeroed and KASLR can
+		 * move them to something other than zero. It just will not
+		 * move it to an area where kernel text is.
+		 */
+		if (!mod && !(is_kernel_text(addr) || is_kernel_inittext(addr))) {
 			skipped++;
 			continue;
 		}


