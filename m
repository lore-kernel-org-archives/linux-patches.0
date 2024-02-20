Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1358E446C9;
	Tue, 20 Feb 2024 21:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465035; cv=none; b=oOT7QRwPqkuSVZJyx/VB6FgV8ojp1YtuqpZbow4Q43TlDuAMgt2+MpNDxG7OpvLfTn8DnCeqm6OsCGodQ8j/glPJlc1L0gZ+IzwVOqbXQgTaHhdmMJMFUqinGpAqCxYzQyRSSAl9wok7orqQh+hWCJiZ2Wxw5l6RvcdxAorHBZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465035; c=relaxed/simple;
	bh=yQuMN+X1pnPhDItFXMkAl8jY8ew4Sa8bb9ukPQdu3nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyU6aY/vyc2jbpy0X2v8tVLiZmkeAbZjUnvyKjoRg97a+UFUW09QeGiq2OCB4N15DvUYuPz6cY0TUrNu8u5vXHUdZ31JbXm2PgGPZUcqOKTq+7eSiu2LW4EMlsq5dUwRfvI9iQZJ/mE5PAyYB+QeQKrl/TK/evCgH0mq+iMGATc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkq/CUUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkq/CUUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C14FC433C7;
	Tue, 20 Feb 2024 21:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465034;
	bh=yQuMN+X1pnPhDItFXMkAl8jY8ew4Sa8bb9ukPQdu3nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkq/CUUXqM8Kv+bc8wGxZHN1LQuhiNJiBZMUQSi4mpNMym0hwNJebPUYIH+s632T1
	 Mxer/gp1gE7uGhEskMFSI7uocFYX8XfPPCxZHOe++Ggb3muh9b7aG2NxRRXPBDZ6ke
	 /nhD7MdqWJR9xptyDQNqhNFvKFzYGcrzxvWXFjEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 215/309] hv_netvsc: Fix race condition between netvsc_probe and netvsc_remove
Date: Tue, 20 Feb 2024 21:56:14 +0100
Message-ID: <20240220205639.898723082@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -708,7 +708,10 @@ void netvsc_device_remove(struct hv_devi
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
 


