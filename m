Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB09C3F4101;
	Fri,  4 Sep 2026 06:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502263; cv=none; b=N2G8v0JKdcbkRr+1zKxk4kY4mLctFhn7nYAPDXsG2yk056xKQkb5/1D4m0ZDIX2PzSlomhpOjNuwTVfETV8lqm/FKrxqloSofR6tqaYZVE7Of4DBHYIayN/YsbPUBZyw6QRbPiPfA4vUzq8MsJpAuquJT5tkvl5Mx6uaQ0MqpLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502263; c=relaxed/simple;
	bh=WItuG993qSc+sUyZB6uOPBepl3yPvZ4slyMIJFR4PIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoXA+fHzrw+IGqwkT+VYACGxd59DECYY8Igpzsuq3vFYnRl1ahrxTfMh58g1og0RfRqUjAdyc2CZe1RmHTv5u2aW2LIpQb6uvMl9PUT7ObtkvXXM7ptcRY5k/JRsJpQG4O90b/wMuWFBpnOYfAtfjDGpYReLsHg1/gj2DXNy09E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U57LvBgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U57LvBgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7A81F00A3D;
	Fri,  4 Sep 2026 06:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502262;
	bh=mVHUsrwbdjAyWrNdChFig436tlxavIYR33khYOnvlf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U57LvBgn5XeScKKhpoeoaNr9P79wxJ+V+uqgjj0UKxqisgfE9Cdj4PodQl8H8F4J5
	 UsKcU3hF4WHdAvnREpRpFrIjQrelD55s3e7VPdxBrUTyWQPyuRGoAfmtULdEy+PIin
	 kRhceKkBtz9LjKu/mKJvQEIO/ziyw3Xsk3uVKruY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 147/403] fbdev: uvesafb: unregister connector callback on init failure
Date: Fri,  4 Sep 2026 06:59:10 +0200
Message-ID: <20260904045738.190243992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1910,6 +1910,8 @@ static int uvesafb_init(void)
 			err = 0;
 		}
 	}
+	if (err)
+		cn_del_callback(&uvesafb_cn_id);
 	return err;
 }
 


