Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22161226863;
	Thu, 12 Dec 2024 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022808; cv=none; b=Q9gmIXbMLLkspD/DIZigpCnav4C/UVzu9U9M6Q35ZYj3YtNiPH09kqwPfAGyDZIzoLCfxfSCoqv7d1fzbXX0dzi3BJlNO9EnRNYXce1uwdpuQwZmxdTKYJ+6V7b52MDlDMStbUSGI98lmdOqLxmlkPooGW4L9PCtuZtJqplyF98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022808; c=relaxed/simple;
	bh=wSwpK8O1BpAleXMIT+8DNdqDug4CG19HH+4CbwC3g9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooWNp8g8onbFEBW7TV1YDBecrN9FXwiWF235Mw6xWtv85h0y4W4mG52YKRtk84AxdgInxHs/dJVZ4j7ywoXMwp09h0vEFrkvmFXdm3w5/wjEvVdin7UHFmy0OBkXMRPTIdhhVm5aTrfzolqmwc/UaGnodvT98My4vZw92Hp3jd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AklwHIxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AklwHIxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D50C4CECE;
	Thu, 12 Dec 2024 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022807;
	bh=wSwpK8O1BpAleXMIT+8DNdqDug4CG19HH+4CbwC3g9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AklwHIxeKb6AQSYY0eblNTarNZKQ7eURg60xAs0fWOQwnb87v+W2J+VB+ASiZQFKS
	 t35rNVivTy0RxASZp8NavwfZKQ/d4WdAVS+Mam0T0xjgKZCA/p3D5UwRKzlZKgO0gX
	 k07RKRW971JR/PcsnirDE1fLoGCazSzXv/tYzJDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 340/565] media: wl128x: Fix atomicity violation in fmc_send_cmd()
Date: Thu, 12 Dec 2024 15:58:55 +0100
Message-ID: <20241212144325.036655772@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit ca59f9956d4519ab18ab2270be47c6b8c6ced091 upstream.

Atomicity violation occurs when the fmc_send_cmd() function is executed
simultaneously with the modification of the fmdev->resp_skb value.
Consider a scenario where, after passing the validity check within the
function, a non-null fmdev->resp_skb variable is assigned a null value.
This results in an invalid fmdev->resp_skb variable passing the validity
check. As seen in the later part of the function, skb = fmdev->resp_skb;
when the invalid fmdev->resp_skb passes the check, a null pointer
dereference error may occur at line 478, evt_hdr = (void *)skb->data;

To address this issue, it is recommended to include the validity check of
fmdev->resp_skb within the locked section of the function. This
modification ensures that the value of fmdev->resp_skb does not change
during the validation process, thereby maintaining its validity.

This possible bug is found by an experimental static analysis tool
developed by our team. This tool analyzes the locking APIs
to extract function pairs that can be concurrently executed, and then
analyzes the instructions in the paired functions to identify possible
concurrency bugs including data races and atomicity violations.

Fixes: e8454ff7b9a4 ("[media] drivers:media:radio: wl128x: FM Driver Common sources")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/radio/wl128x/fmdrv_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -465,11 +465,12 @@ int fmc_send_cmd(struct fmdev *fmdev, u8
 			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
 		return -ETIMEDOUT;
 	}
+	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
 	if (!fmdev->resp_skb) {
+		spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
 		fmerr("Response SKB is missing\n");
 		return -EFAULT;
 	}
-	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
 	skb = fmdev->resp_skb;
 	fmdev->resp_skb = NULL;
 	spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);


