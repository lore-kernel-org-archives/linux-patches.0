Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18A714A82;
	Thu, 12 Dec 2024 15:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018657; cv=none; b=dr6pkbo7MyYa9ACGH7dNkhwoQrlb5iPKbmHbdfQYu3fv3ETUkNpZbcBJBn71pnjxWm6a5RVZqV+psiEJx67gUwNeNSB5ha3JE/3YW0Ku7nC5Gb8lAfzbTpbpeU9ofRR97Jr66qKaP/1IB6cqVE6+osQw2vkHpsZnFVZZ1wRXHMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018657; c=relaxed/simple;
	bh=eYw8M/CjGCfo2TdsST8OUR4+Cq3uEwIkrdv15/NUxmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pu4JL1jwLnUeEMeojoVNB7RcQm948zK8tzYzPUsi2dITop6ItTVYUaOniCB7uNvjUK9Ejhbv5DZd7ceZUUykxZi3JFMXizSf5cYSFPviIHk88K6uT0hAShoZeMnHPqwN8Ld1MtDkfNlxzJa5+uSn3keHf0fbQeEY0yb0DSMgsoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhYW5a/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhYW5a/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BB8C4CECE;
	Thu, 12 Dec 2024 15:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018657;
	bh=eYw8M/CjGCfo2TdsST8OUR4+Cq3uEwIkrdv15/NUxmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhYW5a/PCHYcU2GEMuU5E1eC3jAQpZUFdpKRJvYNdYtjwg/o8z282yY+mAT+t45Th
	 u2TG+C5tCJy/thys7TqDWDzjPevlcev6XRkmiJ6Dm8WEy6Mb10v/efjBYx0Ewe/CNl
	 GXWtoK62Rw/9DUpTZ71yJRAcSz8IyScXfqhzcd3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kir Kolyshkin <kolyshkin@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 325/356] sched/headers: Move struct sched_param out of uapi, to work around glibc/musl breakage
Date: Thu, 12 Dec 2024 16:00:44 +0100
Message-ID: <20241212144257.396627562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Kir Kolyshkin <kolyshkin@gmail.com>

[ Upstream commit d844fe65f0957024c3e1b0bf2a0615246184d9bc ]

Both glibc and musl define 'struct sched_param' in sched.h, while kernel
has it in uapi/linux/sched/types.h, making it cumbersome to use
sched_getattr(2) or sched_setattr(2) from userspace.

For example, something like this:

	#include <sched.h>
	#include <linux/sched/types.h>

	struct sched_attr sa;

will result in "error: redefinition of ‘struct sched_param’" (note the
code doesn't need sched_param at all -- it needs struct sched_attr
plus some stuff from sched.h).

The situation is, glibc is not going to provide a wrapper for
sched_{get,set}attr, thus the need to include linux/sched_types.h
directly, which leads to the above problem.

Thus, the userspace is left with a few sub-par choices when it wants to
use e.g. sched_setattr(2), such as maintaining a copy of struct
sched_attr definition, or using some other ugly tricks.

OTOH, 'struct sched_param' is well known, defined in POSIX, and it won't
be ever changed (as that would break backward compatibility).

So, while 'struct sched_param' is indeed part of the kernel uapi,
exposing it the way it's done now creates an issue, and hiding it
(like this patch does) fixes that issue, hopefully without creating
another one: common userspace software rely on libc headers, and as
for "special" software (like libc), it looks like glibc and musl
do not rely on kernel headers for 'struct sched_param' definition
(but let's Cc their mailing lists in case it's otherwise).

The alternative to this patch would be to move struct sched_attr to,
say, linux/sched.h, or linux/sched/attr.h (the new file).

Oh, and here is the previous attempt to fix the issue:

  https://lore.kernel.org/all/20200528135552.GA87103@google.com/

While I support Linus arguments, the issue is still here
and needs to be fixed.

[ mingo: Linus is right, this shouldn't be needed - but on the other
         hand I agree that this header is not really helpful to
	 user-space as-is. So let's pretend that
	 <uapi/linux/sched/types.h> is only about sched_attr, and
	 call this commit a workaround for user-space breakage
	 that it in reality is ... Also, remove the Fixes tag. ]

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230808030357.1213829-1-kolyshkin@gmail.com
Stable-dep-of: 0664e2c311b9 ("sched/deadline: Fix warning in migrate_enable for boosted tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h            | 5 ++++-
 include/uapi/linux/sched/types.h | 4 ----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3d83cc397eac1..323aa1aaaf91e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -63,7 +63,6 @@ struct robust_list_head;
 struct root_domain;
 struct rq;
 struct sched_attr;
-struct sched_param;
 struct seq_file;
 struct sighand_struct;
 struct signal_struct;
@@ -370,6 +369,10 @@ extern struct root_domain def_root_domain;
 extern struct mutex sched_domains_mutex;
 #endif
 
+struct sched_param {
+	int sched_priority;
+};
+
 struct sched_info {
 #ifdef CONFIG_SCHED_INFO
 	/* Cumulative counters: */
diff --git a/include/uapi/linux/sched/types.h b/include/uapi/linux/sched/types.h
index f2c4589d4dbfe..90662385689bb 100644
--- a/include/uapi/linux/sched/types.h
+++ b/include/uapi/linux/sched/types.h
@@ -4,10 +4,6 @@
 
 #include <linux/types.h>
 
-struct sched_param {
-	int sched_priority;
-};
-
 #define SCHED_ATTR_SIZE_VER0	48	/* sizeof first published struct */
 #define SCHED_ATTR_SIZE_VER1	56	/* add: util_{min,max} */
 
-- 
2.43.0



