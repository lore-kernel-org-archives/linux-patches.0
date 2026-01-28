Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296842836A6;
	Wed, 28 Jan 2026 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616025; cv=none; b=polgMdEfowOPBnInhku6jV4rcauzjUBH1gTNrA4QDxKg7sfX5ydpa4vK7AgCPJ8hFvUDKJGzCbGrptmNa677vzA4IgcctVhqGZHELLEEmcxq+rO6rsIWSJqPAeta1xVCC4LGPVp23jo6uQiz3BwqXz5JwOTMV/VfWh/nL2nL5DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616025; c=relaxed/simple;
	bh=tE6RbTjoHYbaJ1ZUdsB0SEOY09/FfAdQKp1AJFenioE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOaY2Y85Ely4v60IzohFM2aObKObCe22vNxd5UC+rXe52WzbUdwsv41OYPl2+xPvb7B5I8CAvXRR0u53tR5ZzduQ2O5w18XYfxUa/RKQGMMg37aVbevSPAzdf6MLw8UzpHtWz05eWw2+w6/J0rKRhj5obigxXQjCT1RCpA3Efyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vi2rGQNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vi2rGQNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8B8C116C6;
	Wed, 28 Jan 2026 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616025;
	bh=tE6RbTjoHYbaJ1ZUdsB0SEOY09/FfAdQKp1AJFenioE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vi2rGQNW+2d73qq7s4sLbjEltrbh+hikHZS/uEa4ASV0DrMQUbkGNFOl9Tx0KbohJ
	 dFRnLN89jHQzZ1D6jAqVH5V320mw1bJ+c5Mlafe3jPh4ywlnvXxPkwFSIkG9i9FWns
	 XP2E8srV4h0ZrbFbbHA0kf25zYeSfHbd4pzPcHUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 185/227] slimbus: core: fix device reference leak on report present
Date: Wed, 28 Jan 2026 16:23:50 +0100
Message-ID: <20260128145351.102555774@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -379,6 +379,8 @@ struct slim_device *slim_get_device(stru
 		sbdev = slim_alloc_device(ctrl, e_addr, NULL);
 		if (!sbdev)
 			return ERR_PTR(-ENOMEM);
+
+		get_device(&sbdev->dev);
 	}
 
 	return sbdev;
@@ -505,6 +507,7 @@ int slim_device_report_present(struct sl
 		ret = slim_device_alloc_laddr(sbdev, true);
 	}
 
+	put_device(&sbdev->dev);
 out_put_rpm:
 	pm_runtime_mark_last_busy(ctrl->dev);
 	pm_runtime_put_autosuspend(ctrl->dev);


