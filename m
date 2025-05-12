Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A477221770B;
	Mon, 12 May 2025 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072115; cv=none; b=YcXWK81VPIFLbHvfibMo3cTGrg3lLKkKNDD3Yn++mxR7lP715287Qs19wMrAKNe6sHYRPMXywSu0p9UCV9XCaL5q0UKUOP+tMn98Qali4jjYmhX2U4LHs6LnT0cQOgbYCN7nyTn5r5YOa4088SxKAgxe9zoGfe6MX1wXQafSJ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072115; c=relaxed/simple;
	bh=CpwWA09NVhPVu1wtHwud/oNED1wgAd70rP8eU/Ahiqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1PI7QAZZ8H0AfgWtfTUiXq7CCcd3c8CrraQRfZ11sUv2+sWwO1W/96nG4OBvg6vMjlImRFLm9I4Z9HKuoswHK4sB9ysR+zsqO5JN1VqyfOzX7PcFY5FPJLwazpxJm24HreL6TujisF2A+o+UGZuVt9OjEjRVD6JGSpOm5wSOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUlbhg/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUlbhg/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E79C4CEE7;
	Mon, 12 May 2025 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072115;
	bh=CpwWA09NVhPVu1wtHwud/oNED1wgAd70rP8eU/Ahiqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUlbhg/zzpRQzas5g3/jJD/Nmsu/sBMJN8tWRD9xb88etnKIQwaqLPRXMq/UkEs17
	 OTGpZQ6m/yK8ZXcq/c8PU0AWmXvrhBLAAg6YwKwcb0be+zi0uZMK/DrYhbpfsv1yG5
	 Ba5sN1dP3BDzR7Ofx6/b7c1PRsngs5Anw9G+5KKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Katzmann <vk2bea@gmail.com>,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.14 146/197] usb: usbtmc: Fix erroneous get_stb ioctl error returns
Date: Mon, 12 May 2025 19:39:56 +0200
Message-ID: <20250512172050.338804080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -482,6 +482,7 @@ static int usbtmc_get_stb(struct usbtmc_
 	u8 *buffer;
 	u8 tag;
 	int rv;
+	long wait_rv;
 
 	dev_dbg(dev, "Enter ioctl_read_stb iin_ep_present: %d\n",
 		data->iin_ep_present);
@@ -511,16 +512,17 @@ static int usbtmc_get_stb(struct usbtmc_
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
@@ -539,6 +541,8 @@ static int usbtmc_get_stb(struct usbtmc_
 
 	dev_dbg(dev, "stb:0x%02x received %d\n", (unsigned int)*stb, rv);
 
+	rv = 0;
+
  exit:
 	/* bump interrupt bTag */
 	data->iin_bTag += 1;


