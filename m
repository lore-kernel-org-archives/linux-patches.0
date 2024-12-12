Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FF721660B;
	Thu, 12 Dec 2024 16:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022773; cv=none; b=ZsmmpIp5MjDpPX3TYDsUj1bsFUI+/w7JdTmDNrn6JBJf1aHY7plpdKrzStX9jn3Y+sDi2hcTdlDGBInRWRPviWqWPPbR5yRcpxM4U+C036CUhnIBzFII/Td+A7dl5nbnIJ5p1tF8CxE+cOBzl42N7ULtGFZUl+HR31znaqEKvCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022773; c=relaxed/simple;
	bh=t8n1ElJMAIs8dVZOaUQ7AJeFdOs/sCjli2b9bnOj5gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9iknU1zA2iX6bl6KLHhEc/H9YtLgVrEZWqafnpCnLQDs/KslQ3eq4GN+JulbRpH+Wkprs3hzq72umkgRjBnKDH8gDnwjkpKJ1iycOlU0PnGDlyMzwCrsnjnqrz24RY0yi3Re4RB3gIAFZ20NbS4sxlR3WF4CBbq5EqLQ25Kom8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0KsoJAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0KsoJAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAF6C4CECE;
	Thu, 12 Dec 2024 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022772;
	bh=t8n1ElJMAIs8dVZOaUQ7AJeFdOs/sCjli2b9bnOj5gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0KsoJAxtKEKps3NSLk4NtSsXo3uPD4rYeWf3OgVyTMnSMd0ZBbN8ubI0q9aRv4zF
	 vGWaKOiQtGG7avyFAVH68bENlY8oQLa8RxY3RxNvB9k1eR+2J76wwHL2p9TP3HJ8SI
	 njWOJADwmf6MzTUrUpg+8SKw2shAOrlCEKSWzGkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 333/565] um: net: Do not use drvdata in release
Date: Thu, 12 Dec 2024 15:58:48 +0100
Message-ID: <20241212144324.757846197@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

commit d1db692a9be3b4bd3473b64fcae996afaffe8438 upstream.

The drvdata is not available in release. Let's just use container_of()
to get the uml_net instance. Otherwise, removing a network device will
result in a crash:

RIP: 0033:net_device_release+0x10/0x6f
RSP: 00000000e20c7c40  EFLAGS: 00010206
RAX: 000000006002e4e7 RBX: 00000000600f1baf RCX: 00000000624074e0
RDX: 0000000062778000 RSI: 0000000060551c80 RDI: 00000000627af028
RBP: 00000000e20c7c50 R08: 00000000603ad594 R09: 00000000e20c7b70
R10: 000000000000135a R11: 00000000603ad422 R12: 0000000000000000
R13: 0000000062c7af00 R14: 0000000062406d60 R15: 00000000627700b6
Kernel panic - not syncing: Segfault with no mm
CPU: 0 UID: 0 PID: 29 Comm: kworker/0:2 Not tainted 6.12.0-rc6-g59b723cd2adb #1
Workqueue: events mc_work_proc
Stack:
 627af028 62c7af00 e20c7c80 60276fcd
 62778000 603f5820 627af028 00000000
 e20c7cb0 603a2bcd 627af000 62770010
Call Trace:
 [<60276fcd>] device_release+0x70/0xba
 [<603a2bcd>] kobject_put+0xba/0xe7
 [<60277265>] put_device+0x19/0x1c
 [<60281266>] platform_device_put+0x26/0x29
 [<60281e5f>] platform_device_unregister+0x2c/0x2e
 [<6002ec9c>] net_remove+0x63/0x69
 [<60031316>] ? mconsole_reply+0x0/0x50
 [<600310c8>] mconsole_remove+0x160/0x1cc
 [<60087d40>] ? __remove_hrtimer+0x38/0x74
 [<60087ff8>] ? hrtimer_try_to_cancel+0x8c/0x98
 [<6006b3cf>] ? dl_server_stop+0x3f/0x48
 [<6006b390>] ? dl_server_stop+0x0/0x48
 [<600672e8>] ? dequeue_entities+0x327/0x390
 [<60038fa6>] ? um_set_signals+0x0/0x43
 [<6003070c>] mc_work_proc+0x77/0x91
 [<60057664>] process_scheduled_works+0x1b3/0x2dd
 [<60055f32>] ? assign_work+0x0/0x58
 [<60057f0a>] worker_thread+0x1e9/0x293
 [<6005406f>] ? set_pf_worker+0x0/0x64
 [<6005d65d>] ? arch_local_irq_save+0x0/0x2d
 [<6005d748>] ? kthread_exit+0x0/0x3a
 [<60057d21>] ? worker_thread+0x0/0x293
 [<6005dbf1>] kthread+0x126/0x12b
 [<600219c5>] new_thread_handler+0x85/0xb6

Cc: stable@vger.kernel.org
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://patch.msgid.link/20241104163203.435515-4-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/net_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -335,7 +335,7 @@ static struct platform_driver uml_net_dr
 
 static void net_device_release(struct device *dev)
 {
-	struct uml_net *device = dev_get_drvdata(dev);
+	struct uml_net *device = container_of(dev, struct uml_net, pdev.dev);
 	struct net_device *netdev = device->dev;
 	struct uml_net_private *lp = netdev_priv(netdev);
 


