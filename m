Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F262EBB8D;
	Tue, 21 Jul 2026 20:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666110; cv=none; b=PBi5xnxN0VmvQVeCPj0/GpiodtW6ycRW0I+n0Dn2xAb41BItyOAQ+MlpK9yh/E0rcfoLHYp0WZwbHSQLNQiAZvnif0LbNunU0irHW2RnvRsVEdbK/fMr/IGqCLPxVS7qHSLwBQwwrX2T4du54lHii/tT4qybmPPsM/0EtXzs/jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666110; c=relaxed/simple;
	bh=ivTOPiflcGBwYswXF7FJpYyGjCc2feruW46ATuaKCDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u64q1x2/Ri60Uzv4+tq/jM2fYJEScR4DNsjjLaPK0Yh99CCpjIVQ89wwrWvWGdHn60YM8cEGKX8NF2krASbwRdhWQa8uBlH1/fQf2KaFVntnP+J4dNR9rx+rhBJYyR8uVnVIGz3zl9qDMhXfb9UH5mzZmfsQXyPnstu9W/SEhQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRu9bldS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRu9bldS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CDA1F000E9;
	Tue, 21 Jul 2026 20:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666108;
	bh=pciLcrodaKUz47WICGcFm66hi5x48V4LT9lVg+7H0xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRu9bldSv+8Dn9TQVL4Gx1RlVJTGOyBnpCgWHnbdEAAIVmkgr0cD6fTAffTIhLQ+O
	 PRYxheLLCkwRkDpdnZ5fkgC+15oA84V4+1Uthj9dTgl8MXtQ/sDaU5ctWuaurNl73u
	 A8fPiGSIAiWDDNxCWNtrXIHSgwx1Nz6FYH1+0TJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0551/1266] Bluetooth: vhci: validate devcoredump state before side effects
Date: Tue, 21 Jul 2026 17:16:28 +0200
Message-ID: <20260721152454.195499166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit 88c2404a3c59c3126453919388dbd5ed98ed01bd ]

The VHCI force_devcoredump debugfs hook accepts a small test record from
userspace. It validates the requested terminal state only after
registering, initializing and appending a Bluetooth devcoredump.

As a result, an invalid state returns -EINVAL but still leaves queued
devcoredump work behind. With a non-zero timeout field, the rejected
write can still emit a devcoredump after the timeout expires.

Reject unsupported states before allocating the skb or changing the HCI
devcoredump state machine.

Fixes: ab4e4380d4e1 ("Bluetooth: Add vhci devcoredump support")
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_vhci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 0935045051699f..c0588fe110a2d4 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -337,7 +337,17 @@ static ssize_t force_devcd_write(struct file *file, const char __user *user_buf,
 	if (copy_from_user(&dump_data, user_buf, count))
 		return -EFAULT;
 
+	switch (dump_data.state) {
+	case HCI_DEVCOREDUMP_DONE:
+	case HCI_DEVCOREDUMP_ABORT:
+	case HCI_DEVCOREDUMP_TIMEOUT:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	data_size = count - offsetof(struct devcoredump_test_data, data);
+
 	skb = alloc_skb(data_size, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
-- 
2.53.0



