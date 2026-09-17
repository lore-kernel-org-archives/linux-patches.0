Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A214EF140;
	Thu, 17 Sep 2026 16:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663918; cv=none; b=SmLe5rdu7ezyMI/cBjagdK4+qj5IpC33iJsFCZO/MqrXR4W6oqHP/V3A21qkL39bGfEavnGx4VDh+Wmk9V2BVvAh9IgJQ/YHjim/AUAWz/gV5sRN+eXFQ3aLIWq6OnInCtG67Y3T4R5NNB5qdzaejm8SGlGyIejcj81JqYzXaco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663918; c=relaxed/simple;
	bh=4ufAx9c70rjsAvj4OtshA/EJFFh3vCvdhCn0CUYqvqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcDzbLzUVPxC0oG+wNQ7vlJYvfDBb6tqRTWZ/3qymsT99pU1wdbJ/UmcUaM6kLbiRBBLEJxc8LoegP36CYyAnxMkCwK0gDkBbW3Vx+qxMtCQUgthc/PhfXpON83QpyCtwHPy2pUpnJ6HwUChBjQHk2R7oG7kyV5wshzJ2TSk/lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQgfxjVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQgfxjVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294E31F000FF;
	Thu, 17 Sep 2026 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663915;
	bh=N0nYWxtKOY0pzADMaMi1tZBqS/H87bcEQ6Xm1d3iAAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQgfxjVFZk4GnP9C2Sg7etv+0FgcM4nCWxOQHVQ4Ok/GckHDhGh2dXQiA8mxgQgBK
	 dDYfK56xRmDpGTZAUILCA+mOhcA0uhPwPy6k2kCPl/1dE2z7f5KMRphaITFjZNxKZy
	 eXEo24C9m78ycSShKutpADxzspFpvNu6ctTJCjwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0197/1250] gpib: Suppress setting END on error from NI_USB dongle
Date: Thu, 17 Sep 2026 15:59:52 +0100
Message-ID: <20260917151557.456504194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 7c19b47f5a1839817e5ddc5ba589224fcfb6255d ]

The NI USB adapter sets the END bit in the status word when an error
occurs such as a read being interrupted by the setting of ATN. This
happens for example when a device clear is received from the
controller in charge during a read.

The common driver changes the error return to 0 whenever the END bit
is set in order to avoid errors such as timeout or interrupt to be
reported after the full message has actually been read. The behaviour
of the NI USB adapter in setting the END bit on errors was causing
actual errors (-EINTR, -ETIMEDOUT) not to be reported.

We avoid setting the END bit in the ni_usb_gpib driver when an error
is reported in error_code of the status from the adaptor.

Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://patch.msgid.link/20260422074807.3194-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
index b6fddb437f552..67cc3398e2831 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -720,7 +720,7 @@ static int ni_usb_read(struct gpib_board *board, u8 *buffer, size_t length,
 		break;
 	}
 	ni_usb_soft_update_status(board, status.ibsta, 0);
-	if (status.ibsta & END)
+	if ((status.ibsta & END) && (status.error_code == NIUSB_NO_ERROR))
 		*end = 1;
 	else
 		*end = 0;
-- 
2.53.0



