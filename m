Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B2B2D6605;
	Tue, 11 Nov 2025 01:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824635; cv=none; b=SlbYQ0BQLtsurD3sEMBZR53TlvgonoT7NGEQtjnPcvrdANlwsJ2e+PUe5k6DEHR07BSb7jqm3lUexT8djzmTE+L0XI/bwacF4SioqGnFBtGYQvZuUC8T7+th8WcVV1qBLVcSnBuHHQkMOQKQT+zpWWZGr8dBGdZ5rn6CaQFA8K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824635; c=relaxed/simple;
	bh=YV/F39sT4hznVZ+e6TzLnkIh3Za2lHW6TcBb4V7P4EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ddPFux87ynge7dVDfNEx9GrZwdgaYRD98ZH0RstzPJT4UvUHfXceoGCuBOwxH4bjR0kDocG52tgzIZjMgWouBvoPS8iaz8eEJBvF/gLBM1CO37eOcIAw2nj5NwvHHbjusieCbVWFA+sxIm3vqYLKaAwQxIMwkdESxrZdNqWL1BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gE3BQ+sp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gE3BQ+sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D0BC2BC87;
	Tue, 11 Nov 2025 01:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824635;
	bh=YV/F39sT4hznVZ+e6TzLnkIh3Za2lHW6TcBb4V7P4EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gE3BQ+spcFVEoClsGVb5gd22C1HURUEhY/nfnGUepIoZDlWNazGdSL2s8auxnXvxU
	 caE+PU+R16jEi4sxb69790Kn0igh2BgCwirj9+cKb55geS8Esg4WPD4TddnUXCGOOg
	 X4D4GdhfeCNPpzd47d10l6TNeqLwEyeRhoW0FaFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 489/565] kbuild: uapi: Strip comments before size type check
Date: Tue, 11 Nov 2025 09:45:45 +0900
Message-ID: <20251111004537.931437749@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6aec5e4365f9..682980781eb37 100755
--- a/usr/include/headers_check.pl
+++ b/usr/include/headers_check.pl
@@ -160,6 +160,8 @@ sub check_sizetypes
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



