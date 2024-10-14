Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3464020EB;
	Mon, 14 Oct 2024 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916831; cv=none; b=R3OLhx4JeHAZ8k3ki5H8dEjFf9JT8pceUOMdk0dIR43qO4V+bhRS6CbZ/bBlKQpE1Vo5CsaW6ALR0+4178fsvt104dkcu0hMMLDSt5f1tP2E1QDZ3BQ2DnGQj/+12M5OzjXg8lHScNiF1iCh9ZUzL8CK/bbGSZUGz7wCDSZIlzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916831; c=relaxed/simple;
	bh=yfYIgEgvuj04JsCIj0gRt/jvrrzHlvz6Z6EsYvJVDKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sn9VeXWHho9BlB8MYgbHMeDnqg1MC2Btq7o6ywBGnbXKLuESet92RoNWfA9W7HVxR7LGVieCWbSWSyGPO+KgYbzF3SAIFA3uv4lj/SXHNkMJTmZ3Pf+amHBLD/W5uPecr6euNKypNdIzOZDLTtluN/ck3tiNnWbo9vDHWdexRTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVGU4TdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVGU4TdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F97C4CEC3;
	Mon, 14 Oct 2024 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916831;
	bh=yfYIgEgvuj04JsCIj0gRt/jvrrzHlvz6Z6EsYvJVDKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVGU4TdGcAILCUX46d0gfexc9QuzHzCk6FccA06z052XwaC7U4ogqCrJ8ibJbCKe2
	 zeojT5y5eyhkqyhLtfGwgN2zrozrqNWrXTbDGUhexXluE5uTDWzAhN3mLECdYQ2rhW
	 fRK5lek0wLAclCUxni/ep+oyA80sdtf+w/ak42Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/213] lib/build_OID_registry: avoid non-destructive substitution for Perl < 5.13.2 compat
Date: Mon, 14 Oct 2024 16:19:11 +0200
Message-ID: <20241014141044.748803436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit 2fe29fe945637b9834c5569fbb1c9d4f881d8263 ]

On a system with Perl 5.12.1, commit 5ef6dc08cfde
("lib/build_OID_registry: don't mention the full path of the script in
output") causes the build to fail with the error below.

     Bareword found where operator expected at ./lib/build_OID_registry line 41, near "s#^\Q$abs_srctree/\E##r"
     syntax error at ./lib/build_OID_registry line 41, near "s#^\Q$abs_srctree/\E##r"
     Execution of ./lib/build_OID_registry aborted due to compilation errors.
     make[3]: *** [lib/Makefile:352: lib/oid_registry_data.c] Error 255

Ahmad Fatoum analyzed that non-destructive substitution is only supported since
Perl 5.13.2. Instead of dropping `r` and having the side effect of modifying
`$0`, introduce a dedicated variable to support older Perl versions.

Link: https://lkml.kernel.org/r/20240702223512.8329-2-pmenzel@molgen.mpg.de
Link: https://lkml.kernel.org/r/20240701155802.75152-1-pmenzel@molgen.mpg.de
Fixes: 5ef6dc08cfde ("lib/build_OID_registry: don't mention the full path of the script in output")
Link: https://lore.kernel.org/all/259f7a87-2692-480e-9073-1c1c35b52f67@molgen.mpg.de/
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Suggested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/build_OID_registry | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/build_OID_registry b/lib/build_OID_registry
index 56d8bafeb848b..8267e8d71338b 100755
--- a/lib/build_OID_registry
+++ b/lib/build_OID_registry
@@ -38,7 +38,9 @@ close IN_FILE || die;
 #
 open C_FILE, ">$ARGV[1]" or die;
 print C_FILE "/*\n";
-print C_FILE " * Automatically generated by ", $0 =~ s#^\Q$abs_srctree/\E##r, ".  Do not edit\n";
+my $scriptname = $0;
+$scriptname =~ s#^\Q$abs_srctree/\E##;
+print C_FILE " * Automatically generated by ", $scriptname, ".  Do not edit\n";
 print C_FILE " */\n";
 
 #
-- 
2.43.0



