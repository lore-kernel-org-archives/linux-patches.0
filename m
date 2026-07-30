Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B33769FD;
	Thu, 30 Jul 2026 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426068; cv=none; b=QXnqdXlh2PWCyyDr5ezrXiVcMShyzWwOaS+CYbmt2PVxcNVyouFAd1u07z9fW8kAwZSya0s3sh0+JU59Qa+fL1vPn6QSFGWiScEaWB5+zTQzJ25eMFuPwqFwzLNpMWenB8eo9twsAot8CuAJ1QTLFYF0sQLZIkX6eWoxkBFYIu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426068; c=relaxed/simple;
	bh=V05g9qddNOQ7PUX+y1WEACc01YLSy5S12LCE/DbrnBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8puVg8U/EZ1HwvoX8yz5fw41qZl/TFVxQdPKhdjse7R/1zry8dMyTAiZCX724alnciWWKElJ3IN0qvArkubt3lO7HTAJUdLUrRTv9sRUQnxk4nr/TzdMcRNO0Pn+qTUgl4gw0bH4h6EAD8xRHNnL+oaisgBjkT1yBSqSvXQIXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0Mqwp7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0Mqwp7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C64C1F000E9;
	Thu, 30 Jul 2026 15:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426066;
	bh=61ILZE3qjpzkFRauuJKIZi/f9+CvE40phf+06ITvWvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0Mqwp7HsCW7XPpwuav/A6bd2Ep9Dc0obceqtRBirAwpXY1adklnGz+FDmFNUPKnh
	 Bx6OZ9Jtz8zVhqX4lI5+oO0hf21YfZXwkXEu5F+rwMOG+I37buMqdgsYJHeOisaIlo
	 0QN/sHD/HPFDatAxxumKf1NNa30rtwFzBLd6RNrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.12 290/602] drm/panthor: return error on truncated firmware
Date: Thu, 30 Jul 2026 16:11:22 +0200
Message-ID: <20260730141442.065596199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 4a2c8cbe9bcba170706fdf08b1c84b6cbcf5b044 upstream.

panthor_fw_load() detects truncated firmware images, but jumps to the
common cleanup path without setting ret. If no previous error was recorded,
the function can return 0 and treat the invalid firmware as successfully
loaded.

Set ret to -EINVAL before leaving the truncated-image path.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260714163056.22329-1-osama.abdelkader@gmail.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -732,6 +732,7 @@ static int panthor_fw_load(struct pantho
 	}
 
 	if (hdr.size > iter.size) {
+		ret = -EINVAL;
 		drm_err(&ptdev->base, "Firmware image is truncated\n");
 		goto out;
 	}


