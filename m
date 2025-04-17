Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA24125F98F;
	Thu, 17 Apr 2025 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914658; cv=none; b=npbhQGpzGgbWy65vkjhLIi3hGDhQTp1LFgtenKnjUFyuI8ek+8pdPs89lBaZJq/bSXYGSjGuZlPssF+xAk+LGib2/MQ8u1ZNNDBqxq/qzJKAQuXHVMKEHMvWZCwjUAfWk7Sf93Aykrf1n+Tz/vra96nMFPd376CxkLPLN6pEsss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914658; c=relaxed/simple;
	bh=2ANiKC2EnCaOiG14s5bJmucSm1s7czOCNfffpBoHYbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fnCvG3y2LrKnKvQjEve2HBDSxhOqU01SULh/s16D7yP3DJOUkYFKuHXCVP8eUPs/ogHCltOm3+3DWr+Adr1O6qxZggEtiSJtjAAfWgXMAX339PyFRtTgUMJby9ZnmDKcLvdGbsoIRKiS9TmtU97eXn8K5Vi07no1HorBTNIq9ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EZtqNVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EZtqNVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14A3C4CEE4;
	Thu, 17 Apr 2025 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914658;
	bh=2ANiKC2EnCaOiG14s5bJmucSm1s7czOCNfffpBoHYbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EZtqNVxTj0RU04Gk28udDLYMiki90mzKLu6kkvnUkcYSh3wXKF/1/0UHX/izX2L3
	 V7Q7uNoPve/Zq+vAwTwZDYrQ9zMDhXFS97/coq+L/bxfj7UW6fUK8lP99oqzs3niAM
	 61EqfR9uVvuItqIPHcG3HrCI8HHuC/LfLb8odZaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.13 289/414] i3c: Add NULL pointer check in i3c_master_queue_ibi()
Date: Thu, 17 Apr 2025 19:50:47 +0200
Message-ID: <20250417175123.049933158@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2553,6 +2553,9 @@ static void i3c_master_unregister_i3c_de
  */
 void i3c_master_queue_ibi(struct i3c_dev_desc *dev, struct i3c_ibi_slot *slot)
 {
+	if (!dev->ibi || !slot)
+		return;
+
 	atomic_inc(&dev->ibi->pending_ibis);
 	queue_work(dev->ibi->wq, &slot->work);
 }


