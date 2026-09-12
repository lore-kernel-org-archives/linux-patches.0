Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A77325726;
	Sat, 12 Sep 2026 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232848; cv=none; b=Iyh4H6/hX/xVE6FRb2g2E4DSr6rcD0QydOgwqh97q38TNrPca8vctgEBfMVxZL6EDdblb5J2vloVfdEPum7gUY6rAyT8yqE/pXHd1hvhxTZRwWK7AAZURX1qQmiTEDJ0PymPpvu/cS19WkgYQk4akc/KTJXuIn1SeuN1G4UJt6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232848; c=relaxed/simple;
	bh=/v+LNQLJcwZ/tC2QXuLvdD55AQHsQEoz8fqUfpoPHyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JN99PazpVfZ5uAlJaKPPsgCYdFcLwZ/lCQX6DknRhN+lntd/6caT/zqqCUwcGqmvkyZ9HcmkFYTuxSCtHNCDJSVYK0kOp9pS0ZsIw35mkPWPmOlSeh+u/UC0PU/NSRCOXOfJI8aF7LO/392vHbvS1HBJzfimLzXRnEow0b07Y7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUzwzAgs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUzwzAgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D79B1F000FF;
	Sat, 12 Sep 2026 17:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232847;
	bh=yEXQIRUdhGQreewgQxvepHEYwn3t3y6P2DFYKdRi5b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUzwzAgsZbrJ42eASvEMB47C9hVJJEmmVDzhsiLZDx81z2s0Df5SK10RjW2H2uHlv
	 9CWXsfw0NGzer5Wiyk2zFVVrQ4kA4cj1Ektwk7GjB8+hzZ0vQYwto7JsOutuGqlRSU
	 AQzkfJGNURBBWO2V/r9680Acw9Lr41QldJtpaC3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 077/935] fbdev: uvesafb: unregister connector callback on init failure
Date: Sat, 12 Sep 2026 08:51:47 +0200
Message-ID: <20260912065528.598552083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


