Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EA726B0B8;
	Thu, 13 Feb 2025 15:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459923; cv=none; b=lZl2M5dvXDFe48QBe4xXBRS6BOKmBGn1fsTxW/mZQBbmqajDOwNeW6S4Lf9DCVqOMh3P5vU/JnzfXYArPAcLf0EHMhuEqlt4W4Kb6SEBahNu9ZxqCyOBU3AfL21pQ4xPIEjfkBTqcKbNeOeI6mrk0pOa+0Rzf4TnLnmdXv1QWoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459923; c=relaxed/simple;
	bh=qRTOiHuF20WY2dJw8VilAv/2Oavna4ugzHkwQT0P/pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0YZi5By3bLhJz37RHRpk2KTZ9BqlVQ/SgdvRD5BsUwWLMUFVlQL1FI0WK7juiy8Nqu2RMWyM0iyYp4vxSJEB8NsJyQtTwa81S9hVRZo+u2EGLvskq5tSUrijpKVM+oPh1n7FAsA5/r0sVgixoJsSNHwflYlgdN8MzCROleUEfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPbfGRuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPbfGRuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7440FC4CED1;
	Thu, 13 Feb 2025 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459922;
	bh=qRTOiHuF20WY2dJw8VilAv/2Oavna4ugzHkwQT0P/pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPbfGRuCVkkUAFGKaxm5Sz4Yva7UsSM7lW6CzAutVKlRzK7IpcQNpjCysmYOxQDfL
	 52ydg/4+xQAdc36DihWVYYYOg5CqOmfCPSh3InUvFFwzX6I+apN5YwdGeG59cx8qjC
	 aM4FBqy5x2KHh7ahiiflORBVY+OXTDkMGDZ9TsPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pekka Pessi <ppessi@nvidia.com>,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6.13 404/443] mailbox: tegra-hsp: Clear mailbox before using message
Date: Thu, 13 Feb 2025 15:29:29 +0100
Message-ID: <20250213142456.198404458@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


