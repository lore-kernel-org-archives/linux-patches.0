Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B81311C32;
	Mon, 13 Oct 2025 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368197; cv=none; b=mUf3sBJW4LRxsIqKC74tTDxlduBg22qSqbt+BN9paKiJUuzwKzfOCa2LTKcjs4Qja9uJc/uayf8ylKqdDcwrx6oqMMvNq3CPWdJS4lIVnfXPj/vhSRxSqhWahpSeOIM/lVrvdrnWmZFeqtAKqVp1cTodVhHUppqDHnNMo+2yMQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368197; c=relaxed/simple;
	bh=jmdu65ogfbm+B9CALmrkG+NQBARvKatvba8Ieft/Y6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DAp+APwxx0blTMP3p4HYfz827BzDL7Vx3DY7g7molVFb5eRBnVdD+8EbWG61YxObgKnI9STTtKgQIjDhUNcqVi5yHAnT8GE3/2I9zGEEtb3XxCbGIW2L6HOiqJgkrSEUkl/q4rdiGv3DWnHo5yrrZOI5WYrc0N2j7gCCJvYs5wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKwsWmf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKwsWmf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BECC4CEE7;
	Mon, 13 Oct 2025 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368197;
	bh=jmdu65ogfbm+B9CALmrkG+NQBARvKatvba8Ieft/Y6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKwsWmf5HzuM2oEluT5X7feB0d+Yb4g7/E8PJrGWjhmAys7JxYf0PnUt5PpwPA1F7
	 f9rs2+DZs4uojzzvk78R/7Ci1YljV+LHi/O5oUGuIov/5a8H4mqUOFQM02HPoKonpU
	 ZuU0cGBB1CkcK8k/tJ3ZfKYTHvNAINEUin0xJZnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/262] tools/nolibc: make time_t robust if __kernel_old_time_t is missing in host headers
Date: Mon, 13 Oct 2025 16:43:40 +0200
Message-ID: <20251013144328.936514300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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



