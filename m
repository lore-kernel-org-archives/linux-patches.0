Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634381CE70D;
	Tue, 27 Aug 2024 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772755; cv=none; b=hDdyEjn99Cx7+xQJkna7gTtBmDXa5thwJEEaBGsKrg8lUHK4hyy/Ehy7oo8GKWyGOplp5SpkS+j4jFjYT5EH9FL37S0wvjyXEVlDCjUx3hH2wPurMQoJrlne47VmoIki1jEQRnzyRtAr61XXwpt2iGNVs31e08wWoJmPt1nahNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772755; c=relaxed/simple;
	bh=J6r40iQXYh1go5tCYuk6gYtkuWeQ6dls26OmiAg9eZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOlymA5ep2JtGjrAGoHqf+Lu5CrUQYUQj2IrVHZ8WmonCL7V04Fz3Nh0/QmMLIp8fyVFqmWkON1hVq/YE04b9v4Yd3DzWba7PpAAL2IwhhZu7/g2+NjWgjF6rm8f5+NTK/LyQ6XE7Z4oDNepfy8zuBjCJwo6eRD5sDp9ABBlunA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDc/toJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDc/toJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0D3C61041;
	Tue, 27 Aug 2024 15:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772755;
	bh=J6r40iQXYh1go5tCYuk6gYtkuWeQ6dls26OmiAg9eZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDc/toJUA/8ePBKjwm6mGOeJxU4yOkJ8BEU3jdwIBSFEi+GaZjETkPHM/RcDEJhIB
	 5khYmxZDDzjN2gWn+vPAFNnFb3r0dn6M2BF3lDQApV3saUg6XIG+6Irg4qEpvGvLI9
	 XD9Q4+Sb6ElqmsEORdX+C5xJ3V3ycxbTa+ZGaRO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 268/321] HID: wacom: Defer calculation of resolution until resolution_code is known
Date: Tue, 27 Aug 2024 16:39:36 +0200
Message-ID: <20240827143848.453667521@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 1b8f9c1fb464968a5b18d3acc1da8c00bad24fad upstream.

The Wacom driver maps the HID_DG_TWIST usage to ABS_Z (rather than ABS_RZ)
for historic reasons. When the code to support twist was introduced in
commit 50066a042da5 ("HID: wacom: generic: Add support for height, tilt,
and twist usages"), we were careful to write it in such a way that it had
HID calculate the resolution of the twist axis assuming ABS_RZ instead
(so that we would get correct angular behavior). This was broken with
the introduction of commit 08a46b4190d3 ("HID: wacom: Set a default
resolution for older tablets"), which moved the resolution calculation
to occur *before* the adjustment from ABS_Z to ABS_RZ occurred.

This commit moves the calculation of resolution after the point that
we are finished setting things up for its proper use.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Fixes: 08a46b4190d3 ("HID: wacom: Set a default resolution for older tablets")
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1921,12 +1921,14 @@ static void wacom_map_usage(struct input
 	int fmax = field->logical_maximum;
 	unsigned int equivalent_usage = wacom_equivalent_usage(usage->hid);
 	int resolution_code = code;
-	int resolution = hidinput_calc_abs_res(field, resolution_code);
+	int resolution;
 
 	if (equivalent_usage == HID_DG_TWIST) {
 		resolution_code = ABS_RZ;
 	}
 
+	resolution = hidinput_calc_abs_res(field, resolution_code);
+
 	if (equivalent_usage == HID_GD_X) {
 		fmin += features->offset_left;
 		fmax -= features->offset_right;


