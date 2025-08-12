Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51202FA0F9;
	Tue, 12 Aug 2025 18:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023566; cv=none; b=JlpADoyeL5JUPXgrdAlYwFei1MCJbJ1U2r4Q4JX6GlbjK++jEDrKhmbcYOdJvrFYsuh85DBxb5ou+ARL8uzICivi+PpiMPVOyr8oel7dwy0FGsLIuVXbvId5MPuLNf18bk/7rYFEzHu1EXZwKlj5/8LgmcBe3If1tE4QkJ7yRyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023566; c=relaxed/simple;
	bh=7vPEG+3yb7PFCqOBNRaUze/BtkNoz93HFw1m1XTcrgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFrvTHn7/fqJkmX5tR74BMTnHJi775bE7eJTisrIYLAw9gRNLG8F08zIagQRKC6jKYUN/O4obOvmqC3Tspukv9+Jm2taQ6Z6S1VKgqA5NkbnTX5xvG0WYejmFEadCKlOHFp5oqQBk2TOAUOJxc5TZEd068V1tHbJHgbO28rBEk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJLTpS/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJLTpS/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CFDC4CEF0;
	Tue, 12 Aug 2025 18:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023566;
	bh=7vPEG+3yb7PFCqOBNRaUze/BtkNoz93HFw1m1XTcrgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJLTpS/M2ItsC/i8xkAcKTdDsJIdnukqrjp8GWzBaKJiQB7Cq1YG4Kabg923JSzTH
	 2kXepNMfYbvAOmAXrOWt+gXMdos6Xpdz7Qp6SoHZeDnlfBIGPuxGxQ6wELRt6zME6Z
	 iuWlJxXc6eTEGIWlXEkhllKf1z5LVxKyeu2VDfSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <listout@listout.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 117/627] samples: mei: Fix building on musl libc
Date: Tue, 12 Aug 2025 19:26:52 +0200
Message-ID: <20250812173423.767472340@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <listout@listout.xyz>

[ Upstream commit 239df3e4b4752524e7c0fb3417c218d8063654b4 ]

The header bits/wordsize.h is glibc specific and on building on musl
with allyesconfig results in

samples/mei/mei-amt-version.c:77:10: fatal error: bits/wordsize.h: No such file or directory
   77 | #include <bits/wordsize.h>
      |          ^~~~~~~~~~~~~~~~~

mei-amt-version.c build file without bits/wordsize.h on musl and glibc.

However on musl we get the follwing error without sys/time.h

samples/mei/mei-amt-version.c: In function 'mei_recv_msg':
samples/mei/mei-amt-version.c:159:24: error: storage size of 'tv' isn't known
  159 |         struct timeval tv;
      |                        ^~
samples/mei/mei-amt-version.c:160:9: error: unknown type name 'fd_set'
  160 |         fd_set set;
      |         ^~~~~~
samples/mei/mei-amt-version.c:168:9: error: implicit declaration of function 'FD_ZERO' [-Wimplicit-function-declaration]
  168 |         FD_ZERO(&set);
      |         ^~~~~~~
samples/mei/mei-amt-version.c:169:9: error: implicit declaration of function 'FD_SET'; did you mean 'L_SET'? [-Wimplicit-function-declaration]
  169 |         FD_SET(me->fd, &set);
      |         ^~~~~~
      |         L_SET
samples/mei/mei-amt-version.c:170:14: error: implicit declaration of function 'select' [-Wimplicit-function-declaration]
  170 |         rc = select(me->fd + 1, &set, NULL, NULL, &tv);
      |              ^~~~~~
samples/mei/mei-amt-version.c:171:23: error: implicit declaration of function 'FD_ISSET' [-Wimplicit-function-declaration]
  171 |         if (rc > 0 && FD_ISSET(me->fd, &set)) {
      |                       ^~~~~~~~
samples/mei/mei-amt-version.c:159:24: warning: unused variable 'tv' [-Wunused-variable]
  159 |         struct timeval tv;
      |                        ^~

Hence the the file has been included.

Fixes: c52827cc4ddf ("staging/mei: add mei user space example")
Signed-off-by: Brahmajit Das <listout@listout.xyz>
Link: https://lore.kernel.org/r/20250702135955.24955-1-listout@listout.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/mei/mei-amt-version.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/mei/mei-amt-version.c b/samples/mei/mei-amt-version.c
index 867debd3b912..1d7254bcb44c 100644
--- a/samples/mei/mei-amt-version.c
+++ b/samples/mei/mei-amt-version.c
@@ -69,11 +69,11 @@
 #include <string.h>
 #include <fcntl.h>
 #include <sys/ioctl.h>
+#include <sys/time.h>
 #include <unistd.h>
 #include <errno.h>
 #include <stdint.h>
 #include <stdbool.h>
-#include <bits/wordsize.h>
 #include <linux/mei.h>
 
 /*****************************************************************************
-- 
2.39.5



