Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D780346B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33717C433EF;
	Mon, 16 Jan 2023 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886461;
	bh=k58RRflD6JGFt7EF93aoHdhUah760czXjm3Zmz65dMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVzk4sIk4W2Bp6GrDczKQtV9i+L/3+fC5rtLeWiCgRgrWTpkQlu7n90UsRUNagDuO
	 hV2cPEqrsh4vltHBxEtCO955fSB2b3Lbh/68ugr9liQhOE0iuPi2rqQFtlDNtwlfiy
	 66OOj/oIpWJ8kNP+jwLfNxj8O8vU0SDw4AmWD3a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wvw@google.com>,
	Midas Chien <midaschieh@google.com>,
	Connor OBrien <connoro@google.com>,
	Kees Cook <keescook@chromium.org>,
	Anton Vorontsov <anton@enomsg.org>,
	Colin Cross <ccross@android.com>,
	Tony Luck <tony.luck@intel.com>,
	kernel-team@android.com,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 439/658] pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion
Date: Mon, 16 Jan 2023 16:48:47 +0100
Message-Id: <20230116154929.623668848@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Stultz <jstultz@google.com>

[ Upstream commit 76d62f24db07f22ccf9bc18ca793c27d4ebef721 ]

Wei Wang reported seeing priority inversion caused latencies
caused by contention on pmsg_lock, and suggested it be switched
to a rt_mutex.

I was initially hesitant this would help, as the tasks in that
trace all seemed to be SCHED_NORMAL, so the benefit would be
limited to only nice boosting.

However, another similar issue was raised where the priority
inversion was seen did involve a blocked RT task so it is clear
this would be helpful in that case.

Cc: Wei Wang <wvw@google.com>
Cc: Midas Chien<midaschieh@google.com>
Cc: Connor O'Brien <connoro@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: kernel-team@android.com
Fixes: 9d5438f462ab ("pstore: Add pmsg - user-space accessible pstore object")
Reported-by: Wei Wang <wvw@google.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221214231834.3711880-1-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/pmsg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/pmsg.c b/fs/pstore/pmsg.c
index d8542ec2f38c..18cf94b597e0 100644
--- a/fs/pstore/pmsg.c
+++ b/fs/pstore/pmsg.c
@@ -7,9 +7,10 @@
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/rtmutex.h>
 #include "internal.h"
 
-static DEFINE_MUTEX(pmsg_lock);
+static DEFINE_RT_MUTEX(pmsg_lock);
 
 static ssize_t write_pmsg(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
@@ -28,9 +29,9 @@ static ssize_t write_pmsg(struct file *file, const char __user *buf,
 	if (!access_ok(buf, count))
 		return -EFAULT;
 
-	mutex_lock(&pmsg_lock);
+	rt_mutex_lock(&pmsg_lock);
 	ret = psinfo->write_user(&record, buf);
-	mutex_unlock(&pmsg_lock);
+	rt_mutex_unlock(&pmsg_lock);
 	return ret ? ret : count;
 }
 
-- 
2.35.1



