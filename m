Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402C32571A1;
	Thu, 17 Apr 2025 18:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915885; cv=none; b=p7P90kFTnZ40bsvzwrRxpMnd/63IOdogQOan/fENVGlUxond2CUxC7CFI/mZnfqkT0jF5pWig4ksomVy2nTsmDU24HefmV517GiJ2Tyxo8Zo5AKDA1Gyn+fH9R/H18pMfvgC8aED3Y1gMCHZFtnFNpSDJAHKVsn9iK3o31pmk4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915885; c=relaxed/simple;
	bh=2tbvhe+9VjLeAxuDoGdXW98AGRqZwvmlSrI0Q/0ruJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yoi7+l7SGyxlrUfplZf1GWQlXW3tubvYaDg6aBoAcnP7un96TL0NfCbiYdfhjoHkZsP8xX5kXL55W4Ld57Xhu626TeIJDr8Nk4XXn+mFnWhshmDXZ50bJZriXnlyum0EXJfizXXa/vnkiLSRURggHJa1GkOF8Cvtj/2TmNhIy5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyW9+8TL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyW9+8TL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16D9C4CEE4;
	Thu, 17 Apr 2025 18:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915885;
	bh=2tbvhe+9VjLeAxuDoGdXW98AGRqZwvmlSrI0Q/0ruJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyW9+8TLa5yMOC1OVP8hdkxk4fC1YJMbg3A99+7oCAwhNCheg1eHB95yYbl/mI4es
	 yj0n6NrImh98LhTQd+CnuCJqR3GDEyYIs+6PCdLyioNGFFHJP5Hm1+kyu4IFhJ9Qyu
	 g9K3fs4nVkR3pksIkuw3CRcm3M6EsYKwxjIh3YuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 271/393] i3c: Add NULL pointer check in i3c_master_queue_ibi()
Date: Thu, 17 Apr 2025 19:51:20 +0200
Message-ID: <20250417175118.505437286@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


