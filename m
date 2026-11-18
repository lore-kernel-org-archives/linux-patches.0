Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041766;
	b=AbewwkoIT3eYi9T5qT8dIs2G5VuaMj38zm5kqfBqEAmFnto7HgAvMoqqvpm8dMrd5Smz
	 ZUCXHfm5tH1NU1t7927e+Ryu/I63x57PMAaROTCfpBKRfayWWf/g5APyRsFlr/zm1LAUQ
	 5vmfmtDjnz82l0XJplm5WxGmYmIab2JJVvaW6MN62w7Ff/gbTdbr9lJ0K9Ry/O7UyfEGG
	 eNOWYU90jXfOnnOWccd+zEMcgAbi2aYuuL3OINjwT0zM2ctGJaX488nK62ToXIeUcklvt
	 mwz0Um/JzRsTAgsEWALEkoAbKkSHHM1F2f89dLSxl+fDn/K7HHzjng6br0g9D1m7G/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QwyodEtAbK6hEes0ymHMosOuZZXAQ9eus2rI/BaNDxQ=;
	b=Xwusd2J/vjGYs3zn7SGcOfYIIB4zilrUHQXwcsEMQwl9lXWEpxlYp8DSsAv5adYBwyYn
	 bAk4+pD3PqwbcJAWXo0LmNpGbhCFJomD5D9YlZICKjaQYS3r8bGCiJCq5wUkaP0eDggAq
	 2oXEoZlVKqQ/Re0KgMeyIRlGCMVU+sfGmrEeD388k1okyC0ucTdpzY7QWQ7LY91oIA1g4
	 P0GIyqBn8yqAUeCsjYMFYS99P3wCiWN1jTYk3NQEzStN7aJW261rLd3bMQEvjDG/imXP5
	 2K/7rtRXj+EFkuY22VWvMVdD/oU99rzYSatff0g0nXff1VY87MTFzUBg7AN7sVQsEOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lP1hB9hP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EFD606A31C;
	Wed, 18 Nov 2026 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lP1hB9hP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18081F000C4;
	Wed, 18 Nov 2026 22:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041766;
	bh=QwyodEtAbK6hEes0ymHMosOuZZXAQ9eus2rI/BaNDxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lP1hB9hPGl/qNZDTWjRmlUYfv8JQDKz6Mvt59cf3+D677P/ZSCP7H6sILLvGWjHAl
	 saxgLhd1Gg2xZK4NU4W7TYTbPSj4+mN8o3egAG9PdIsw0G39mqsJZ6wo6ISP2pXNSv
	 YbY1Ize5kCvSMO0wjBdsxQ0ldlli3vtbmfagWHhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2894/3318] Bluetooth: MSFT: Serialize handle map cleanup with event processing
Date: Wed, 18 Nov 2026 15:58:36 +0100
Message-ID: <20261118150447.319490913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 56e20c3d8ad340bbfc90221c4aae1c870485fb57 ]

MSFT monitor handle mappings must remain valid while vendor events look
up and use them under hdev->lock. msft_do_close() removes and frees the
mappings without that lock.

hci_dev_close_sync() clears HCI_UP and drains the RX workqueue before
MSFT cleanup. However, a transport callback that already passed
hci_recv_frame()'s state check can queue a vendor event after the drain
returns, if no earlier shutdown callback has quiesced reception. The
driver close callback runs after MSFT cleanup, so event processing can
overlap the unlocked removal. msft_monitor_device_evt() can then
traverse freed list entries or read handle_data->mgmt_handle after it is
freed.

Take hdev->lock while resetting monitor states and removing handle
mappings in msft_do_close(), as normal monitor cancellation already
does. An active event reader then finishes before its mapping is freed,
and later lookups see an empty handle map.

An instrumented kernel produced this KASAN report (timestamps removed
and unrelated frames omitted):

    BUG: KASAN: slab-use-after-free in msft_vendor_evt+0x1906/0x1990
    Read of size 2 at addr ffff888104df3602 by task kworker/u17:2/502

    Workqueue: hci0 hci_rx_work
    Call Trace:
      [...]
      msft_vendor_evt+0x1906/0x1990
      hci_vendor_evt+0x6f/0x90
      hci_event_packet+0x894/0xc70
      [...]
      hci_rx_work+0x3f8/0xfa0
      [...]

    Allocated by task 499:
      [...]
      msft_add_monitor_sync+0x6a8/0x10a0
      msft_add_monitor_pattern+0x7f/0xb0
      hci_add_adv_monitor+0x1fa/0x2e0
      [...]

    Freed by task 499:
      [...]
      kfree+0x307/0x580
      msft_do_close+0x238/0x750
      hci_dev_close_sync+0x546/0x1380
      [...]

    The buggy address belongs to the object at ffff888104df3600
      which belongs to the cache kmalloc-32 of size 32
    The buggy address is located 2 bytes inside of
      freed 32-byte region [ffff888104df3600, ffff888104df3620)
    [...]

Fixes: 145373cb1b1f ("Bluetooth: Add framework for Microsoft vendor extension")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/msft.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index a5199797b4256..7e8f0b13aba67 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -684,6 +684,8 @@ void msft_do_close(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "Cleanup of MSFT extension");
 
+	hci_dev_lock(hdev);
+
 	/* The controller will silently remove all monitors on power off.
 	 * Therefore, remove handle_data mapping and reset monitor state.
 	 */
@@ -698,6 +700,8 @@ void msft_do_close(struct hci_dev *hdev)
 		kfree(handle_data);
 	}
 
+	hci_dev_unlock(hdev);
+
 	mutex_lock(&msft->filter_lock);
 	list_for_each_entry_safe(address_filter, n, &msft->address_filters,
 				 list) {
-- 
2.53.0



