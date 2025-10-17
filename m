Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCA4330B22;
	Fri, 17 Oct 2025 15:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716026; cv=none; b=U8/8A9ylOXQE7MjSvY0OMV8pYo8DRQ+AW3/QoE88PLOQJiCdXac7PAecOuDMXiavdkIvx5/octEKP2hS+VO6WEs/sEJFA2IHjsfxdqzyCrF3JnF9eb9e/4pytqU0wDEu6eUsshMjCbu8XvXHu6PO0VU0TQKZp9yuqLht9mywgYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716026; c=relaxed/simple;
	bh=XnTYSbfaRh81eelLoCN2sW7wVngYccgxsRBDV8C660g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=neyj1mAnBAlpzFYNx/M4w/Is4XrseUNmGiEpiR5QgbJxY21kXZX7jPm4LvH+/3p83UV5xgTZHqUuvhcjxH9FmIb6lZwgQWuzwwFzNQNNjPkVsz+yW5fe1GABNLO2WBhCOKHc+gDfQ1O8FDVJtlnwTgwfjNA2uGPCCSN97ETAd1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcndKALe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcndKALe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A6BC4CEE7;
	Fri, 17 Oct 2025 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716025;
	bh=XnTYSbfaRh81eelLoCN2sW7wVngYccgxsRBDV8C660g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcndKALeUfd8FLZBT45CC5gYckiZUd6IIobw66z20V36YmISZGBf47HxOdCBkXyHm
	 bcmZA2Z2DY+vF46fhzxozCe7PH49OcLtr38ZPm7nb8vaHYDvldtuQAnLSAN3iYEAQD
	 CTXMO0+QqGioIBJVXu5srMC/IxkGVfsSB9JfvKiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/276] tools/nolibc: make time_t robust if __kernel_old_time_t is missing in host headers
Date: Fri, 17 Oct 2025 16:52:21 +0200
Message-ID: <20251017145144.157184772@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0ea830e1ba17..f9eccd40c221f 100644
--- a/tools/include/nolibc/std.h
+++ b/tools/include/nolibc/std.h
@@ -46,6 +46,6 @@ typedef unsigned long       nlink_t;
 typedef   signed long         off_t;
 typedef   signed long     blksize_t;
 typedef   signed long      blkcnt_t;
-typedef __kernel_old_time_t  time_t;
+typedef __kernel_time_t      time_t;
 
 #endif /* _NOLIBC_STD_H */
-- 
2.51.0



