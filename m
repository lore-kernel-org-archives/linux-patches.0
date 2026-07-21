Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8765E326D44;
	Tue, 21 Jul 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655888; cv=none; b=biYvN2DNAc51SKdjCuUaZ0aqz4lXyeLgP0AgkXtSVYdZsVMFRVxybVOUcLIRY6q10qk8FFQMxUhQRDtbAhMD8U8M2ePUWM327CR4pzbYkrw3YMpYuLxTdPO4kFfek3jHv5COPGtgXdrLfEx3S0NmI/j3B+Z3Ledx7WByfKIlk0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655888; c=relaxed/simple;
	bh=6jop+VqChku7KugTXoJa0BpR9CkBjOk/WahufHJAza4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DdkoItXiMA87PUJV6qk6sRiUUfjb7a1KneTudCUy4RPf5A186dPEHm1QopGLkMlWfMKcVLH8om49aqO18FtnjUMxSyNpGo9WskkXjedNARumCSaOqsGNbg5F+B8B6LzWnrb8MUCy3Va0tBwDRuiNi2CyrRHibKCRrvBDRlUElEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNyXbWQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNyXbWQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06671F000E9;
	Tue, 21 Jul 2026 17:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655887;
	bh=JzLBtI4inPx4ZJsw0MUOXDNE1nG4aP/O9evpO+Kv8fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNyXbWQ26vvbHFchCs+BIoSH/caqtqWiyjYCqA1L69n+fCj2QRKCAFgjIlmXlGaxv
	 cmW7oN53p9xtvjAbyaIVKm43IgBzGlbZzrfOWthOljxA0ZNqEiGcu6I4u9vkcWFlF+
	 srS1DJmIHrhuub0QP5FvCwFP5hpR2Zr+KxFaZxzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@thingy.jp>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0178/1611] tools/nolibc: getopt: Fix potential out of bounds access
Date: Tue, 21 Jul 2026 17:04:54 +0200
Message-ID: <20260721152518.918524373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@thingy.jp>

[ Upstream commit 136ca91411b0b637e862eb7b1cce2a56853edd17 ]

Running clang-tidy on a program that uses getopt() from nolibc
this warning appears:

getopt.h:80:6: warning: Out of bound access to memory after the end of the string literal [clang-analyzer-security.ArrayBound]
80 |         if (optstring[i] == ':') {

This looks like a very unlikely case that an argument
inside of argv is being changed between getopt() calls.

Adding a check for d becoming 0 in the guard after the loop
stops getopt() getting far enough to access beyond the end
of the array and seems to correct the issue.

Fixes: bae3cd708e8a ("tools/nolibc: add getopt()")
Assisted-by: Claude:claude-4.6-sonnet # reproducer
Signed-off-by: Daniel Palmer <daniel@thingy.jp>
Link: https://patch.msgid.link/20260520111931.1027758-1-daniel@thingy.jp
[Thomas: clean up commit message a bit]
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/getopt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/getopt.h b/tools/include/nolibc/getopt.h
index 217abb95264b28..0329690941876a 100644
--- a/tools/include/nolibc/getopt.h
+++ b/tools/include/nolibc/getopt.h
@@ -71,7 +71,7 @@ int getopt(int argc, char * const argv[], const char *optstring)
 		d = optstring[i++];
 	} while (d && d != c);
 
-	if (d != c || c == ':') {
+	if (!d || d != c || c == ':') {
 		optopt = c;
 		if (optstring[0] != ':' && opterr)
 			fprintf(stderr, "%s: unrecognized option: %c\n", argv[0], *optchar);
-- 
2.53.0



