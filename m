Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED4E271446;
	Mon, 13 Oct 2025 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367558; cv=none; b=p3Fsnw78T4Z8WcCcjoYX+4w4HEcWXja0rcGUrPJK7yq5dMaTTg+l2iOIMzu+aVPDMqjiMsV7xJhvVk8iXmgGrhG+mdstEsKnEAo9o0Q6DjjHRQgi2cwzDTC0o4xyK9ugWDjZ0AuMBNK0qQhFYfTWaTPEVvMiXeT5sZw+UrZ8sGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367558; c=relaxed/simple;
	bh=b6ASlOpD/jTo+cIPb2Gv+ygn+ksZ5qVlkPVU6x4v1gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XSXCKTzW7TyhmMcFPgJP0gewBZn1CRiZnYYwkXic2DU3SmeAIy86Y+tgViNnFv6xLnUoQ6eXNLL+TPXLixHsIsDAG6HuCjYefuM5jwIy1GMu6/tcy9COY//6KW5TjJASdKwZeVPa9D8QxM+w6PsV+IrPmHiA+jvvknWSACi46Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjdbx7Rp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjdbx7Rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0012C4CEE7;
	Mon, 13 Oct 2025 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367558;
	bh=b6ASlOpD/jTo+cIPb2Gv+ygn+ksZ5qVlkPVU6x4v1gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjdbx7RpJ7CMF2PvKh9ra3nfidddRpI/dWZjv65U9oCJl1v+CBSDMZ/nKt7J+J30r
	 P+7fmJTnYSLf9ExWkc6VaMUbp6k+PJSwbNmiXnoD+gdxWpjdity7NRFd9HHeW3BRba
	 O2KmXfRy9Gas/3jMlLhUDGMn+rL+IXmGUDf1CMuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/196] tools/nolibc: make time_t robust if __kernel_old_time_t is missing in host headers
Date: Mon, 13 Oct 2025 16:44:04 +0200
Message-ID: <20251013144317.117995805@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

[ Upstream commit 0ff52df6b32a6b04a7c9dfe3d7a387aff215b482 ]

Commit d5094bcb5bfd ("tools/nolibc: define time_t in terms of
__kernel_old_time_t") made nolibc use the kernel's time type so that
`time_t` matches `timespec::tv_sec` on all ABIs (notably x32).

But since __kernel_old_time_t is fairly new, notably from 2020 in commit
94c467ddb273 ("y2038: add __kernel_old_timespec and __kernel_old_time_t"),
nolibc builds that rely on host headers may fail.

Switch to __kernel_time_t, which is the same as __kernel_old_time_t and
has existed for longer.

Tested in PPC VM of Open Source Lab of Oregon State University
(./tools/testing/selftests/rcutorture/bin/mkinitrd.sh)

Fixes: d5094bcb5bfd ("tools/nolibc: define time_t in terms of __kernel_old_time_t")
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
[Thomas: Reformat commit and its message a bit]
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/std.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/std.h b/tools/include/nolibc/std.h
index a9d8b5b51f37f..f24953f8b949c 100644
--- a/tools/include/nolibc/std.h
+++ b/tools/include/nolibc/std.h
@@ -33,6 +33,6 @@ typedef unsigned long       nlink_t;
 typedef   signed long         off_t;
 typedef   signed long     blksize_t;
 typedef   signed long      blkcnt_t;
-typedef __kernel_old_time_t  time_t;
+typedef __kernel_time_t      time_t;
 
 #endif /* _NOLIBC_STD_H */
-- 
2.51.0



