Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A9746F48E;
	Tue, 21 Jul 2026 17:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656778; cv=none; b=eBGD9tk8n0Z0f1oDDQ40bEt6kyB7TzdJFyQpGwITU5iTg47E49JF1F8M6J0IWt48LeOCAh3t3gBz+jTqF1aBN/VyaXhJqNBN1M9vet21mRvn9PVati3795rXJUEtCqNjyIhQq6XXPotoN2fjmddJXzkM2tXrxLA1iJ450m0Sx58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656778; c=relaxed/simple;
	bh=C92UV7XKTs4vmSBNeL+M8NSDl35bGH1IqKwSywGsG7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw+FMBrsvfdrVY44KL2M6MJiJdpUFc16p3mN3km+2kaE8fUg3mAnbhYI/v0v6VyU/s4rhVyo0wd5NyojZv+T/iiubIWeaas1MSpC73gTOwqM5R60nppqKvQip574/iQMl/xvthfcu8qgGbZKKgayhA9RoJF7IfMNSbMjSRCfxeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVHYM4+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVHYM4+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1231F000E9;
	Tue, 21 Jul 2026 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656776;
	bh=gCEkzPeUtM3eL+VXPgNEcnXhC5M4l1sSQp8kpNJIpOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVHYM4+rY4gBF4N5+2AHwEv6ZfeLIHhlZm0YFlSsjMXO/5D+HJ402lXCphUjvdgP+
	 37GYOh3XgdmWhZ+4EmhC2IQ36YGHtUfOlUEOmPvI4oVy7Wv+kdSq1mhSKQqYafAAXa
	 hgteRcRGBeR9gQlRFCR2V/i/QJ/eqvEwCJ/4/9is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0471/1611] Bluetooth: vhci: validate devcoredump state before side effects
Date: Tue, 21 Jul 2026 17:09:47 +0200
Message-ID: <20260721152525.916641631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2fef08254d78d9..22edae35580804 100644
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



