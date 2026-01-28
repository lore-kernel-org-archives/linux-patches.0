Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4F2286D57;
	Wed, 28 Jan 2026 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614666; cv=none; b=lh2mAYz55Gh+AaWrx1xVSdSiDcuFG+o7llyj5DBv2UORYi2fgCiBDGaM+e0Z7BJM1SAxJqR8Vb9UE8iKoZs+Cv+lXMQa2c5w/lsgvfYmspfkXgapIUZDucVhsPAu3Zw1frwonnCI6fcY7hsOU5qoN615YT6uS9t7kE5qhc6I7To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614666; c=relaxed/simple;
	bh=VmAFyCSSP0wtvS4WnaRoEskr5K3EEZ4MpHXvEdi3yeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUu+joSFUrh2myigR/po3Ue5XSA8WPiw2TxCMvf9YnLlU7l+VE7D08gTmt0LbNOiteI0FWcKN+jPxt/dU0gkzcndK3Ui5x/a2Bo/b2krf5uOsDrZKAjBrTxpQbjqZdzTQs3wCtHKrSvvy8wS3sa0gY0MJ0BnebVckULkbOFM1Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4Ti/+5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4Ti/+5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55226C4CEF1;
	Wed, 28 Jan 2026 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614666;
	bh=VmAFyCSSP0wtvS4WnaRoEskr5K3EEZ4MpHXvEdi3yeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4Ti/+5z3QhEy8rDDfORQZA1fLov+ojNgtPM4Y7HoJZcRCAopltfv/fvyGCtWWgQR
	 CFekKKlLIdw88Zc1tsgEXeK3ZsRu4KDRVYSvL9gSr+Hf0E+sR+6xAmhzaGg1/e66cP
	 dZrw2ogp0wJZ+1qwuVnU9+nzwIJE3QHazRBmI60E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 204/254] slimbus: core: fix device reference leak on report present
Date: Wed, 28 Jan 2026 16:23:00 +0100
Message-ID: <20260128145352.136262662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


