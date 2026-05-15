Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB31C39B971;
	Fri, 15 May 2026 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860996; cv=none; b=C/KD3ElXaaMWRfZB2RHO+/gp9hnDFF2MID/wXGVSANPEt1mhCBqvpdBG4Zss5yf7YSSOznmkjSLbQFT2b/36gUAPQxVdJnUjqKgg57HFtM+I1jtk1/pxOORGd9K8gpTQBj3AzWpQQ9r1CogmVMSVHjfi5TBsL6KVwoQDhe1DTpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860996; c=relaxed/simple;
	bh=nkVj8h8TX4OyOsqXpItAGAT6X99SbXG7zfeykacWsvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFrzCtAb7LF/jnd+KW2G2q80Wt7Zd29ANDaoZ9fRJqWu/tSlXgTQ52rCengrXz8fRkwMZaIcKskTGeNNPpRZkIfRXB7iQTYoE9YrPMs4faRQuvrZFoZzf6kXv8xfb+ftIiZM/otVDw7cc3UelcZdKGs5+rTJYQWxwDn25jrupI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CktbtoVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CktbtoVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F337C2BCB0;
	Fri, 15 May 2026 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860996;
	bh=nkVj8h8TX4OyOsqXpItAGAT6X99SbXG7zfeykacWsvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CktbtoVVKmDBpyJwInP4dAdkKalNBZRWzB1RysROwbXGU3+cB7+FIVDiL91WNv+9X
	 wyCryQWdGugHtMU8uSztFQr0OoeCMOs9Au8BehpklD03sM5EpmktFxUwB17sTk02JO
	 pMfHuw8jiJs+JrlruY+erRqVn0g3Jh/1WLo1U0Oo=
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
Subject: [PATCH 6.6 117/474] taskstats: set version in TGID exit notifications
Date: Fri, 15 May 2026 17:43:46 +0200
Message-ID: <20260515154717.569562923@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


