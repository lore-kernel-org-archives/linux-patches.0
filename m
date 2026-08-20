Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED977377AAB;
	Thu, 20 Aug 2026 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239489; cv=none; b=NAfbzmup2P9Jyj+XCnSAgvpCWgRtkZn1tjmeZkhJSlH1DVbI6hhRfPGKcLdvt7b4rMSE681GfJ4TjFds+/elX16r62fBNz61iuGQDJd6dGA8OCwmOf3baEc5phcvNBP4ANxMgrmuMfKlA4Tn/RO+On5VqlLG0vVvWdfzL4+4ZDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239489; c=relaxed/simple;
	bh=UB7kukUAwb79g8dB7/bBE4ewEkB7dA39tyfei3eEHHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kQ2VS8p3X5GrTeSFa31cLucWo+xxpy51ZR2MBk5AfvM/5GeNddH9HcpSDfobzJND0rFYlNUteKOxDmMLhnUNcYUatxFWOD+YEEBr3VYnq6j6+PGmBmhPKDCLIID5qmXaV0S9EIFx93HdZhnqeHG5GMPA7LPZgAZ2vMFOhe5mn7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pzl53vMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pzl53vMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22C61F000E9;
	Thu, 20 Aug 2026 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239487;
	bh=0KKrJdLa8r9lnhhiKMnby3LpB/w8yYQzWVwCpM/hsqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pzl53vMYayl6oD8WOaQzbXPsKrJO5qMiRMY3eKsE1WcCDTqHDP+K5biXJ0XSLvUwc
	 iytGEPEdbrx+6WGeLpFSrA9KuVV1yCdmfYLv7c7q5lTM3Jo7ZGb0ii0c5KWD5VOWL1
	 6yOjtMa4wNyQeu7OxwrqCOpzUvIbiahpBv5s+dWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Daniel Stone <daniel@fooishbar.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	dri-devel@lists.freedesktop.org,
	John Harrison <John.Harrison@Igalia.com>
Subject: [PATCH 6.12 067/220] drm/connector/hdmi: Fix out of bounds memory read
Date: Thu, 20 Aug 2026 16:54:17 +0200
Message-ID: <20260820145225.500940871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Harrison <John.Harrison@Igalia.com>

commit 9ecf8ba763d0ffe0673538eb4bf7806f20455d19 upstream.

A helper function was copying a given audio infoframe into the
connector's copy but using the size of the destination (a generic
target, sized to accept many different data blocks) not the source (a
very specific type of data block). Thus, it was copying 60 bytes of
data from a 28 byte allocation.

Fix that by using the source size instead, together with a build bug
on the source size actually being smaller than the destination.

I hit this running KUnit tests under KASAN (while debugging something
else entirely). In the real world, it seems unlikely to cause an
actual problem. It is a read not a write so it can't corrupt any
memory. However, it could potentially fall off the end of a page and
cause an accvio bug.

Fixes: f378b77227bc ("drm/connector: hdmi: Add Infoframes generation")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Daniel Stone <daniel@fooishbar.org>
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: José Expósito <jose.exposito89@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org # v6.11+
Signed-off-by: John Harrison <John.Harrison@Igalia.com>
Link: https://patch.msgid.link/20260723220652.533345-1-John.Harrison@Igalia.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_hdmi_state_helper.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_hdmi_state_helper.c
+++ b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
@@ -710,7 +710,8 @@ drm_atomic_helper_connector_hdmi_update_
 
 	mutex_lock(&connector->hdmi.infoframes.lock);
 
-	memcpy(&infoframe->data, frame, sizeof(infoframe->data));
+	BUILD_BUG_ON(sizeof(*frame) > sizeof(infoframe->data));
+	memcpy(&infoframe->data, frame, sizeof(*frame));
 	infoframe->set = true;
 
 	ret = write_infoframe(connector, infoframe);


