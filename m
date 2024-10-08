Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0257A1779B1;
	Tue,  8 Oct 2024 12:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391015; cv=none; b=knx2pY9IdN5aqfUyqEoZKXXFGaRrBHIwb5Ae+UHhSIVdEHrp6b587I25xnkXif0kZStEdLf7zO2bip8F88TtZIb63C3W35RvFo+kmquzm2nUEHf6YcrFYtoSIpy9Ef3X9iARJSX1tB4YxzGpNNB8yXzktqbecP9PKjpE5RIUghY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391015; c=relaxed/simple;
	bh=7mEADpqTRikmYFfBZpHD63Xgw010CmTPQjRuBlBa6HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENlGHM/rOUBcNpmP62NIQSnHj3aEDB1wL4/z9pmYLb/JTyy3LtrLWf3sRRK6EjWDccfGy7kCvYWWRbbeZKB9PuhkdBAqgNB+wl+4y3V0MyGIgEM1gIlY6E0uK312xU4ORZADgYuz0ITHwUNC9gLwrCZ8uK8LDmkHYvIOs/sDlz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3Fet4os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3Fet4os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65504C4CEC7;
	Tue,  8 Oct 2024 12:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391014;
	bh=7mEADpqTRikmYFfBZpHD63Xgw010CmTPQjRuBlBa6HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3Fet4osbvxyJzlVq1/jDJ7Ns39gg9/WMSNud4zvBazS+46PEB0tyCzOe92OQa2aj
	 BIWIzixtANBh5f++hzxab1MaIMbbyB1TdbBKY1yQXU70XxFDtZoUfuehIIxkX1tKl4
	 D1/EYbsSwkT9KUio00+Chu3zpatqLBH5Tn6/NCw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	"Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>
Subject: [PATCH 6.10 433/482] firmware/sysfb: Disable sysfb for firmware buffers with unknown parent
Date: Tue,  8 Oct 2024 14:08:16 +0200
Message-ID: <20241008115705.561564441@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit ad604f0a4c040dcb8faf44dc72db25e457c28076 upstream.

The sysfb framebuffer handling only operates on graphics devices
that provide the system's firmware framebuffer. If that device is
not known, assume that any graphics device has been initialized by
firmware.

Fixes a problem on i915 where sysfb does not release the firmware
framebuffer after the native graphics driver loaded.

Reported-by: Borah, Chaitanya Kumar <chaitanya.kumar.borah@intel.com>
Closes: https://lore.kernel.org/dri-devel/SJ1PR11MB6129EFB8CE63D1EF6D932F94B96F2@SJ1PR11MB6129.namprd11.prod.outlook.com/
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/12160
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: b49420d6a1ae ("video/aperture: optionally match the device in sysfb_disable()")
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: dri-devel@lists.freedesktop.org
Cc: Linux regression tracking (Thorsten Leemhuis) <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org> # v6.11+
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924084227.262271-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/sysfb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index 02a07d3d0d40..a3df782fa687 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -67,9 +67,11 @@ static bool sysfb_unregister(void)
 void sysfb_disable(struct device *dev)
 {
 	struct screen_info *si = &screen_info;
+	struct device *parent;
 
 	mutex_lock(&disable_lock);
-	if (!dev || dev == sysfb_parent_dev(si)) {
+	parent = sysfb_parent_dev(si);
+	if (!dev || !parent || dev == parent) {
 		sysfb_unregister();
 		disabled = true;
 	}
-- 
2.46.2



