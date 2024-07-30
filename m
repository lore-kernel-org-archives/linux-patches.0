Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A0E155CB3;
	Tue, 30 Jul 2024 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358120; cv=none; b=qDNfBVcj1RfJunwq+t7e96sXCWTjkQK1zQjnKMZCuiDdyj54F3eXX4a1jHaEyk/pkSMWzLu1P9zURc0mEeMRaN12m44XRxelP1jE/jzIyPEoTjVW2LrQ2VcWmHmgffAAwL91NVlB6x4t0N3RRf+IeuHVIFSYRleQ0acd24GVI9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358120; c=relaxed/simple;
	bh=HhILBDp2QZS3oPotZbHEX54Ez2Vj7vnYddc/euh0Bwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHJ7oJto1ml3PHRuHVPzIUePyESzEMHYrbYlZY51KIk3SlfQmkw1HN/VHgEXvInKCzCBmt6AXVWvBn/XHo/6iDT2gyIq2FFJGgeOE2h8qUevX9+z4/QCIBps/46IgDFyjDjqf6W5wnNrTXqVBtqI+CM6jIF040k+oSnedzu7xXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQh+Fg0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQh+Fg0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6E7C4AF0E;
	Tue, 30 Jul 2024 16:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358120;
	bh=HhILBDp2QZS3oPotZbHEX54Ez2Vj7vnYddc/euh0Bwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQh+Fg0wxKkaPWBEKQqzRVCZBY88jDgAfmOqmLCKLAytpHSHLF/NC9fmzgRXvmSIx
	 9mYey2rgXOcsc1Zxop2gSfe7TQHGDD8PxeEIiDNc8KB4D+o7IGQl9VaEHFixZTBTX+
	 2ew89PU49F4jPKJZk9YloBfxt5/1McQGtFc6n/wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 307/809] ipmi: ssif_bmc: prevent integer overflow on 32bit systems
Date: Tue, 30 Jul 2024 17:43:03 +0200
Message-ID: <20240730151736.725020872@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0627cef36145c9ff9845bdfd7ddf485bbac1f981 ]

There are actually two bugs here.  First, we need to ensure that count
is at least sizeof(u32) or msg.len will be uninitialized data.

The "msg.len" variable is a u32 that comes from the user.  On 32bit
systems the "sizeof_field(struct ipmi_ssif_msg, len) + msg.len"
addition can overflow if "msg.len" is greater than U32_MAX - 4.

Valid lengths for "msg.len" are 1-254.  Add a check for that to
prevent the integer overflow.

Fixes: dd2bc5cc9e25 ("ipmi: ssif_bmc: Add SSIF BMC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-Id: <1431ca2e-4e9c-4520-bfc0-6879313c30e9@moroto.mountain>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ssif_bmc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ssif_bmc.c b/drivers/char/ipmi/ssif_bmc.c
index 56346fb328727..ab4e87a99f087 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -177,13 +177,15 @@ static ssize_t ssif_bmc_write(struct file *file, const char __user *buf, size_t
 	unsigned long flags;
 	ssize_t ret;
 
-	if (count > sizeof(struct ipmi_ssif_msg))
+	if (count < sizeof(msg.len) ||
+	    count > sizeof(struct ipmi_ssif_msg))
 		return -EINVAL;
 
 	if (copy_from_user(&msg, buf, count))
 		return -EFAULT;
 
-	if (!msg.len || count < sizeof_field(struct ipmi_ssif_msg, len) + msg.len)
+	if (!msg.len || msg.len > IPMI_SSIF_PAYLOAD_MAX ||
+	    count < sizeof_field(struct ipmi_ssif_msg, len) + msg.len)
 		return -EINVAL;
 
 	spin_lock_irqsave(&ssif_bmc->lock, flags);
-- 
2.43.0



