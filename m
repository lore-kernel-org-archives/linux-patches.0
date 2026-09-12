Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED8B2E92BA;
	Sat, 12 Sep 2026 19:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241103; cv=none; b=pSlbeoXQhEJC0x3FHtpcphry3GUGhzoYQfL+5Lh2LB/lCNnjGZv4L2FvfW/mxd4vv625znBt7a454Nah6rTi2Q4dP5rnot1mwqgQpIXhvfSQkmgYi89OCz8em4pMhsma1FClR4CWirHsAo+6V8rAuZvB482TvQpmGmTgK5QLJok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241103; c=relaxed/simple;
	bh=udp/oJSNtTB/1S8LapO0DyeJ1A39onAMWMA7CwL3Soc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oT5ZWcOIWl4NGIAl2E3TnRamBn3Uc+wboe5rxLUYDAGOSMAaE/pCpjoifNm4ccy22B0ZDm+ooTKR3orMWjtsOciGznn1WHFZBWvY/Pr9G2bdoFF4VK63ayL4bBr16TbOUOWIU8yxTeokp/+JmqmIiZTMCIhEAlTcgQpbUNZtd0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6J0rXQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6J0rXQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500B71F000FF;
	Sat, 12 Sep 2026 19:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241102;
	bh=4dKJkMXDFnzmo7c/2omN4svIoenJCifcXtXTlpJsP4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6J0rXQHQ0Xnk0rqBqzmt/yiHlCWhfXDOtyCkoX+Ss7V0rxxZj/4KbDcCAu3Id88S
	 w/jhwrvh5UY7cM3W3iPFazi0CG7qa2qwnyBgzpbTqz5bDzWthxLa565TBvC4FXiNoO
	 OvzIgRbf51mBiPdMHqT4EUG/Dl7oLZLLXVrwH8qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 068/798] fbdev: uvesafb: unregister connector callback on init failure
Date: Sat, 12 Sep 2026 08:54:56 +0200
Message-ID: <20260912065518.523052242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1915,6 +1915,8 @@ static int uvesafb_init(void)
 			err = 0;
 		}
 	}
+	if (err)
+		cn_del_callback(&uvesafb_cn_id);
 	return err;
 }
 


