Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6DC46C4B5;
	Tue, 21 Jul 2026 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648585; cv=none; b=ctMeoSLVcbUXSdu2cu110n4Wp8ly2Rn2rJf37m4PtQtZb8QJo9PxVkraybBZDgPOy4qsqNW8tSr5dZI6l1tnebLreVES44DvZbdsZNvJvz/jmvvdRqoySJuizlx3pTgoa6wKsybxWTLuqneOvcXUZkO3nJ9I4Dw1fulh227mEZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648585; c=relaxed/simple;
	bh=FQLNFTkePY0U3FmkE+t7sywFlQIHjRKvmVL9sIFgUMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J4ptyJy9bK9kNu2T7I5TEjGEVMOXbohj6yCdJbZLYb9X80SQPbMI3bisKq4z3pPAJIP18gPpUvstX81PgNhL/TVHWQEWBSlL6d7emPMivBmBVNC51M08PUetKtFwzrtv0K6jwAhv7kYMNEDIzvZ+nMk0BcmeF5DQ+N+NMfhxnRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpUdCdZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpUdCdZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAF31F00A3E;
	Tue, 21 Jul 2026 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648584;
	bh=CFEZXwQZHmk9VpjQIc7D3pGdo326IwdZl8uYldUfyOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpUdCdZ6p3ociwa4UNJFgSIqUOTn8Gxu4xOFkI1DGUrEMk4juUjwKVs54pKYeMJLJ
	 YeJvR0gb0SaMTN0yHTogTRx4WDXYscspq15kD6EzzPO009bQa4suSx+1mTgu/bJy+8
	 xQWXPx/0ZwNK+2MBLLAQ5MooMIpVad2/Pr9DVCuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@thingy.jp>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0254/2077] tools/nolibc: getopt: Fix potential out of bounds access
Date: Tue, 21 Jul 2026 16:58:47 +0200
Message-ID: <20260721152558.669839081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 87565e3b6a339f..3ad140f692dfe7 100644
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



