Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ADA2E2F04;
	Tue, 15 Jul 2025 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587463; cv=none; b=d4ut6eHhbWq6diKyPCfWxM5GFcvrKs/n7NlnBNTQRfJeLEg7OT4oiEhIlYrSlE/ao/8ze2TUtRt7VAtKnBu6I8zZtdRC/1U6K4cF2IdwVK4UqgyuG8wBwAuPafa3bUGzbuaov2Umn2Y+is0keXPQ10hr/p2KhdPzmzhW03u1xH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587463; c=relaxed/simple;
	bh=6NLiLdNptYnlHtts9qZdknzyh0fqpXgf29vmWlkBq9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ3HuDFrPRsN4+rqPkwPvY+6mi0uLXqN3aki9fVASWD8TAj0xla/IrsOUSb87wiX5e69rtPN/ggvJ/1o7b9IiOnK8viPhvGIDkpRz1dmrh7g/+tlHjGUwFUU3dSi8LeFNBnTg/95Jnnmjudk/k9RK753PkTBTxfr47lx5SwJ7E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pr+lNBej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pr+lNBej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5901CC4CEE3;
	Tue, 15 Jul 2025 13:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587463;
	bh=6NLiLdNptYnlHtts9qZdknzyh0fqpXgf29vmWlkBq9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pr+lNBejWhAV5AJ6EuTc9h8NX5pMVPaf7okXPyfefwP/JH/zVaJWjjy7CC+QCOIig
	 FaMpMpkEO+UlWbHHytijoh8P6UwF8YFgRc+4bj/9xyiYXn6CcxKiZy7Zdfs7KRSSkl
	 Uu18eTPTzrHElJKjr4jAqsUOEWlxaRIueG+iTWcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian-Wei Wu <jian-wei_wu@keysight.com>,
	Guido Kiener <guido.kiener@rohde-schwarz.com>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/208] USB: usbtmc: Fix reading stale status byte
Date: Tue, 15 Jul 2025 15:12:10 +0200
Message-ID: <20250715130811.685355098@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 3c1037e2b6a94898f81ed1a68bea146a9db750a5 ]

The ioctl USBTMC488_IOCTL_READ_STB either returns a cached status byte
(STB) sent by the device due to a service request (SRQ) condition or
the STB obtained from a query to the device with a READ_STATUS_BYTE
control message.

When the query is interrupted by an SRQ message on the interrupt pipe,
the ioctl still returns the requested STB while the STB of the
out-of-band SRQ message is cached for the next call of this
ioctl. However the cached SRQ STB represents a state that was previous
to the last returned STB.  Furthermore the cached SRQ STB can be stale
and not reflect the current state of the device.

The fixed ioctl now always reads the STB from the device and if the
associated file descriptor has the srq_asserted bit set it ors in the
RQS bit to the returned STB and clears the srq_asserted bit conformant
to subclass USB488 devices.

Tested-by: Jian-Wei Wu <jian-wei_wu@keysight.com>
Reviewed-by: Guido Kiener <guido.kiener@rohde-schwarz.com>
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20201215155621.9592-2-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: acb3dac2805d ("usb: usbtmc: Fix read_stb function and get_stb ioctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/usbtmc.c | 46 +++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index ff706f48e0ada..bfd99d461f813 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -475,15 +475,12 @@ static int usbtmc_ioctl_abort_bulk_out(struct usbtmc_device_data *data)
 	return usbtmc_ioctl_abort_bulk_out_tag(data, data->bTag_last_write);
 }
 
-static int usbtmc488_ioctl_read_stb(struct usbtmc_file_data *file_data,
-				void __user *arg)
+static int usbtmc_get_stb(struct usbtmc_file_data *file_data, __u8 *stb)
 {
 	struct usbtmc_device_data *data = file_data->data;
 	struct device *dev = &data->intf->dev;
-	int srq_asserted = 0;
 	u8 *buffer;
 	u8 tag;
-	__u8 stb;
 	int rv;
 	long wait_rv;
 	unsigned long expire;
@@ -491,19 +488,6 @@ static int usbtmc488_ioctl_read_stb(struct usbtmc_file_data *file_data,
 	dev_dbg(dev, "Enter ioctl_read_stb iin_ep_present: %d\n",
 		data->iin_ep_present);
 
-	spin_lock_irq(&data->dev_lock);
-	srq_asserted = atomic_xchg(&file_data->srq_asserted, srq_asserted);
-	if (srq_asserted) {
-		/* a STB with SRQ is already received */
-		stb = file_data->srq_byte;
-		spin_unlock_irq(&data->dev_lock);
-		rv = put_user(stb, (__u8 __user *)arg);
-		dev_dbg(dev, "stb:0x%02x with srq received %d\n",
-			(unsigned int)stb, rv);
-		return rv;
-	}
-	spin_unlock_irq(&data->dev_lock);
-
 	buffer = kmalloc(8, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
@@ -552,13 +536,12 @@ static int usbtmc488_ioctl_read_stb(struct usbtmc_file_data *file_data,
 				data->iin_bTag, tag);
 		}
 
-		stb = data->bNotify2;
+		*stb = data->bNotify2;
 	} else {
-		stb = buffer[2];
+		*stb = buffer[2];
 	}
 
-	rv = put_user(stb, (__u8 __user *)arg);
-	dev_dbg(dev, "stb:0x%02x received %d\n", (unsigned int)stb, rv);
+	dev_dbg(dev, "stb:0x%02x received %d\n", (unsigned int)*stb, rv);
 
 	rv = 0;
 
@@ -573,6 +556,27 @@ static int usbtmc488_ioctl_read_stb(struct usbtmc_file_data *file_data,
 	return rv;
 }
 
+static int usbtmc488_ioctl_read_stb(struct usbtmc_file_data *file_data,
+				void __user *arg)
+{
+	int srq_asserted = 0;
+	__u8 stb;
+	int rv;
+
+	rv = usbtmc_get_stb(file_data, &stb);
+
+	if (rv > 0) {
+		srq_asserted = atomic_xchg(&file_data->srq_asserted,
+					srq_asserted);
+		if (srq_asserted)
+			stb |= 0x40; /* Set RQS bit */
+
+		rv = put_user(stb, (__u8 __user *)arg);
+	}
+	return rv;
+
+}
+
 static int usbtmc488_ioctl_wait_srq(struct usbtmc_file_data *file_data,
 				    __u32 __user *arg)
 {
-- 
2.39.5



