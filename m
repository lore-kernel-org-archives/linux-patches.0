Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF62629A1;
	Tue, 17 Feb 2026 20:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361173; cv=none; b=l5dhk62p19npTvDspGBXazFWDEGeGkzfKHkvdiep+HjFI3vnTlm/YslJZfJh1/B3BfYDgkNN6fWm+OQo/h+WpGCDx37gluhiO5/yzykw3IpmGRDSsqAuQ4dzw42NDN3FesCSmz7X52cI4lg33p/CUD92ILD7sxvPVwWpNrg3XLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361173; c=relaxed/simple;
	bh=uFsrjYsbjrqjo3ADD2Qydm5Q0kGMoFu51eZTQmCfa3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DX/765mf3oDU7zx+N+evfXnsjvHLzy3JBi/EgkWB3stBwFbCqzFTEzmMcAvw3uOivXIdb+w7cjXhRU8yOfi+rLDUCNpfNmd1aVSj9FDZETeFe5pqAOBhXHn1nTv6Y6sVzJo5GwueFddwxYEekvpct0APeA1yjIvTUfdFDYKHOXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3/wMcyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3/wMcyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F59C4CEF7;
	Tue, 17 Feb 2026 20:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361172;
	bh=uFsrjYsbjrqjo3ADD2Qydm5Q0kGMoFu51eZTQmCfa3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3/wMcyw7LbKK6+l25BzIhV2sM/9dN0XkdY1I+D6UXb5aRW5RjNabeWQ13SR9qZLA
	 E7CuHOBi1POTLRXwd8+WsdTVJUIslAjtsxgC0qrfqDzmfZUfDyBDEz1dauUSPIk/4w
	 IAzZReRH5ZZYHXB8bLGrR36pNbYxs1VPa5jOoaIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/64] bus: fsl-mc: fix use-after-free in driver_override_show()
Date: Tue, 17 Feb 2026 21:31:18 +0100
Message-ID: <20260217200008.349898044@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 148891e95014b5dc5878acefa57f1940c281c431 ]

The driver_override_show() function reads the driver_override string
without holding the device_lock. However, driver_override_store() uses
driver_set_override(), which modifies and frees the string while holding
the device_lock.

This can result in a concurrent use-after-free if the string is freed
by the store function while being read by the show function.

Fix this by holding the device_lock around the read operation.

Fixes: 1f86a00c1159 ("bus/fsl-mc: add support for 'driver_override' in the mc-bus")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20251202174438.12658-1-hanguidong02@gmail.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -201,8 +201,12 @@ static ssize_t driver_override_show(stru
 				    struct device_attribute *attr, char *buf)
 {
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	ssize_t len;
 
-	return sysfs_emit(buf, "%s\n", mc_dev->driver_override);
+	device_lock(dev);
+	len = sysfs_emit(buf, "%s\n", mc_dev->driver_override);
+	device_unlock(dev);
+	return len;
 }
 static DEVICE_ATTR_RW(driver_override);
 


