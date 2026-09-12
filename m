Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12709349CC1;
	Sat, 12 Sep 2026 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227000; cv=none; b=pEOz+naH82icZbcDT/cgclcJFant6m1CduwxH0MZWma43saXls2jEdP7OJcqfgrI475CNo8E2lz9Vz0WNTOgkSw2n9F6xIHBFtikne+MnjOeOwuQtpxQmjpFzLmqncjG6LJ9cacyj1aysZEUPX8FvY4DizY3Fq+fuA2JSt8Z7hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227000; c=relaxed/simple;
	bh=SvBcszFFdyATnXcM2vahiEHFD1pvKCr0OcIbm5S/AP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkvc5hPLHEaKwtL9fMdy9+8HmPqbEYTuocYbjHmyHEUup3S0YQMW6ves29qVv6Fqj2NcakTvv3wHOmKQrNhXOylGl2/tkX5cBX+GBuamfkndHu0msni1mRKXBx/Obktl9g/OVQkByAJPjx5MlIkEzrOY9qjPFMEURDtQh5QGq8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTKPjp5P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTKPjp5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14CD1F00898;
	Sat, 12 Sep 2026 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226992;
	bh=146cPWetcxU9YDlp+VAJpLhIYpyKgBZxNtsVVNzV58U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTKPjp5P5jQfLqzk4Vkmn287z94coyQiGSu2DBvmQIWd+8HGgPgtWheRYSZFBWcs4
	 CN+IfSGdSeex1MLwdLEnIIkuM1EKGXT7dIrJti+T8OC5kB0we6w9qZFiaXQHwId7G3
	 VvRLwm978k8nJjhsNGrte87KLpie0//USOs+G+xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0089/1191] fbdev: uvesafb: unregister connector callback on init failure
Date: Sat, 12 Sep 2026 08:46:57 +0200
Message-ID: <20260912065550.177947596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit de8db23aa7c337e606fca9faf48b3ba72968597a upstream.

uvesafb_init() registers the v86d connector callback before registering
the platform driver. If platform_driver_register() fails, the function
returns the error directly and leaves the connector callback registered.

The later platform-device failure path already unregisters the callback.
Add the same cleanup before the final return when platform-driver
registration fails.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/uvesafb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1917,6 +1917,8 @@ static int uvesafb_init(void)
 			err = 0;
 		}
 	}
+	if (err)
+		cn_del_callback(&uvesafb_cn_id);
 	return err;
 }
 


