Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266C41C6F79;
	Tue, 27 Aug 2024 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771700; cv=none; b=iCcnCtpEZJor8ofMoYOn5wKJnogK/e6T/yFnz9jipMCnMCQnwSH7cTY4v8wOJeYUs0oQJDAGps0vtMwpNlEeGvEg4HNauWuZeHncFkAqhsX/s85rlj/CXcPQcaOMpp3BeLL9csrFM9nmYHPwA4BbcB6OSAYEcY9rhBzq5uRaxyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771700; c=relaxed/simple;
	bh=bbZJbdXz2EX6NG4/aTVkcoP7KX1Z1XUEu4DwlAzmUZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/z6A5GaYMOPCKgPhl/WRoI2i48hFif4im8DK4hbQjZzJZMWQ+ZLGfI4cHU7yMznOPU5CnS+tpsi//1UQ+Y+ztIQEidq4xUghAGeLh9r81Xf8Bg75r2HSv4+xF1KrPBgFzB/YG0IMAlEol38fBrzIn8kgTt0ojuVZfGOoCuUceQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMGfcvex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMGfcvex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D12C61075;
	Tue, 27 Aug 2024 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771700;
	bh=bbZJbdXz2EX6NG4/aTVkcoP7KX1Z1XUEu4DwlAzmUZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMGfcvexQft4Tbv4GT2TwIHUR7fjDOph4f4qRbmSUorew72gHRXcDB77HX0XxfgNt
	 GGgn+pVaZZ31koi4JJcaB9QiaB41fBOy6aWnfpWiM+P5BUf0afoIsTlF2B2/7RIVIo
	 U9v44BlID4xr35+aipJZS0YP6zGniqyMmLCNoDF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.10 236/273] HID: wacom: Defer calculation of resolution until resolution_code is known
Date: Tue, 27 Aug 2024 16:39:20 +0200
Message-ID: <20240827143842.386682633@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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
@@ -1924,12 +1924,14 @@ static void wacom_map_usage(struct input
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


