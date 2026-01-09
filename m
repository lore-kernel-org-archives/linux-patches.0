Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B6338911;
	Fri,  9 Jan 2026 12:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960697; cv=none; b=QVmLRicVa9RMPma3nF8XotGSh78jIAJMUqCbaPXGMIxBIoVYPBXB5RBn8hx9DbX6qjCsElOCzA9yRHvr5pfXKj1v65gNTEntiLdnAWKdSH/pSFyi9NM/NuiIudJq9ZVEiptTXFyq3btREDEiSIyagFiiRzUwu+Ha9fEk/GSDbAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960697; c=relaxed/simple;
	bh=QQZDQqpqBF/iBvUjr3RkkUjujT9OJrjRXGw45Nb1h30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYGIaffiXbDHxdWoNKW0M0f+dqJztgG9qk6oaBo51xlWIPQqSnXyEoj6tNilh6KV2Vw85XfmzaAPwnzakKfDrwxiVUsC8ihY9EtBV6QEQyZLbc601tVxkrEMNZjqz54EpG3kp4by3+HDvFIQEbSPXxVYTEGsKJ3+hqdBJeX5TCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zB5I2mFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zB5I2mFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE52C4CEF1;
	Fri,  9 Jan 2026 12:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960697;
	bh=QQZDQqpqBF/iBvUjr3RkkUjujT9OJrjRXGw45Nb1h30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zB5I2mFVERlBuV0gjBXiqfr17NUNxSjMcofkggmw7CCdIwIuEEeHq3Oacn4jZIj8F
	 Nls63dgnL7pGubsqvq8oZQKUCI9ULbTzmpIKbE0Cwivz8YOGyk7ZVmA3xZTGFopw3D
	 vdn7gYrp7g4kK+FRSelZwDoWLHltoUtBZHN8Ib30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 492/737] soc: amlogic: canvas: fix device leak on lookup
Date: Fri,  9 Jan 2026 12:40:31 +0100
Message-ID: <20260109112152.499459639@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Johan Hovold <johan@kernel.org>

commit 32200f4828de9d7e6db379909898e718747f4e18 upstream.

Make sure to drop the reference taken to the canvas platform device when
looking up its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Also note that commit 28f851e6afa8 ("soc: amlogic: canvas: add missing
put_device() call in meson_canvas_get()") fixed the leak in a lookup
error path, but the reference is still leaking on success.

Fixes: d4983983d987 ("soc: amlogic: add meson-canvas driver")
Cc: stable@vger.kernel.org	# 4.20: 28f851e6afa8
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20250926142454.5929-2-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/amlogic/meson-canvas.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/soc/amlogic/meson-canvas.c
+++ b/drivers/soc/amlogic/meson-canvas.c
@@ -73,10 +73,9 @@ struct meson_canvas *meson_canvas_get(st
 	 * current state, this driver probe cannot return -EPROBE_DEFER
 	 */
 	canvas = dev_get_drvdata(&canvas_pdev->dev);
-	if (!canvas) {
-		put_device(&canvas_pdev->dev);
+	put_device(&canvas_pdev->dev);
+	if (!canvas)
 		return ERR_PTR(-EINVAL);
-	}
 
 	return canvas;
 }


