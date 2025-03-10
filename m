Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18CC23372B;
	Mon, 10 Mar 2025 17:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627752; cv=none; b=F9XKb0l47pbZcVA+gJR6XJbnL+ydVL8D94ABvLyroxG1XHJ1BNwh5nwF3seSjwrMQUF2D7sWM18J02LQHZCfSR2ieAwl7hLqjcK4xeJKMYtmtnvApkyjwyusEkFo40W8ZK44jiRWsxdhHI/GscBPVFKnssYmWTojnSCfy8G2dtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627752; c=relaxed/simple;
	bh=zQIig8y4PsNpB79LSA9qqS8FSPZIc6uGI70w9EFAgMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpkXzfFBVl4xyN3mVOG4nvm8r2pnmo7tqDunLvgqFtx5q15UDZudokysP3xeVAUvbE1OLY+jpEp4vLMack38NTQRJV7Bnrb7ZNKSbaEGsvu1r5AVFF5liG3ucJ+6uXX7dZN1JEOTlJ9pbSrJU7SK33GkPq8NXu+r2wVYAt1VgQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ar6YnfNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ar6YnfNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B1CC4CEED;
	Mon, 10 Mar 2025 17:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627752;
	bh=zQIig8y4PsNpB79LSA9qqS8FSPZIc6uGI70w9EFAgMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ar6YnfNytIHrZdAmpb1VqzYjg88xvuC4meW8yvRl93me9pysXmbqkSbtE6bjxm1OF
	 8TWq5jmd1bOz9U6NUZJVJwOG8kQdrkICzHUaHo1jQiThvlf4QGGBUae4d4tHPpUkVP
	 gU6P+VtWgBRuqJJL/vzNkGyfH73ZzYoaZy81/y2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Qiu-ji Chen <chenqiuji666@gmail.com>
Subject: [PATCH 6.12 237/269] cdx: Fix possible UAF error in driver_override_show()
Date: Mon, 10 Mar 2025 18:06:30 +0100
Message-ID: <20250310170507.130186508@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit 91d44c1afc61a2fec37a9c7a3485368309391e0b upstream.

Fixed a possible UAF problem in driver_override_show() in drivers/cdx/cdx.c

This function driver_override_show() is part of DEVICE_ATTR_RW, which
includes both driver_override_show() and driver_override_store().
These functions can be executed concurrently in sysfs.

The driver_override_store() function uses driver_set_override() to
update the driver_override value, and driver_set_override() internally
locks the device (device_lock(dev)). If driver_override_show() reads
cdx_dev->driver_override without locking, it could potentially access
a freed pointer if driver_override_store() frees the string
concurrently. This could lead to printing a kernel address, which is a
security risk since DEVICE_ATTR can be read by all users.

Additionally, a similar pattern is used in drivers/amba/bus.c, as well
as many other bus drivers, where device_lock() is taken in the show
function, and it has been working without issues.

This potential bug was detected by our experimental static analysis
tool, which analyzes locking APIs and paired functions to identify
data races and atomicity violations.

Fixes: 1f86a00c1159 ("bus/fsl-mc: add support for 'driver_override' in the mc-bus")
Cc: stable <stable@kernel.org>
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Link: https://lore.kernel.org/r/20250118070833.27201-1-chenqiuji666@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdx/cdx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -470,8 +470,12 @@ static ssize_t driver_override_show(stru
 				    struct device_attribute *attr, char *buf)
 {
 	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	ssize_t len;
 
-	return sysfs_emit(buf, "%s\n", cdx_dev->driver_override);
+	device_lock(dev);
+	len = sysfs_emit(buf, "%s\n", cdx_dev->driver_override);
+	device_unlock(dev);
+	return len;
 }
 static DEVICE_ATTR_RW(driver_override);
 


