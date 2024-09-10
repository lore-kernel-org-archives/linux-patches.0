Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C141946BA;
	Tue, 10 Sep 2024 10:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962884; cv=none; b=o25M/o1xbXpJh1TDcROp0/O4m2QD+hc3xJIYJvnAiUg7dQEu+u+kDmyEVNTZLaTrjfbOHMz3Iz1xzJeP8pgJyP4QiNjbcPULmw+f+Lb3UkxvxxB1GVFiEIEW1QYtxdSZz9CY3Zik2GFE6R/DXTjlFT+EoNf6SpoEbvjztzi5/iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962884; c=relaxed/simple;
	bh=+9jXXW0TpGUgwNBKgCem2tbLcGWzT+bXSFWJLxLqUTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPFyBys9+Jf2kzCm4BmRTJt1NIZVJWvdhkCt8q5aTGU1u5WnT5Y22zBYZJxyp/hrDRjlnN1jvT5c/Qszk3I/iT8C51IgRPuxpaanV+lXqabX4oPhkZeFxsKAos/TIRkOhcny3GH8E+eKOV5PyLyMXzq+WH/jKR/r32UktpGMZ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoRl1+nG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoRl1+nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9479AC4CEC3;
	Tue, 10 Sep 2024 10:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962884;
	bh=+9jXXW0TpGUgwNBKgCem2tbLcGWzT+bXSFWJLxLqUTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoRl1+nGeIj3rgxaJBs7yPBu9X9N2FLUYr1I+wqvwj/xcdck8EcL0uTU7XP9c4mAv
	 I11+ZYpKZKi8JT9y7vSi3aS7wNVRvuo5FVuhT68An3OWOELys13tWkT+N+kMLFYj9D
	 ARUTv8znPvEiE+8RVQ0dIqjtd10fScTp7pewSdgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/192] Input: ili210x - use kvmalloc() to allocate buffer for firmware update
Date: Tue, 10 Sep 2024 11:31:27 +0200
Message-ID: <20240910092600.591017944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 17f5eebf6780eee50f887542e1833fda95f53e4d ]

Allocating a contiguous buffer of 64K may fail if memory is sufficiently
fragmented, and may cause OOM kill of an unrelated process. However we
do not need to have contiguous memory. We also do not need to zero
out the buffer since it will be overwritten with firmware data.

Switch to using kvmalloc() instead of kzalloc().

Link: https://lore.kernel.org/r/20240609234757.610273-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ili210x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
index e3a36cd3656c..8c8eea5173f7 100644
--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -586,7 +586,7 @@ static int ili251x_firmware_to_buffer(const struct firmware *fw,
 	 * once, copy them all into this buffer at the right locations, and then
 	 * do all operations on this linear buffer.
 	 */
-	fw_buf = kzalloc(SZ_64K, GFP_KERNEL);
+	fw_buf = kvmalloc(SZ_64K, GFP_KERNEL);
 	if (!fw_buf)
 		return -ENOMEM;
 
@@ -616,7 +616,7 @@ static int ili251x_firmware_to_buffer(const struct firmware *fw,
 	return 0;
 
 err_big:
-	kfree(fw_buf);
+	kvfree(fw_buf);
 	return error;
 }
 
@@ -859,7 +859,7 @@ static ssize_t ili210x_firmware_update_store(struct device *dev,
 	ili210x_hardware_reset(priv->reset_gpio);
 	dev_dbg(dev, "Firmware update ended, error=%i\n", error);
 	enable_irq(client->irq);
-	kfree(fwbuf);
+	kvfree(fwbuf);
 	return error;
 }
 
-- 
2.43.0



