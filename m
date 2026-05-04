Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7E43E51D8;
	Mon,  4 May 2026 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904718; cv=none; b=P/DJwTGbCN5F/tMJ+wjGQt10igOXxCkLEL0lSxx3AvZf3W4vu/So79RAYYbKcBEW0iBO0eKFhwe0rtOb0jYRDPMZq7jJwFtYPmAyndCUVKtxHfOtCMdVYtrkXUh7vHquIJjfFhlW7mCFMrbAL0d66GgxLKJKCjWRf+lIsHFnk8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904718; c=relaxed/simple;
	bh=qpQiNoRii1k7uZl9GxaAUxqMc0+DlVucDhYH+I9dlD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhNm6uJq9DNXP7wT1WOF077aLlmHDgoaQiie0JGHBuFb4hckmvKifeGk3jlzEX/1PBSjUpFr0Y84MZ3KLepjz52HsMH56cHq+w0OgOeQR8jdfmwROHFbQG5Xtfa3YcXHTIh0JL0aVrC0NOeGR9+a55nRZCwp8z92ta6CIkyVzBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgQZObgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgQZObgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AEBC2BCB8;
	Mon,  4 May 2026 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904718;
	bh=qpQiNoRii1k7uZl9GxaAUxqMc0+DlVucDhYH+I9dlD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgQZObgdUSYNUMtgriDYtdAGJTeg/yBYQYOLrkU/1zICvgjSzSQ51uANTnuMy+4OE
	 IQGzzMR3WDY+Ey328fLYXBLuq+kGpw7+DdIFoWGIjMjv+lH5fxI5fr2VdvEpKE4sP/
	 DRzu8OrS9eAqUVec4vQ6bJmv0Ygu45pNJuwvIgmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <cyyzero16@gmail.com>,
	Balbir Singh <bsingharora@gmail.com>,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>,
	Fan Yu <fan.yu9@zte.com.cn>,
	Wang Yaxin <wang.yaxin@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 148/215] taskstats: set version in TGID exit notifications
Date: Mon,  4 May 2026 15:52:47 +0200
Message-ID: <20260504135135.573202858@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <cyyzero16@gmail.com>

commit 16c4f0211aaa1ec1422b11b59f64f1abe9009fc0 upstream.

delay accounting started populating taskstats records with a valid version
field via fill_pid() and fill_tgid().

Later, commit ad4ecbcba728 ("[PATCH] delay accounting taskstats interface
send tgid once") changed the TGID exit path to send the cached
signal->stats aggregate directly instead of building the outgoing record
through fill_tgid().  Unlike fill_tgid(), fill_tgid_exit() only
accumulates accounting data and never initializes stats->version.

As a result, TGID exit notifications can reach userspace with version == 0
even though PID exit notifications and TASKSTATS_CMD_GET replies carry a
valid taskstats version.

This is easy to reproduce with `tools/accounting/getdelays.c`.

I have a small follow-up patch for that tool which:

1. increases the receive buffer/message size so the pid+tgid
   combined exit notification is not dropped/truncated

2. prints `stats->version`.

With that patch, the reproducer is:

  Terminal 1:
    ./getdelays -d -v -l -m 0

  Terminal 2:
    taskset -c 0 python3 -c 'import threading,time; t=threading.Thread(target=time.sleep,args=(0.1,)); t.start(); t.join()'

That produces both PID and TGID exit notifications for the same
process.  The PID exit record reports a valid taskstats version, while
the TGID exit record reports `version 0`.


This patch (of 2):

Set stats->version = TASKSTATS_VERSION after copying the cached TGID
aggregate into the outgoing netlink payload so all taskstats records are
self-describing again.

Link: https://lkml.kernel.org/r/ba83d934e59edd431b693607de573eb9ca059309.1774810498.git.cyyzero16@gmail.com
Fixes: ad4ecbcba728 ("[PATCH] delay accounting taskstats interface send tgid once")
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/taskstats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -655,6 +655,7 @@ void taskstats_exit(struct task_struct *
 		goto err;
 
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	stats->version = TASKSTATS_VERSION;
 
 send:
 	send_cpu_listeners(rep_skb, listeners);


