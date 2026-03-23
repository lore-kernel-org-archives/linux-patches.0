Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094D21DA0E1;
	Mon, 23 Mar 2026 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277914; cv=none; b=kHEUiXjzwwehgy7zdiQPwADLZsoUKu3PqecoCDvtDWfQ0oLBj0IMyRkfw+m4bk4bOTnb8Jz4fnhqy+7VoCfA90SjBs0MzHVzDb9bN7L6oEm99Sj6uqoet7JIyhcIF+QKTGJ+pYz7Ei9Rqq2bD/VF6lugAB8fnRaD2+DQQPwN82c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277914; c=relaxed/simple;
	bh=EJoB4/6S2K2JhXF7hIxOmkKY7a75/VZlB6bv5gaJcBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Drz3rtl5FPc1fsOD6UAaPyegjgByhul67iyLlCOgo33vvdaMl86JGKJO8NE8t64kaygX7vVmN+FtAepRYr/Jb32SuMvMlkWgTkXB1dC+379Adr2kYsMisEBTIFiIBcc3SWWWW2ZRLjgsRlQDPLAfNIOscl+JBxvGRjpkMnqhIPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvqUKztp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvqUKztp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A09FC4CEF7;
	Mon, 23 Mar 2026 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277913;
	bh=EJoB4/6S2K2JhXF7hIxOmkKY7a75/VZlB6bv5gaJcBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvqUKztpNpEWE9aLFm2vlLTsd+/l/d3QEWxjzeZFZy50v4n7/PJHovuMZ2loZ7V1i
	 MmYUdpHxTULIust8rvy4Q5jP1Cb+BAErLWVsOK+8qq0aD95o5YDZsX67MEq430PgJS
	 DG2QDc4qYZ5wzzfwX1ac44FaslYfwG9piJAJ+KPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Bastien Nocera <hadess@hadess.net>,
	linux-input@vger.kernel.org,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 099/567] HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them
Date: Mon, 23 Mar 2026 14:40:19 +0100
Message-ID: <20260323134536.274258546@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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


