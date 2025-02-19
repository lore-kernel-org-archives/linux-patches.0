Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9781B6D0A;
	Wed, 19 Feb 2025 09:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957158; cv=none; b=V/ZrepRujc3sXTARTkBtI03kG6rm1WRAITIAIDKYP0rn1gh1X+krnuzBMDbfgeDHimfDzWtTdPOep8rWDklAcN856DESRYkF/hV+MCeDbJhVeP0GFi59V8WBpv53eRvD+mAN39PDw3KpkTD2xXVZajkaqPdnZfqtUhKWfC6AMM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957158; c=relaxed/simple;
	bh=HCvdH8yNPQfoFMgIpogMkvjjrGu+x1tgxfe99Is0LUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIzwdLAzZj5Z5ndXyuaWiUmyMFSsU2aHQNbd8Sz14N3gOfcrjgxKgwnzGhLmu4SDNM9ojgIf6/ZOX0LkkeYeb1ZKUm7YPT89xk1zEvfHZhw99MqAgUHnb4ql/+A/lwRUg5Ydh/3zJGZ/o3V4dKGxYBWn5PP0sXL0kXL5Q3SAWUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9u75eJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9u75eJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D6FC4CED1;
	Wed, 19 Feb 2025 09:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957158;
	bh=HCvdH8yNPQfoFMgIpogMkvjjrGu+x1tgxfe99Is0LUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9u75eJ6h/PGXuHv6M+S5xptRhj4HpsOK01WieuzTNntIl4EayxgJnebEiuxMwzCW
	 KFiRmm9sg9uQnhapaUR/KrscvyKHUo5CDm5yq/BazEGm7CjnxC5NgjAWv4T33S4UxF
	 vZv3mn9khfZx7NTd7LR6jYT3SOpVQSIyrFQLgyuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pekka Pessi <ppessi@nvidia.com>,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6.1 429/578] mailbox: tegra-hsp: Clear mailbox before using message
Date: Wed, 19 Feb 2025 09:27:13 +0100
Message-ID: <20250219082709.891634008@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekka Pessi <ppessi@nvidia.com>

commit 0b7f8328f988178b55ee11d772a6e1238c04d29d upstream.

The Tegra RCE (Camera) driver expects the mailbox to be empty before
processing the IVC messages. On RT kernel, the threads processing the
IVC messages (which are invoked after `mbox_chan_received_data()` is
called) may be on a different CPU or running with a higher priority
than the HSP interrupt handler thread. This can cause it to act on the
message before the mailbox gets cleared in the HSP interrupt handler
resulting in a loss of IVC notification.

Fix this by clearing the mailbox data register before calling
`mbox_chan_received_data()`.

Fixes: 8f585d14030d ("mailbox: tegra-hsp: Add tegra_hsp_sm_ops")
Fixes: 74c20dd0f892 ("mailbox: tegra-hsp: Add 128-bit shared mailbox support")
Cc: stable@vger.kernel.org
Signed-off-by: Pekka Pessi <ppessi@nvidia.com>
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/tegra-hsp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mailbox/tegra-hsp.c
+++ b/drivers/mailbox/tegra-hsp.c
@@ -388,7 +388,6 @@ static void tegra_hsp_sm_recv32(struct t
 	value = tegra_hsp_channel_readl(channel, HSP_SM_SHRD_MBOX);
 	value &= ~HSP_SM_SHRD_MBOX_FULL;
 	msg = (void *)(unsigned long)value;
-	mbox_chan_received_data(channel->chan, msg);
 
 	/*
 	 * Need to clear all bits here since some producers, such as TCU, depend
@@ -398,6 +397,8 @@ static void tegra_hsp_sm_recv32(struct t
 	 * explicitly, so we have to make sure we cover all possible cases.
 	 */
 	tegra_hsp_channel_writel(channel, 0x0, HSP_SM_SHRD_MBOX);
+
+	mbox_chan_received_data(channel->chan, msg);
 }
 
 static const struct tegra_hsp_sm_ops tegra_hsp_sm_32bit_ops = {
@@ -433,7 +434,6 @@ static void tegra_hsp_sm_recv128(struct
 	value[3] = tegra_hsp_channel_readl(channel, HSP_SHRD_MBOX_TYPE1_DATA3);
 
 	msg = (void *)(unsigned long)value;
-	mbox_chan_received_data(channel->chan, msg);
 
 	/*
 	 * Clear data registers and tag.
@@ -443,6 +443,8 @@ static void tegra_hsp_sm_recv128(struct
 	tegra_hsp_channel_writel(channel, 0x0, HSP_SHRD_MBOX_TYPE1_DATA2);
 	tegra_hsp_channel_writel(channel, 0x0, HSP_SHRD_MBOX_TYPE1_DATA3);
 	tegra_hsp_channel_writel(channel, 0x0, HSP_SHRD_MBOX_TYPE1_TAG);
+
+	mbox_chan_received_data(channel->chan, msg);
 }
 
 static const struct tegra_hsp_sm_ops tegra_hsp_sm_128bit_ops = {


