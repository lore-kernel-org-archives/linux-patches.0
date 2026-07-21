Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CC246A60E;
	Tue, 21 Jul 2026 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662189; cv=none; b=Ef5zo+Lnsir/ICosAVQgr4gV6MHA8lMU5uMZeGlXadKuDIw5Sk4bEaM9tUmTJsUfoHUT3pxRk1tK+lP1x3RSRhu2MfVZzwUte1qiDllwboRYHx1QybiibKA4qCr18uzoI5MsKjoOzPKvk3plmJo3WCksbq++eIkzxT672CSc/Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662189; c=relaxed/simple;
	bh=E/gtnYP1+FA0+rG9r2pQPe5wRdphsinFss9YAKVNKG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJTnc/AW52Y9VtV3m8FuYgOiuxipIafe2Q9HVrjmD4zC7xYa4b5cxCsiWgMXVqZLDcAir2dbA9qmEchXkqMFvV+GznmT9hQSwG2Y5xGCymewt0qIE9PbpkTNCyp/hh6N/xeJ2Y2a7ZsduCpGJ6QzVsw2jTPI0E7U+YhKQCas+Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuVmIE7P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuVmIE7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF101F000E9;
	Tue, 21 Jul 2026 19:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662187;
	bh=i7lgOlmfmGHNeuzAG8nLdNNHoi+Z6JJsVSu2w4Sg4OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuVmIE7PPOXhL9orYKy333nuKytJsMS9Y61cijTvkzCgjfObZBTAmo0lewZ77sZo2
	 tQKwXhPx/Qs7n8pZ89VIXCbl4P5vT5bzparcyGuVBsY43QUjO4wPn71zMa+6GYT1YI
	 J+0shg8njCCo/YENQEqLXwWDWL4LDYlvzNPqWLQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0323/1276] Bluetooth: vhci: validate devcoredump state before side effects
Date: Tue, 21 Jul 2026 17:12:46 +0200
Message-ID: <20260721152453.324799309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 59872e73c1878f..b03fe0d8363279 100644
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



