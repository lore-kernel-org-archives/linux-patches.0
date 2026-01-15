Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470443D3494;
	Thu, 15 Jan 2026 17:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499935; cv=none; b=IXtXIWsFFlEOSqnzoaHux/ad09Pky1ydYsQRJ3ro3fqcJl5nQEjE+UGIB+/7dh5HPMITyU53IKuiUceWFbsoURDd/iJ2N3p5TX7qNAFvqyMK/lRyFAh0hUZTd6NrLNLBEqZQb52SI3uE9dcWB3QZKpW89+h8OBxGTApigwSGL/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499935; c=relaxed/simple;
	bh=ydMweBr52lkpEG0wlYH+Sv+71MPFny81MquJVaVxB6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSjq+p4fzbGY3iOIcOZ3/jbYfWgJOTqFr8Akqc8/19XbYAsv673sCpy2HTnXaC1eHYMqWtXUngYb7KHDNW2HXVMXMESYmsRAH62lu9SE+AxkKIMEqxDptUns0TvJH0magbUMr2x+GYFg/GqvQewBFgWVEGLrxcjaOBy4gDuDoVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8AM9ZYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8AM9ZYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0BCC116D0;
	Thu, 15 Jan 2026 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499935;
	bh=ydMweBr52lkpEG0wlYH+Sv+71MPFny81MquJVaVxB6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8AM9ZYJUZTAqOmf1betavNv+UuFjXEtqMxkAV8aTojlk/4sFzkgzJECAucA8MpDU
	 zNsILdSbOK2bSpXwEACJrCfNjHTChJQjOlIi49ZeArWs86/sU4BzZwZn9ca8N4oevd
	 JJGNVAPK+SLwDTBbeo4YLnSd3ZDfyTrOncDGFfwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.10 400/451] bus: fsl-mc-bus: fix KASAN use-after-free in fsl_mc_bus_remove()
Date: Thu, 15 Jan 2026 17:50:01 +0100
Message-ID: <20260115164245.407769284@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 928ea98252ad75118950941683893cf904541da9 upstream.

In fsl_mc_bus_remove(), mc->root_mc_bus_dev->mc_io is passed to
fsl_destroy_mc_io(). However, mc->root_mc_bus_dev is already freed in
fsl_mc_device_remove(). Then reference to mc->root_mc_bus_dev->mc_io
triggers KASAN use-after-free. To avoid the use-after-free, keep the
reference to mc->root_mc_bus_dev->mc_io in a local variable and pass to
fsl_destroy_mc_io().

This patch needs rework to apply to kernels older than v5.15.

Fixes: f93627146f0e ("staging: fsl-mc: fix asymmetry in destroy of mc_io")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20220601105159.87752-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Keerthana: Backported the patch to v5.10.y ]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -1085,14 +1085,14 @@ error_cleanup_mc_io:
 static int fsl_mc_bus_remove(struct platform_device *pdev)
 {
 	struct fsl_mc *mc = platform_get_drvdata(pdev);
+	struct fsl_mc_io *mc_io;
 
 	if (!fsl_mc_is_root_dprc(&mc->root_mc_bus_dev->dev))
 		return -EINVAL;
 
+	mc_io = mc->root_mc_bus_dev->mc_io;
 	fsl_mc_device_remove(mc->root_mc_bus_dev);
-
-	fsl_destroy_mc_io(mc->root_mc_bus_dev->mc_io);
-	mc->root_mc_bus_dev->mc_io = NULL;
+	fsl_destroy_mc_io(mc_io);
 
 	return 0;
 }


