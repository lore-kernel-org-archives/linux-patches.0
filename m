Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E25E1DFD91;
	Tue,  3 Dec 2024 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239929; cv=none; b=lqoruSDU6i4drs3np9itz5ADuHgK1EYf3mHH9+Bkfjr6u2sUeEPEQkQ8sIy9+uFQ7GDdCUhSXqw7u3EcSAyuRUPm5W2aM4GFu9pNcp39vqEbu3cFvbJxWlW+bzDs2Chdyg9XOcZ6oMfIotGmCWp6VU2ja+/4sVhSwt6AzJXzesw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239929; c=relaxed/simple;
	bh=KPl/28Qnt1IPJe6kf1jCqy84PQxOpGT39FZkSkDl8os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urSX+5u8sM3HNLcCAy/bmvlvfLARcRbe+feO5gD0IZwBV+8Nov5sINfK02SrsFhmPCgVDGSzOBEZnyap0tC5X5j+lAKOKG6s6pHp6WaSxkJFr/PstZbMKlgYLuJmmmpjIXd8yuywaDMbgn57fddPTROAfu7DGhfo0pyj70X/v0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8O5sXRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8O5sXRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6D6C4CECF;
	Tue,  3 Dec 2024 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239928;
	bh=KPl/28Qnt1IPJe6kf1jCqy84PQxOpGT39FZkSkDl8os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8O5sXRCK7ikd6AQ6G8Qr6Kj9BJnLR8B5V591aHMK1Va5g5o8m5ynandBLyyogJlV
	 sjo+hf8oOFiiNjWGpWRpDsgghfBs7pfkkxKiAh/65DuPpj+UWuLptb9KRajgmiuAus
	 skwRlfuDzNRen0n5Q/OeG5ScQEcTC+T3P/4L9v9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.11 751/817] usb: misc: ljca: move usb_autopm_put_interface() after wait for response
Date: Tue,  3 Dec 2024 15:45:23 +0100
Message-ID: <20241203144025.310872087@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

commit 5c5d8eb8af06df615e8b1dc88e5847196c846045 upstream.

Do not mark interface as ready to suspend when we are still waiting
for response messages from the device.

Fixes: acd6199f195d ("usb: Add support for Intel LJCA device")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com> # ThinkPad X1 Yoga Gen 8, ov2740
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://lore.kernel.org/r/20241112075514.680712-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usb-ljca.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/usb-ljca.c
+++ b/drivers/usb/misc/usb-ljca.c
@@ -332,14 +332,11 @@ static int ljca_send(struct ljca_adapter
 
 	ret = usb_bulk_msg(adap->usb_dev, adap->tx_pipe, header,
 			   msg_len, &transferred, LJCA_WRITE_TIMEOUT_MS);
-
-	usb_autopm_put_interface(adap->intf);
-
 	if (ret < 0)
-		goto out;
+		goto out_put;
 	if (transferred != msg_len) {
 		ret = -EIO;
-		goto out;
+		goto out_put;
 	}
 
 	if (ack) {
@@ -347,11 +344,14 @@ static int ljca_send(struct ljca_adapter
 						  timeout);
 		if (!ret) {
 			ret = -ETIMEDOUT;
-			goto out;
+			goto out_put;
 		}
 	}
 	ret = adap->actual_length;
 
+out_put:
+	usb_autopm_put_interface(adap->intf);
+
 out:
 	spin_lock_irqsave(&adap->lock, flags);
 	adap->ex_buf = NULL;


