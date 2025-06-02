Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DAD22259C;
	Mon,  2 Jun 2025 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875244; cv=none; b=uvGrdVDyp7qjEN+/ppl/E26cELl7fIMgtgzZ7nv7j514TXUY4U/q7PKmUfLI+dI2gwBqlITEusdhLyaTHTETKPEmcENKbBK8xq/I5RbymIjqAP+0viU2rKSS52ZSv7kVRRQKlHKoCkfo4NqVR3XX4vPjWKxaC0wqCe4c//X4sF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875244; c=relaxed/simple;
	bh=qf1UOrNf65ZVes1zNIu7mn+lAITsxk04ePP9hfPONfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoNXbKXvUNPE936Uqm/HITJ+GEZQyaR0etYc3cCz6WBH4MfnmcVOdD0/F3EK3G7XuW6+yDAdGF3okWrFQSHInOVtxCtE4dAFJc3MW7rLcNwxY4tMzUSUSMHI+KhPeRoKPZJ8n5vWWUlQh6qkQo3mbeBEO6zTifPo4vv/SPs4onk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTLR3Ryc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTLR3Ryc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE180C4CEEB;
	Mon,  2 Jun 2025 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875244;
	bh=qf1UOrNf65ZVes1zNIu7mn+lAITsxk04ePP9hfPONfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTLR3Rycnd+LL5ni4K+1h7fFSq5tblVU4r/Cvp3pcX3I3ULzfyq0W3hSCXT8A0ean
	 PwYKtLeYlJ2956/2MoenfWr3oXGJI9WfedYYzfpQXrs8XlMKCOqNfOU58jz39PVyNq
	 06Shhv9SnXzel8JJZQytcho6cHWo9j6rJXG111Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Katzmann <vk2bea@gmail.com>,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 5.10 074/270] usb: usbtmc: Fix erroneous get_stb ioctl error returns
Date: Mon,  2 Jun 2025 15:45:59 +0200
Message-ID: <20250602134310.207256155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

commit cac01bd178d6a2a23727f138d647ce1a0e8a73a1 upstream.

wait_event_interruptible_timeout returns a long
The return was being assigned to an int causing an integer overflow when
the remaining jiffies > INT_MAX resulting in random error returns.

Use a long return value and convert to int ioctl return only on error.

When the return value of wait_event_interruptible_timeout was <= INT_MAX
the number of remaining jiffies was returned which has no meaning for the
user. Return 0 on success.

Reported-by: Michael Katzmann <vk2bea@gmail.com>
Fixes: dbf3e7f654c0 ("Implement an ioctl to support the USMTMC-USB488 READ_STATUS_BYTE operation.")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250502070941.31819-2-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -485,6 +485,7 @@ static int usbtmc488_ioctl_read_stb(stru
 	u8 tag;
 	__u8 stb;
 	int rv;
+	long wait_rv;
 
 	dev_dbg(dev, "Enter ioctl_read_stb iin_ep_present: %d\n",
 		data->iin_ep_present);
@@ -527,16 +528,17 @@ static int usbtmc488_ioctl_read_stb(stru
 	}
 
 	if (data->iin_ep_present) {
-		rv = wait_event_interruptible_timeout(
+		wait_rv = wait_event_interruptible_timeout(
 			data->waitq,
 			atomic_read(&data->iin_data_valid) != 0,
 			file_data->timeout);
-		if (rv < 0) {
-			dev_dbg(dev, "wait interrupted %d\n", rv);
+		if (wait_rv < 0) {
+			dev_dbg(dev, "wait interrupted %ld\n", wait_rv);
+			rv = wait_rv;
 			goto exit;
 		}
 
-		if (rv == 0) {
+		if (wait_rv == 0) {
 			dev_dbg(dev, "wait timed out\n");
 			rv = -ETIMEDOUT;
 			goto exit;
@@ -556,6 +558,8 @@ static int usbtmc488_ioctl_read_stb(stru
 	rv = put_user(stb, (__u8 __user *)arg);
 	dev_dbg(dev, "stb:0x%02x received %d\n", (unsigned int)stb, rv);
 
+	rv = 0;
+
  exit:
 	/* bump interrupt bTag */
 	data->iin_bTag += 1;


