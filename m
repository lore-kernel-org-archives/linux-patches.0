Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933413358BE;
	Fri, 21 Nov 2025 13:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733024; cv=none; b=Bwqt4T2SSPGQ2qZBqmXEbvGy2rhqPttV0f+EhViX4fvgLRutYGNVwRI0YK3uAkn87LBrfDt3GMRi2BDaLC2+MKBuUiuK73/NjzCb45aVE35Wd8yXHZxIKMPScKQhMSwTOEkKWBMU7C2TjjA4/O6UREthoAt3naFcZsawts73de0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733024; c=relaxed/simple;
	bh=am8Miq0uIfuNyRCF2XBHD/YaSPGCHjxaVXc/Q+7yM2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6OfwXw2tEUKd1mvm7gsooDBIiLPgF/ImzYJg2waI9e4P3IH/LCoCwf8pktmdtdEvNC4q10Faqen5YZibUvcUBX7DERRTuQq24fSMpkK4xhEyz/ux6i01Ic0zBRsuWNcB7e0f7H24inaQlLBAOSWgm6U93qKOU6/FJjWYi4RHis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqVuDq6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqVuDq6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14365C4CEF1;
	Fri, 21 Nov 2025 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733024;
	bh=am8Miq0uIfuNyRCF2XBHD/YaSPGCHjxaVXc/Q+7yM2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqVuDq6d2iHVo0/Fk3d4AQBQqP8w75yulwyGCwuKRRcv8+CZgn0TwhIxc340eUwjh
	 0ZF3og/owVurZ8fWzutw8VYi5HThjjUdJ9AnVMTke/H++Q5EyaZpb7ItlvC3tcEzDd
	 9x2/sJ2q+X+VOoaoBoq8Aebo9ZXebRc7oWJ5fPvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 325/529] kbuild: uapi: Strip comments before size type check
Date: Fri, 21 Nov 2025 14:10:24 +0100
Message-ID: <20251121130242.591149564@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



