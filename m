Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0543D18CBE2;
	Tue, 10 Sep 2024 10:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964250; cv=none; b=WsBkY045ORephzU+i4DbqsbFhM0wD2WVuJRN2Krb/+CqcXOfihB/VPgtfIhkgnymJ21BA6UY+6Pt0Y+41DvxVBaM3hYPmFEPk7L7ppXmDwJ1y5zyWT1SB6/CnC/ovI0oerr41/knizT6BPwZWaYHLX1TBQV7V9OJqgq1aSRPPcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964250; c=relaxed/simple;
	bh=s8GrAdqag9kghWub2sygA/q0JqXyS+pOVUqFiVmE210=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0yqAyKY8I+3lcykzBQ6hm/nOx3pjEdfq6HwICOBtUbY5yvacC1SFfrJ/ZGRk0D3Ekw5Nzeli/ej5UrnUnvlUxmrBPhO9L6kWQO41zOLoJCTJSHAdRD0NXKlubDvX7rAJ7BaQBOTBngPsxLqWGtvnZHwQZ2ZZQVznfYRVX9Lq80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLTwKDd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLTwKDd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F0CC4CEC3;
	Tue, 10 Sep 2024 10:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964249;
	bh=s8GrAdqag9kghWub2sygA/q0JqXyS+pOVUqFiVmE210=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLTwKDd3r0fWZ6qVg4Lh92PjSaMGMas5wtwW8XG1Voh1RCCiVzXMClDcJQBrQbnrN
	 4oHYbk0nKKasiJGfGzAkO8I1i49qv3kIa1Hy4sWNxKOh8GAsIV4O4OAJsZhsSA096t
	 l99co863tzw5M6EZKJBgbJngCWcvwW5sSy6dex3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/269] Input: ili210x - use kvmalloc() to allocate buffer for firmware update
Date: Tue, 10 Sep 2024 11:31:18 +0200
Message-ID: <20240910092611.456810167@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ae7ba0c419f5..6a77babcf722 100644
--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -597,7 +597,7 @@ static int ili251x_firmware_to_buffer(const struct firmware *fw,
 	 * once, copy them all into this buffer at the right locations, and then
 	 * do all operations on this linear buffer.
 	 */
-	fw_buf = kzalloc(SZ_64K, GFP_KERNEL);
+	fw_buf = kvmalloc(SZ_64K, GFP_KERNEL);
 	if (!fw_buf)
 		return -ENOMEM;
 
@@ -627,7 +627,7 @@ static int ili251x_firmware_to_buffer(const struct firmware *fw,
 	return 0;
 
 err_big:
-	kfree(fw_buf);
+	kvfree(fw_buf);
 	return error;
 }
 
@@ -870,7 +870,7 @@ static ssize_t ili210x_firmware_update_store(struct device *dev,
 	ili210x_hardware_reset(priv->reset_gpio);
 	dev_dbg(dev, "Firmware update ended, error=%i\n", error);
 	enable_irq(client->irq);
-	kfree(fwbuf);
+	kvfree(fwbuf);
 	return error;
 }
 
-- 
2.43.0



