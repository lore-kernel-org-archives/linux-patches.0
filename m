Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B3635C195;
	Fri,  9 Jan 2026 12:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962727; cv=none; b=No8vFgQF+wUsWwiAIsK+X/up/RKXynuJNB/8Opt/anrWz4mFgTl4w3EatJEdphoj92btKn1nOPUyjfKfohzH9moV8YGX/rOqg/Ihh5oXCaK4kiaHpqidoDd0wtB5hx191nm63ExPooTl98KX80M7MSdN6pK01Pbn2w6baWo/R1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962727; c=relaxed/simple;
	bh=9GNkYbypoitebq+3D7l9GiczlPfb43Rcy2OS0UTs48Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk8d7ZTCyQ1J0WITEjGOA3SYLje4y0aAPphtS9eWvRSKNUNoPsEXBW0OuI5YnqClxjpfD2eCDEZXDUy9PNe0GG/pe0C4KZpaeJGHFLhz6W/ujchzZeQUcr68XeqW+5o3TtfJI8n9llu3Q4Nn5JVlZ8irZ2zze0vcl9KpLwASHZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVhbaYs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVhbaYs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD241C19421;
	Fri,  9 Jan 2026 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962727;
	bh=9GNkYbypoitebq+3D7l9GiczlPfb43Rcy2OS0UTs48Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVhbaYs9P4pK61/qQTx3ifJGfhbXZ1sTD3PXxkOkBzgdQ3zFA2a/hsEHin33ZXPg4
	 pEo85kSLbUG8rm1Gfm3Fivw8Ya/qMGd9f21fLaJ0YlftSOWWG1PrNBRy3QfSL6/MtZ
	 pnxbbGnLvZ1IYzRB1PZ85aWcZ6weZ/6Oi5l+uvdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 467/634] media: rc: st_rc: Fix reset control resource leak
Date: Fri,  9 Jan 2026 12:42:25 +0100
Message-ID: <20260109112135.121917918@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit 1240abf4b71f632f0117b056e22488e4d9808938 upstream.

The driver calls reset_control_get_optional_exclusive() but never calls
reset_control_put() in error paths or in the remove function. This causes
a resource leak when probe fails after successfully acquiring the reset
control, or when the driver is unloaded.

Switch to devm_reset_control_get_optional_exclusive() to automatically
manage the reset control resource.

Fixes: a4b80242d046 ("media: st-rc: explicitly request exclusive reset control")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/st_rc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -284,7 +284,7 @@ static int st_rc_probe(struct platform_d
 	else
 		rc_dev->rx_base = rc_dev->base;
 
-	rc_dev->rstc = reset_control_get_optional_exclusive(dev, NULL);
+	rc_dev->rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
 	if (IS_ERR(rc_dev->rstc)) {
 		ret = PTR_ERR(rc_dev->rstc);
 		goto err;


