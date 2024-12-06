Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E51145A16;
	Fri,  6 Dec 2024 15:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498235; cv=none; b=k/6nbdTb/2e7KOLgo5hR6OI1Rq+E9mZo0wvT9RWjfE8eNpILdAo0x2YVB9Hj+U5SjX+oY+D6qzpwPfwRrvcpRI6gdqMpnm3uVsVfdRCKF8CD0lu5ifdzTB6MlOYJesyJrnPBDN52X0eZzycKTvabKb68ac70D357U1VTR035SoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498235; c=relaxed/simple;
	bh=BpYK+0CX8V0WnBn/5TzWbeMMfm7iV+06IITanUU4TYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6FQ+XfeOyz+0502RVINZvzlgUBCbVJjGQSrHpNdncifPeRPoyOTMsf2wH1uoi3qpO9NEIWqiKjlcW+uS6+PxXWt8h7/N2bAqQCTzSLqYWbGpEGtOwmNLOP3d5ojrwfaZ8w8LintWxSOkK44GD1DyNlUVhZRNJEI2cdPjGj+hfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzVHd8ML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzVHd8ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66854C4CED1;
	Fri,  6 Dec 2024 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498234;
	bh=BpYK+0CX8V0WnBn/5TzWbeMMfm7iV+06IITanUU4TYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzVHd8MLiLf3B+uPNeAdT+g2WUb++cmENczs2npB9pN7BrUsjYwuS1zxraPjY5226
	 Zi8eQkmgmNY0/EO8Rh9gFQgNcNd5XLBMLv0Yt+2o89PJzXZ8BHMCwqMmu02DcBJK1A
	 lx6Z6cbFnxvCV7C+X+QeMdUEizTEYKZFD87wx5qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 517/676] um: net: Do not use drvdata in release
Date: Fri,  6 Dec 2024 15:35:36 +0100
Message-ID: <20241206143713.556609179@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -336,7 +336,7 @@ static struct platform_driver uml_net_dr
 
 static void net_device_release(struct device *dev)
 {
-	struct uml_net *device = dev_get_drvdata(dev);
+	struct uml_net *device = container_of(dev, struct uml_net, pdev.dev);
 	struct net_device *netdev = device->dev;
 	struct uml_net_private *lp = netdev_priv(netdev);
 


