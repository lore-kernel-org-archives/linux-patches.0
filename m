Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B633126A1;
	Tue, 11 Nov 2025 01:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825257; cv=none; b=tLoPGXn271C+D9LSLlmgSAoxvYpoyKMk/PFxa/tzO6PC919yvNI8hjK1yoLOSXFNUSnLByrNp42rmQu82C9l86d2+PD8rxGtokBQy1jpZngsHOwy0yje4T4I/QrdhsfBhb2iQpZgYT4cTqhDgxNjxoyMeJKdCu695HiVs/9ipHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825257; c=relaxed/simple;
	bh=QTO+Wussn6+hyLInu/MJhXFe4BT5qjfLG3JukbofazM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TtogNKyEpxe+vh55fBnesYQtuPButwaMciptOyK3sdtPSVSTwlaiv0CYDUXKqJG9W2jzoPB7H3g9SW5RWUEqNPUsDImx+WyjHOJSPv2qqJJyqfKF2pq8BIQAH+mLOBzWOg5pwFrbeTX147JneYnZJK7I/kgs6EbM9NN53lxScwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buugyCTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buugyCTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10520C19421;
	Tue, 11 Nov 2025 01:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825257;
	bh=QTO+Wussn6+hyLInu/MJhXFe4BT5qjfLG3JukbofazM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buugyCTV/rwPoT2orGYD4q6njaJttfWkq7vJ+bd7/Kc8hvj2SkbHGy3FilVfVhzAU
	 HjjnsyFs5UvLmwwtvJChEU3zuiX46cbWsxX0gtoXYOxDojDHkOZc0hB+3Th7ZTbYvO
	 P2gHbsxS5ZeGHoX9elyd5U0qtGsfpuzMrptXlJXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 728/849] kbuild: uapi: Strip comments before size type check
Date: Tue, 11 Nov 2025 09:44:58 +0900
Message-ID: <20251111004554.035686131@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 66128f4287b04aef4d4db9bf5035985ab51487d5 ]

On m68k, check_sizetypes in headers_check reports:

    ./usr/include/asm/bootinfo-amiga.h:17: found __[us]{8,16,32,64} type without #include <linux/types.h>

This header file does not use any of the Linux-specific integer types,
but merely refers to them from comments, so this is a false positive.
As of commit c3a9d74ee413bdb3 ("kbuild: uapi: upgrade check_sizetypes()
warning to error"), this check was promoted to an error, breaking m68k
all{mod,yes}config builds.

Fix this by stripping simple comments before looking for Linux-specific
integer types.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/949f096337e28d50510e970ae3ba3ec9c1342ec0.1759753998.git.geert@linux-m68k.org
[nathan: Adjust comment and remove unnecessary escaping from slashes in
         regex]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 usr/include/headers_check.pl | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/usr/include/headers_check.pl b/usr/include/headers_check.pl
index 2b70bfa5558e6..02767e8bf22d0 100755
--- a/usr/include/headers_check.pl
+++ b/usr/include/headers_check.pl
@@ -155,6 +155,8 @@ sub check_sizetypes
 	if (my $included = ($line =~ /^\s*#\s*include\s+[<"](\S+)[>"]/)[0]) {
 		check_include_typesh($included);
 	}
+	# strip single-line comments, as types may be referenced within them
+	$line =~ s@/\*.*?\*/@@;
 	if ($line =~ m/__[us](8|16|32|64)\b/) {
 		printf STDERR "$filename:$lineno: " .
 		              "found __[us]{8,16,32,64} type " .
-- 
2.51.0



