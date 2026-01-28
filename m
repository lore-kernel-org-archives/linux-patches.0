Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB6430F555;
	Wed, 28 Jan 2026 15:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615256; cv=none; b=PHRczBnb+lizU7iL+X2+12/ok4ye5+1LG6OuZSwdt9UgFcksBxCg4JyO9jRiEyhEdjq3JIi/3PDd1YkykC8Mh3F6Tq6W8z/2BE/WHsT8foqVOHE+ayWImVOukTIxO17UGq8FPdYQ+nqw8sPAw+j2Wm6cpCUSo5x+6lvqoep7/i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615256; c=relaxed/simple;
	bh=L5NZj+j9uX5+EiqzZ2GS3Sp2kH7vxOQJJdtoba0Aowk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcYHdaDzrgcaRYZxJPpJ06xJwldt5XAuqhCSVB9WiE+9v0BTLQ3Z32LdVMGOUSFYuVsdDtwkzK07nDRPkzlak3l4CEtgULhmzll3Jt28rJlMCLUmUq6QyDAfzLVFR63JT8pyJUAugZgo2XtG/gUZD/X6+8cnYDAeirvUNlQY5Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEB6pdPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEB6pdPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4528FC4CEF1;
	Wed, 28 Jan 2026 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615256;
	bh=L5NZj+j9uX5+EiqzZ2GS3Sp2kH7vxOQJJdtoba0Aowk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEB6pdPHddIMG0Y24174YQx9B6iO2/LQAs0ypYN5oswn68hErw2OsT7eEgj2tFyHQ
	 DmjDP0B+O9GM6TUGDnee4hN6igwk4yh4CbOPl2Il7jr/3mVKJuKFfEWWTff/YjWbSY
	 c7n9ZxavawLcbNIQWzr9GkpL8B5VCT+onkuPVa+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 125/169] slimbus: core: fix device reference leak on report present
Date: Wed, 28 Jan 2026 16:23:28 +0100
Message-ID: <20260128145338.506940615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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
@@ -378,6 +378,8 @@ struct slim_device *slim_get_device(stru
 		sbdev = slim_alloc_device(ctrl, e_addr, NULL);
 		if (!sbdev)
 			return ERR_PTR(-ENOMEM);
+
+		get_device(&sbdev->dev);
 	}
 
 	return sbdev;
@@ -512,6 +514,7 @@ int slim_device_report_present(struct sl
 		ret = slim_device_alloc_laddr(sbdev, true);
 	}
 
+	put_device(&sbdev->dev);
 out_put_rpm:
 	pm_runtime_mark_last_busy(ctrl->dev);
 	pm_runtime_put_autosuspend(ctrl->dev);


