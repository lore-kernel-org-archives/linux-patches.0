Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA51B30AACB;
	Mon, 13 Apr 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097324; cv=none; b=lZlprDs5CMMc/EREVpjts8fkNLZXaMFIBqUBctwdNuWC37+jJox2aYSxFXrX3pA9IPheWZ9ek4lTgeYunCr/fIKeXdna157W4WmsV4aYYqfP2HomaRSCWRm5AmYfziB/rwe19goJppYO9Le/V6Tba2asN9IIhjQgqxB2J2G3Gzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097324; c=relaxed/simple;
	bh=ZHuf12WZYizrx3QHSG3Hs69gilKzKhp/7uYaGeXK78I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZYmoTNkR61GBi4NgOCLhKSP7AlnZknR1FW2GQ637a4mNbuvff/Vuv5hfp4vtg5iM3EstcfZOSLp76Nqd9b0CK4qGr+/0ZNb3LXZgAp/9b0qyq0iMkAz5pqAxdL1tU/4s8HkR2C8rxbXjxAsy1tEnE/Walpu4hYVBxspcsNaD0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6A6Hv1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6A6Hv1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0557FC2BCAF;
	Mon, 13 Apr 2026 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097324;
	bh=ZHuf12WZYizrx3QHSG3Hs69gilKzKhp/7uYaGeXK78I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6A6Hv1S8fIkyJe9MmCPk7OA+I2o83xiEuUtL6nTPShLkh3U1iYUjmjxFRDxaXnA0
	 /lPD7ZpH81shiuEfuIvupU0Rk6l70XEWMDuo+DoGPSRzueCLtv4mOd8atPlT52aueG
	 q8yxLfACjtlD5XofB2rUBZPLv8UTa46GOo0Arj4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Bastien Nocera <hadess@hadess.net>,
	linux-input@vger.kernel.org,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 050/570] HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them
Date: Mon, 13 Apr 2026 17:53:01 +0200
Message-ID: <20260413155832.314658870@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit ecfa6f34492c493a9a1dc2900f3edeb01c79946b upstream.

In commit 2ff5baa9b527 ("HID: appleir: Fix potential NULL dereference at
raw event handle"), we handle the fact that raw event callbacks
can happen even for a HID device that has not been "claimed" causing a
crash if a broken device were attempted to be connected to the system.

Fix up the remaining in-tree HID drivers that forgot to add this same
check to resolve the same issue.

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Bastien Nocera <hadess@hadess.net>
Cc: linux-input@vger.kernel.org
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cmedia.c          |    2 +-
 drivers/hid/hid-creative-sb0540.c |    2 +-
 drivers/hid/hid-zydacron.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-cmedia.c
+++ b/drivers/hid/hid-cmedia.c
@@ -99,7 +99,7 @@ static int cmhid_raw_event(struct hid_de
 {
 	struct cmhid *cm = hid_get_drvdata(hid);
 
-	if (len != CM6533_JD_RAWEV_LEN)
+	if (len != CM6533_JD_RAWEV_LEN || !(hid->claimed & HID_CLAIMED_INPUT))
 		goto out;
 	if (memcmp(data+CM6533_JD_SFX_OFFSET, ji_sfx, sizeof(ji_sfx)))
 		goto out;
--- a/drivers/hid/hid-creative-sb0540.c
+++ b/drivers/hid/hid-creative-sb0540.c
@@ -153,7 +153,7 @@ static int creative_sb0540_raw_event(str
 	u64 code, main_code;
 	int key;
 
-	if (len != 6)
+	if (len != 6 || !(hid->claimed & HID_CLAIMED_INPUT))
 		return 0;
 
 	/* From daemons/hw_hiddev.c sb0540_rec() in lirc */
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -114,7 +114,7 @@ static int zc_raw_event(struct hid_devic
 	unsigned key;
 	unsigned short index;
 
-	if (report->id == data[0]) {
+	if (report->id == data[0] && (hdev->claimed & HID_CLAIMED_INPUT)) {
 
 		/* break keys */
 		for (index = 0; index < 4; index++) {


