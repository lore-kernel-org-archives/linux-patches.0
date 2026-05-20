Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CB63F9F2D;
	Wed, 20 May 2026 18:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301677; cv=none; b=RZw0z+B1qqAiUgyHn4zWL+eBJpuPBNKLJMuN6SWrFFLeCyQMr0nuAPOyvdjIxEaTEeq1KhYwQpDv54N00Yz8i7N5my8qUSXfQlHRmDNzapISqi7Y7JWAJSKH5+I2JknN+QO+4nOWtl51BaxhNEh10zs5BHJ86Wzn+6xlMRbT28U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301677; c=relaxed/simple;
	bh=4x3jn3w9ml+mW63lPbCil1Fft2r1J3kblC7ucOwQLL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/jEt9JC6ogffxwyjs6UsTTnsRJRDYFZZ0PsME5agtQ0IXiTeMyvJOCiIsCOR8O6xJ0KGK5l4livz+hBIYzQrTg/LFUdYfK0vG88FxB2vgspXceD0o1458aOVDk2oduh64PEm2OJI+yE0Q8FnG7594g50CfyqG7TrADwCetWtqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/hTP9GY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/hTP9GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642301F000E9;
	Wed, 20 May 2026 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301675;
	bh=Veg+9/5sXcpvFpgSUgqFWDtJCzg6w1svKcQkKNNDk58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/hTP9GY3bMrPPItWHX/S7LFfaHfpeB0v1LAn19MbZfIzgSeXA2ag8RHKNG0N4mX5
	 lD/T+fWX+WXX6z95a0cUhSl9PUbyDRkqcskSRFrFN4gmLYmWp1TTsW3cy/oWb1QEnF
	 r0Z+LNQMaHTtR4yz9QRWopkQ4oCph00Q+C/02Mbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.12 644/666] drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup
Date: Wed, 20 May 2026 18:24:15 +0200
Message-ID: <20260520162125.238992296@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
@@ -579,6 +579,7 @@ static int oaktrail_hdmi_get_modes(struc
 	} else {
 		edid = (struct edid *)raw_edid;
 		/* FIXME ? edid = drm_get_edid(connector, i2c_adap); */
+		i2c_put_adapter(i2c_adap);
 	}
 
 	if (edid) {


