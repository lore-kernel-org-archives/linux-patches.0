Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFFF3563C3;
	Fri, 13 Feb 2026 13:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990684; cv=none; b=YDa1xZErmgT7KJU9XublJ95AGZ5hfaPb+aUa6ndMXTfspOfcCslTOXzUcoSvmjHL5DsfgBWelKIghoGN6EdnpfSsull/U3GY3DRS6glw2ReYEliwZMVwnSgUYWNVSCtkJlsLyz6w3I77Nmy1Fw2WxYGdxcNq07PJs3xDiE401MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990684; c=relaxed/simple;
	bh=lMXBKBZIx/i/uU8NO+1FMxf2DJd7KhyabLDTLMZmJxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGHIjy4oP3w0tBnsWKzje4V3AV9n7llWf+qE4PU561yvfEDhlWKnoKq25Tgqxle7H41LNaVFUZefRWks5NZ6hv8jeJXcgTWRu43mbCxqArIFZmlWGz2cJyZnRWwatzLwXGNcmrlPcsJPVkr/FEoie/p3F2QCHdjy9czGEcNN3Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiwaaFD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiwaaFD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BE5C116C6;
	Fri, 13 Feb 2026 13:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990684;
	bh=lMXBKBZIx/i/uU8NO+1FMxf2DJd7KhyabLDTLMZmJxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiwaaFD/gk+2gOG9zTefD+7EtJ7uJkQDwduIckAosT3vh+GLajozGgr2G1zlB3dGB
	 SprIaOw9F6DeBu6UGYMNHE1/eG9Rln1e0w9AEtIKFeuzSNK9FIYg/j8w6KvNNwmMre
	 xxLjwC7eFoPusbYBRaJE2c048VSHlzdgkJPwJZ2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: [PATCH 6.19 44/49] bus: fsl-mc: fix use-after-free in driver_override_show()
Date: Fri, 13 Feb 2026 14:48:03 +0100
Message-ID: <20260213134710.327717414@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

commit 148891e95014b5dc5878acefa57f1940c281c431 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -202,8 +202,12 @@ static ssize_t driver_override_show(stru
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
 


