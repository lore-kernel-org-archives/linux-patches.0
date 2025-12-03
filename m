Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2123AA186;
	Wed,  3 Dec 2025 16:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779579; cv=none; b=VNi9Xg5gK3AXFV5or0ajlsPHWZxLDfGlyg8ET+zrv1/XCLCkb5TAc1rTt4uxRsvD+KeeYRYV+NQtdS4ar/kjplHqsnQlVQJYPPf0D3NCAtN3JS0zrrI7TVKw8W97QUNWSRtttT31g3PakLcIjFRLV08aFLEuO3ZHUpJ0CTrkqzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779579; c=relaxed/simple;
	bh=yNo7Xmec+uuGKiunxB6k8yGRQqynx0js1vnh3sTRkZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZafuMerGsC8jIFK68qF/5DpPbI2qAnPLs+lFTbo2vo2kLrX1/1Jt3maric4iaPrU+xXW4MrOHghsXM48QaBBxb5Z3TdZRoHABoHJiT3Npvx4M4qzSwqQcXfNvq7yjJGNAvHdBdWQVpjC5lxQ6rJr4xtfURKUoS7kLfI+ruNeKGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGLFakWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGLFakWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B489C4CEF5;
	Wed,  3 Dec 2025 16:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779578;
	bh=yNo7Xmec+uuGKiunxB6k8yGRQqynx0js1vnh3sTRkZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGLFakWB7iCT4gN2NbbtOuSbQX4gM8pnWdspbps+VjmaR4gtLlZ4vNKEl3OiYTXPS
	 3efufZqqJCe0hxhtwfqyaL84Hg3AdFmaisQUieugW3RJjS3BtMg3heIWHhpP6DRWOE
	 T1znGCRl9NCmge3BGblNxqcUnXJPM2u5Dg0GVnbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 299/568] kbuild: uapi: Strip comments before size type check
Date: Wed,  3 Dec 2025 16:25:01 +0100
Message-ID: <20251203152451.658306978@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



