Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0561AB6DD;
	Mon, 14 Oct 2024 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916482; cv=none; b=fwN3DxeJ9bK2a46/x8DaohR3XC0pLAqZeq03sFmUL74cbASBePu6HchHvtaExBYzUwpRfeSu6RsmvcZRKcIUMrI9qnAI+yF/D2X3srDHlcqDlTt7Fy7T5Ra0+RELWyPxFW/+SkD+LlcNf8MmeAvZOql9a1gBhZ5UJPWKSZarVBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916482; c=relaxed/simple;
	bh=e0qcGTWIdFgOhCvZXA2Qg8fhbqrWsBfGHgM9u+k8t1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r++6uIs0v88yuWjSte+prlqJituHcHvuHEB1uyvSp8xJCPl1/n2+1G3g71qL9P1CTguWGQto6V9c8qB2on8uZyPBxoHvM5Xx3ZvYo/HF2TX7McaS2GOOObQ+tyoGumt3CUNvB6Xxx/Qi6rQl0s+l2Cch3KEg6pPvAvx3XIx3zwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4se4Yh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4se4Yh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E25C4CEC3;
	Mon, 14 Oct 2024 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916482;
	bh=e0qcGTWIdFgOhCvZXA2Qg8fhbqrWsBfGHgM9u+k8t1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4se4Yh1isnEItzZg19u2J4rjgTLxCJTuJUuHN7OmiFkbyn3TUKCqPPx/YbEfyw3h
	 1lWbwx5R9p3bz6owgB4BOTmNa3XaS8gnAvTUcbynZiRmmBw4eSFi72XbvkmLDdsSVZ
	 WYNmL4eimylzs//n6QEU07vGG84MnghuwfFdx1Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.11 165/214] usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip
Date: Mon, 14 Oct 2024 16:20:28 +0200
Message-ID: <20241014141051.422157754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Icenowy Zheng <uwu@icenowy.me>

commit a6555cb1cb69db479d0760e392c175ba32426842 upstream.

JieLi tends to use SCSI via USB Mass Storage to implement their own
proprietary commands instead of implementing another USB interface.
Enumerating it as a generic mass storage device will lead to a Hardware
Error sense key get reported.

Ignore this bogus device to prevent appearing a unusable sdX device
file.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20241001083407.8336-1-uwu@icenowy.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2423,6 +2423,17 @@ UNUSUAL_DEV(  0xc251, 0x4003, 0x0100, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NOT_LOCKABLE),
 
+/*
+ * Reported by Icenowy Zheng <uwu@icenowy.me>
+ * This is an interface for vendor-specific cryptic commands instead
+ * of real USB storage device.
+ */
+UNUSUAL_DEV(  0xe5b7, 0x0811, 0x0100, 0x0100,
+		"ZhuHai JieLi Technology",
+		"JieLi BR21",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_DEVICE),
+
 /* Reported by Andrew Simmons <andrew.simmons@gmail.com> */
 UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x0001,
 		"DataStor",


