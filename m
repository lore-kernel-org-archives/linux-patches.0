Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4F117BB01;
	Tue, 10 Sep 2024 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961717; cv=none; b=F8c5XRbFzMq6hvH/JPNRhU+rA5I2XVdD6AcWP0bhVQzdpTKFNSGrkhkyT5a/3YnGqlyYLA8hHufFJ0HUEtihBFBGgFWRnvpf6QQdf0hrIyH3CrNaTZivlFN2SpXRZQlOCMkNasPdeZ/Og1hqxT1kQUNeEZ1Bex19r+CcT4SwW7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961717; c=relaxed/simple;
	bh=R/e80BtubeyOMixVsUgSS7M073y11d4W0P3hpzX1y+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeQBaszLSrRYSh0SagcMFgmy14apsIBodNAXnGC8biK39ULglLYAJKvW/uVbN5jM2Nt9Rxd/cPqnZfFp0KSejjiqwbKnHI70gSKTV+fzal5qWFXrcoFhUmxNff6z6x2RtEj8mf9+r2KVNwYg4JZsnkmEp8dMoQ6WnKMDiJbYqV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vv1z3llI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vv1z3llI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7204C4CEC3;
	Tue, 10 Sep 2024 09:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961717;
	bh=R/e80BtubeyOMixVsUgSS7M073y11d4W0P3hpzX1y+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vv1z3llIDZZ4qqWmqYbrT9NHvOpYY2nPFH4v+r9hFwcmhVPzbVjfzMAWCv8uUID0U
	 +j7Er4hKPKKK4REe9uf89CXgtFwnRRF9GnY2Xa9nNo9XdUfGx4Ygu3XlKLGqYvYGmv
	 tjNZvFE9BNgXlilrB22kyyvEkGtyLTVxHkObhtko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 138/375] Input: ili210x - use kvmalloc() to allocate buffer for firmware update
Date: Tue, 10 Sep 2024 11:28:55 +0200
Message-ID: <20240910092627.082225742@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
index 79bdb2b10949..f3c3ad70244f 100644
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



