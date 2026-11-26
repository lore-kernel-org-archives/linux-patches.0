Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705458;
	b=Nf4MwMNwpmMzKbkE+j5Y2MoHDlhQeitRHZ/p7/Oz2qKuNQbLQ1yeOSpeIdEyKe6vaLR6
	 TNubou4XvVJmUEjrZtb8ulyVu6MAnqiAvEr92RsWsQcZztoq1hfSzNiu0qe+d8mItOojK
	 ImLJT9Hn+kA6kCJ1L/PgS1xccuvSA9MtgYju17xQohFQGM7dkTmVdS0+BP5fSAmi/1CyT
	 hG24yraGS33iIFXOlZpsPAcpTffeDS1WqeNJumC2wldORqoYdpbRKOAYOAlpmYksU9eQi
	 ZizE0x3LYFffGhEDzRpauAh2gsa4MUvEz1XzbrO/hQNek0ExczmeQkge/yHTBkWz4Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PJUQrBcI/kMlq8uYvXtL54mf3miJoOFvowkg/nkNo5E=;
	b=Txjq4z+fyTjVM1CfxSL/+1bwO+DP+YWdBlXF5X+7JOpRbNctt/jcg9EAuHJdrIZ574Po
	 oylk0rISikbcyNP8Fowjx0XNH8HCD3OsHwzfj4WlSeIgJ6yrvg/tJnyqTowqAykISPmu3
	 0a1OzTjqCwDp9NGq4EMQLQ6djrEB8w2DEnspsusANnL1NDupzj3WAkDFLeQOtHKgI61t1
	 qQfHPVpNqGFwUpqekpkyMWGsP9ABKl7VTXaYAgQRG07B3KueYJzM06VbmSnyDpCgsjEx1
	 mGWwCtpM2SIGfQoCLEFOG8K2KPy/dbAFvTM980uS67jr1meGl8gtiZ8Pkg5r6DeuLqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mve6BxcM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2D6606A31C;
	Thu, 26 Nov 2026 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mve6BxcM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851101F000C0;
	Thu, 26 Nov 2026 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705458;
	bh=PJUQrBcI/kMlq8uYvXtL54mf3miJoOFvowkg/nkNo5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mve6BxcMtiy2Sgwiq5kGmSkTYUJa9VJrlS5LFSXOUbqocMsh3TNG50t/jUoHumib8
	 jBpd6QH4x3wXkA9eaCGIuNsQPNjaI63enSkADN4OnngZLdtyuqIMVDYkfFVyTb/JqB
	 Y6GzoYi8u+3mjC9+3cBQEh3wrasTyoBNs/nlNZu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 204/319] Bluetooth: hci_qca: fix use-after-free in ibs debugfs files
Date: Thu, 26 Nov 2026 15:39:32 +0100
Message-ID: <20261126144011.350191057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit eeca795cec6d9c6c193c2c1bd0cb26cde44f9fc3 upstream.

qca_debugfs_init() creates an "ibs" directory under hdev->debugfs and
stores pointers to fields of struct qca_data in the debugfs files.
qca_close() frees qca_data without removing that directory, while
hdev->debugfs is only removed when the HCI device is released. The HCI
device can outlive the driver data, for example when an HCI socket still
references it, so reading or writing one of the ibs files then
dereferences freed memory.

Store the directory dentry in struct qca_data and remove the directory
with debugfs_remove_recursive() before qca_data is freed.
debugfs_remove() waits for callers that are already inside the file
operations, and any later access fails with -EIO instead of reaching the
debugfs helpers. This covers the two writable files as well.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261102113654.8724-1-25031212351%40stu.xidian.edu.cn
Fixes: 0ff252c1976d ("Bluetooth: hciuart: Add support QCA chipset for UART")
Cc: stable@vger.kernel.org
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -161,6 +161,7 @@ struct qca_data {
 	struct delayed_work ctrl_memdump_timeout;
 	struct qca_memdump_data *qca_memdump;
 	unsigned long flags;
+	struct dentry *debugfs_ibs_dir;
 	struct completion drop_ev_comp;
 	wait_queue_head_t suspend_wait_q;
 	enum qca_memdump_states memdump_state;
@@ -648,6 +649,7 @@ static void qca_debugfs_init(struct hci_
 		return;
 
 	ibs_dir = debugfs_create_dir("ibs", hdev->debugfs);
+	qca->debugfs_ibs_dir = ibs_dir;
 
 	/* read only */
 	mode = 0444;
@@ -723,6 +725,9 @@ static int qca_close(struct hci_uart *hu
 
 	hu->priv = NULL;
 
+	debugfs_remove_recursive(qca->debugfs_ibs_dir);
+	qca->debugfs_ibs_dir = NULL;
+
 	kfree(qca);
 
 	return 0;


