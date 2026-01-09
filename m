Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA8E3590C6;
	Fri,  9 Jan 2026 12:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962784; cv=none; b=RsbvFJlHwSksDvr8KPU7FVYCxoWQYakTvovqy7lw8vKBwJK7fIbASMh5EfY9zh2ZbG7KEJKKNeMVqH2+HxsY0a8aKdIMjX8DzW4vAnwr94SH0n5DPTMcu4vLyI3Pt3q4eQptark/30tvSnTguZuYbt/k8h1clyFkTxjJUTlmQRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962784; c=relaxed/simple;
	bh=UJ0bD7WVI4/ZRDDP3ObENUBCz9jbW0sAMewh5pVegOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKz+upF6Qdr4v/3TRtFvg8ZjENFKRZJngteSKA4OqUxOg4wBRl/+vDr1JhIYOjbOAgQUQuVJ8Kb3C7MGoC2uzHfa7VY4CmNKY9UblCezFn7bTm5uUHB8vC67ZFotoXd07XKMUcU1K5OsDVBUDVNZafWtFYVC4ZHr+e3O3vZy4Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVDzsQ67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVDzsQ67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE291C4CEF1;
	Fri,  9 Jan 2026 12:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962784;
	bh=UJ0bD7WVI4/ZRDDP3ObENUBCz9jbW0sAMewh5pVegOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVDzsQ67y8+/4qYpKotYuEKOADkGfGKUkRLzlFBfbDi4mOFiQpmR/D9v1+xuav3RM
	 HtHeDxWmxcOJW8BGa9caJs+DeDgVN7PEnNiIUr1pOI6J+QzSHtbekvJLJ84h41Qs5h
	 XZvRop//tMgHyCnGszyWlcGFx537QJ0ElmTAfKTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 485/634] media: vpif_capture: fix section mismatch
Date: Fri,  9 Jan 2026 12:42:43 +0100
Message-ID: <20260109112135.794929651@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 0ef841113724166c3c484d0e9ae6db1eb5634fde upstream.

Platform drivers can be probed after their init sections have been
discarded (e.g. on probe deferral or manual rebind through sysfs) so the
probe function must not live in init.

Note that commit ffa1b391c61b ("V4L/DVB: vpif_cap/disp: Removed section
mismatch warning") incorrectly suppressed the modpost warning.

Fixes: ffa1b391c61b ("V4L/DVB: vpif_cap/disp: Removed section mismatch warning")
Fixes: 6ffefff5a9e7 ("V4L/DVB (12906c): V4L : vpif capture driver for DM6467")
Cc: stable@vger.kernel.org	# 2.6.32
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1601,7 +1601,7 @@ err_cleanup:
  * This creates device entries by register itself to the V4L2 driver and
  * initializes fields of each channel objects
  */
-static __init int vpif_probe(struct platform_device *pdev)
+static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct i2c_adapter *i2c_adap;
@@ -1809,7 +1809,7 @@ static int vpif_resume(struct device *de
 
 static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
 
-static __refdata struct platform_driver vpif_driver = {
+static struct platform_driver vpif_driver = {
 	.driver	= {
 		.name	= VPIF_DRIVER_NAME,
 		.pm	= &vpif_pm_ops,


