Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09237C6C0;
	Wed, 21 Feb 2024 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523308; cv=none; b=Smw4JjyiR8vkzv52PHdPgp6R2T0Jm7oEbJVpV2e7m31w1XhOWW818oji2xwSfmJl0a88MeCwEFSZLJYKnwqqwP/tfBU+SARxQgAcRDQpZsMKA4mFGRdwrclXzthKEjXzxZ+ZCl/xYldbyOmVMy8+hfxs5vogdMpzsIkT28pjvdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523308; c=relaxed/simple;
	bh=9IF4iJRYqfHKQog7vr82gakksuLvDBsK5vzKEVovQwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ny1udbeL7/gzUdEzl3ELZcuZRdEfQB/dJiA4sl3zXZiqOjvPGr30CS//5TsCA0DRgY1Dhxo0nOX2gwLNMmy5v9I8ETjkAwcwj0aIRrxe6lqrRQIGJyuDNtiYsgPWJa31nOMtk6dZ3UDM2rbzYchfB1JUtrDtFHognClsGkjz2Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVKqN9Gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVKqN9Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102ADC433F1;
	Wed, 21 Feb 2024 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523308;
	bh=9IF4iJRYqfHKQog7vr82gakksuLvDBsK5vzKEVovQwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVKqN9GncOn5ruR06S+lEnjJBhnQ2fqp3VdLwZTssUa8jqVzsy4E8nro/LZ3ChwD/
	 fcE6kjFsilRgkH5UwjPuQKiwdzG9kNFYGlhKKUc7XufFbOrAFWJY9BoF6k6bmjF2B9
	 HJwo9LFBLKP0bfdFiW0iTDADQwQFEdOvMdDIMpJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 397/476] hv_netvsc: Fix race condition between netvsc_probe and netvsc_remove
Date: Wed, 21 Feb 2024 14:07:28 +0100
Message-ID: <20240221130022.684092763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>

commit e0526ec5360a48ad3ab2e26e802b0532302a7e11 upstream.

In commit ac5047671758 ("hv_netvsc: Disable NAPI before closing the
VMBus channel"), napi_disable was getting called for all channels,
including all subchannels without confirming if they are enabled or not.

This caused hv_netvsc getting hung at napi_disable, when netvsc_probe()
has finished running but nvdev->subchan_work has not started yet.
netvsc_subchan_work() -> rndis_set_subchannel() has not created the
sub-channels and because of that netvsc_sc_open() is not running.
netvsc_remove() calls cancel_work_sync(&nvdev->subchan_work), for which
netvsc_subchan_work did not run.

netif_napi_add() sets the bit NAPI_STATE_SCHED because it ensures NAPI
cannot be scheduled. Then netvsc_sc_open() -> napi_enable will clear the
NAPIF_STATE_SCHED bit, so it can be scheduled. napi_disable() does the
opposite.

Now during netvsc_device_remove(), when napi_disable is called for those
subchannels, napi_disable gets stuck on infinite msleep.

This fix addresses this problem by ensuring that napi_disable() is not
getting called for non-enabled NAPI struct.
But netif_napi_del() is still necessary for these non-enabled NAPI struct
for cleanup purpose.

Call trace:
[  654.559417] task:modprobe        state:D stack:    0 pid: 2321 ppid:  1091 flags:0x00004002
[  654.568030] Call Trace:
[  654.571221]  <TASK>
[  654.573790]  __schedule+0x2d6/0x960
[  654.577733]  schedule+0x69/0xf0
[  654.581214]  schedule_timeout+0x87/0x140
[  654.585463]  ? __bpf_trace_tick_stop+0x20/0x20
[  654.590291]  msleep+0x2d/0x40
[  654.593625]  napi_disable+0x2b/0x80
[  654.597437]  netvsc_device_remove+0x8a/0x1f0 [hv_netvsc]
[  654.603935]  rndis_filter_device_remove+0x194/0x1c0 [hv_netvsc]
[  654.611101]  ? do_wait_intr+0xb0/0xb0
[  654.615753]  netvsc_remove+0x7c/0x120 [hv_netvsc]
[  654.621675]  vmbus_remove+0x27/0x40 [hv_vmbus]

Cc: stable@vger.kernel.org
Fixes: ac5047671758 ("hv_netvsc: Disable NAPI before closing the VMBus channel")
Signed-off-by: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/1706686551-28510-1-git-send-email-schakrabarti@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -710,7 +710,10 @@ void netvsc_device_remove(struct hv_devi
 	/* Disable NAPI and disassociate its context from the device. */
 	for (i = 0; i < net_device->num_chn; i++) {
 		/* See also vmbus_reset_channel_cb(). */
-		napi_disable(&net_device->chan_table[i].napi);
+		/* only disable enabled NAPI channel */
+		if (i < ndev->real_num_rx_queues)
+			napi_disable(&net_device->chan_table[i].napi);
+
 		netif_napi_del(&net_device->chan_table[i].napi);
 	}
 


