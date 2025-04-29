Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158F524113A;
	Tue, 29 Apr 2025 16:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945370; cv=none; b=ecebxSv3qFXHQkqGtTkSmwbWsRV5g/7Mdye3QOexxbGlGLxSfj+UFqaCumtQS22lZVMGkXvcV35vc5SacHf9WHj2nE1laCyRfEKIvb3NI1QVE3ZztHu5fWPxLLI9iEyLSlmlecgFaXeQBa1IU/IxOaxJaJcw561OtW/UI+SdMzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945370; c=relaxed/simple;
	bh=+L3oikeG7UhHWkLrp8rEIpF1hA+nJjoTewHOtXFMVBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/k9kAsnvZRfurZju9Jg3+5BOtW9DAjfIW358oieZ7TcDH7ADAV7LEhR4c5b4ZAqqqcTNO1OtWjAS9UczEcjfzz6vjU5QZu4nSwnulkgbJ2BM716rmy23G2P5YuLA55JH9NsB45B6b5dfFb2BamqBRZVECwptuTt/hLfc8xK7y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KM2bG76O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KM2bG76O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08614C4CEE9;
	Tue, 29 Apr 2025 16:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945369;
	bh=+L3oikeG7UhHWkLrp8rEIpF1hA+nJjoTewHOtXFMVBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KM2bG76OhUS3mAkTaZDkfuY1bhxcxLYpBBJPQKTu4xCvunQdmkp5YAsq5laA9Vmcb
	 wncVIMD1XhLoFXUNkoPqAJnIr/0x3vfO9F/LdnYrYnWxIxTdyYi32g0vSbUTTKewXq
	 E6lyI0F3mNC45VS398zRZ7MKitS9UOT6s08l5wjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 059/179] i3c: Add NULL pointer check in i3c_master_queue_ibi()
Date: Tue, 29 Apr 2025 18:40:00 +0200
Message-ID: <20250429161051.791964323@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>

commit bd496a44f041da9ef3afe14d1d6193d460424e91 upstream.

The I3C master driver may receive an IBI from a target device that has not
been probed yet. In such cases, the master calls `i3c_master_queue_ibi()`
to queue an IBI work task, leading to "Unable to handle kernel read from
unreadable memory" and resulting in a kernel panic.

Typical IBI handling flow:
1. The I3C master scans target devices and probes their respective drivers.
2. The target device driver calls `i3c_device_request_ibi()` to enable IBI
   and assigns `dev->ibi = ibi`.
3. The I3C master receives an IBI from the target device and calls
   `i3c_master_queue_ibi()` to queue the target device driver’s IBI
   handler task.

However, since target device events are asynchronous to the I3C probe
sequence, step 3 may occur before step 2, causing `dev->ibi` to be `NULL`,
leading to a kernel panic.

Add a NULL pointer check in `i3c_master_queue_ibi()` to prevent accessing
an uninitialized `dev->ibi`, ensuring stability.

Fixes: 3a379bbcea0af ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/Z9gjGYudiYyl3bSe@lizhi-Precision-Tower-5810/
Signed-off-by: Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250326123047.2797946-1-manjunatha.venkatesh@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2198,6 +2198,9 @@ static void i3c_master_unregister_i3c_de
  */
 void i3c_master_queue_ibi(struct i3c_dev_desc *dev, struct i3c_ibi_slot *slot)
 {
+	if (!dev->ibi || !slot)
+		return;
+
 	atomic_inc(&dev->ibi->pending_ibis);
 	queue_work(dev->common.master->wq, &slot->work);
 }


