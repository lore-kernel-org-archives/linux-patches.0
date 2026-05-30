Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A186A33F5A3;
	Sat, 30 May 2026 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160128; cv=none; b=GYM3X06azAf+jGQNKO3K5tOQogYap9dM1TYaFR4x1jVvZoH2yUT2BduMl7TIUYWhjAsZUGTB9teVl9KZO8BuT4SB6C4XEcybiNmoZHsRnVj3qmqRAdIWF/Cho7PZYxiawNKDi84hiYVXM4TLWjXVzcERi5f85dV0wTr82D14t1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160128; c=relaxed/simple;
	bh=ibsf9Eo6uBrY3uMjb4hOUysJwNPfPgwgoqJCnOcR9bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAsjOvYaP2ueiBXdcULoGDeo2DkgIHt3iBWc6rmvgYRpYXzaaoaYiUbN+i0d7net8OKVcObVrzRuvPHbKEVtK/VpnR/XZ2t8PBT+AB2bRRHKgtSSvdXx6Ia/dE9ZalFNAZTKAysBcr4q8IbvSHnagAUWGLpWyO+FFTFt/cAeigM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlMgKWLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlMgKWLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DE11F00893;
	Sat, 30 May 2026 16:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160127;
	bh=CvcmLLx8aWGPFGJSbnqE4y4GvSbybhazEoIoP7MC66s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlMgKWLlj30xXqturhjyn5UzgSCsW7gqzPLQGmjjxOdBD9/hv0tbqdMLoSorgTfmy
	 EDw8FEXWxh/+vRcmm0rHP7PA5BtbksXjzeVmvaWtnAGocBHDfQ4n5jLFJJVpc6M73/
	 qpaW0gzH594Lp+xW/KBY2UjF3tI/08j6+7/hQFdw=
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
Subject: [PATCH 6.1 252/969] taskstats: set version in TGID exit notifications
Date: Sat, 30 May 2026 17:56:16 +0200
Message-ID: <20260530160307.429544782@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -656,6 +656,7 @@ void taskstats_exit(struct task_struct *
 		goto err;
 
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	stats->version = TASKSTATS_VERSION;
 
 send:
 	send_cpu_listeners(rep_skb, listeners);


