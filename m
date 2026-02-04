Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B7264614;
	Wed,  4 Feb 2026 14:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216571; cv=none; b=O5ito/kivJodTXe+alnXlY6wU80ahBfFp+lZ9kYyRUX4FXMXMgn7eCZrt0l9vJTQZBietXxkGNKzdyTSr5ZWn9WaJD7iJRCDEmtB8slwSKfPzzPbgdYLEC6yvNT/kCLIvEFAxzipQTL4yqXFw59fk3+GAC3Tpwc9DHbvmpI8P8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216571; c=relaxed/simple;
	bh=njnCx6/HWwg1QMrz4P0S08x60xhDYD5edcFR2DmY2xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kpz6mv3RgLWlNaac0u2UOcAa6TWMg5V/fZRNnKMXakDiCWpreFW4tbgPF0DPkmFWXWZsjkV1jRy46WngTGDGQ/1gmv0assz+D8a+e34E+DLsYr0NNgHJ8YUHyTTg1tp8UBTaDfJGG0h/BSc9VgKV8mLcHVQ+E0UvhOs5zYcKtGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xA556TiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xA556TiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C7C4CEF7;
	Wed,  4 Feb 2026 14:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216571;
	bh=njnCx6/HWwg1QMrz4P0S08x60xhDYD5edcFR2DmY2xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xA556TiI3pyeERiW2Hzs2ptwHIM0RE4I7yRTmIpv6FKrW8BEel6qPYijQsWx7oj7C
	 aTcoyPk1DISlMehXbwu6gywVrPK/w3OwyQM3cCQFDZigzDYjm4K8WLsIw1sHCWg58r
	 mZJGJ9Qfuv2jmf/1zLYx6yCtyOXFWVM9yV6kuVuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 100/161] slimbus: core: fix device reference leak on report present
Date: Wed,  4 Feb 2026 15:39:23 +0100
Message-ID: <20260204143855.343650030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 9391380eb91ea5ac792aae9273535c8da5b9aa01 upstream.

Slimbus devices can be allocated dynamically upon reception of
report-present messages.

Make sure to drop the reference taken when looking up already registered
devices.

Note that this requires taking an extra reference in case the device has
not yet been registered and has to be allocated.

Fixes: 46a2bb5a7f7e ("slimbus: core: Add slim controllers support")
Cc: stable@vger.kernel.org	# 4.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251126145329.5022-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -380,6 +380,8 @@ struct slim_device *slim_get_device(stru
 		sbdev = slim_alloc_device(ctrl, e_addr, NULL);
 		if (!sbdev)
 			return ERR_PTR(-ENOMEM);
+
+		get_device(&sbdev->dev);
 	}
 
 	return sbdev;
@@ -514,6 +516,7 @@ int slim_device_report_present(struct sl
 		ret = slim_device_alloc_laddr(sbdev, true);
 	}
 
+	put_device(&sbdev->dev);
 out_put_rpm:
 	pm_runtime_mark_last_busy(ctrl->dev);
 	pm_runtime_put_autosuspend(ctrl->dev);


