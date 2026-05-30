Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC588223DC6;
	Sat, 30 May 2026 18:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164808; cv=none; b=sU2y/4q9XS8XUpSiBP014VqyFQr+UpNlb7AKXt2AlLA5ly6DCWrVKA611ZvivysGrvH19hzcshH8ZEsCdFILFRluunTu0h3/HWHTgd9k8GLuzQh5x4r3ZlZokAgQPzVc3IhuEkE6i62krrWRnc7fXQtqZIIAOrhbO8Jlfve7eDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164808; c=relaxed/simple;
	bh=juLF78io93JXoh3xhjK3Q89mi8JsbNUgFlAoDR+B67U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2EdnkTgVBIavwsp1SOJ2AUXeteNOSWEJ6OHCRjwUJxuabSFoa0GXOb6HxusSV2FnjeJ/mPj80y0P3er5xkkylsosih3kFFrZHmAFOv+sDvvA6jHUh0w6IOkrgcz4F9hc/EV3ot0MvVKhCvPPd/qLC1k47YL3aWjQ78G1bGdqL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12ygMjw0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12ygMjw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC02E1F00893;
	Sat, 30 May 2026 18:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164807;
	bh=EpOTTqhviIte5f70qiZ/Fp9yQQrKNRbmp7E3cSOT/Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12ygMjw0k78EzSWZOw0w250aZ84Og4P6VsGT3QbWR5BE/E0R7aPUx2iEqRXi+HDy9
	 9QcqbX1u/UxScXAbx3whCLz9BerUR8q+zM0pSaSznEmUmS0co95gajA+r2WaCFdNTe
	 i2A+vaSNNwa5zexQJG/JDWjPV1ebYMZ3eeog1OVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.15 666/776] drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup
Date: Sat, 30 May 2026 18:06:20 +0200
Message-ID: <20260530160257.098920375@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 950953f774b3f69da6f413e045ef075e1f3da2df upstream.

Make sure to drop the reference taken to the I2C adapter (and its
module) when setting up HDMI to allow the adapter to be deregistered.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Cc: stable@vger.kernel.org	# 3.3
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260508144446.59722-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -576,6 +576,7 @@ static int oaktrail_hdmi_get_modes(struc
 	} else {
 		edid = (struct edid *)raw_edid;
 		/* FIXME ? edid = drm_get_edid(connector, i2c_adap); */
+		i2c_put_adapter(i2c_adap);
 	}
 
 	if (edid) {


