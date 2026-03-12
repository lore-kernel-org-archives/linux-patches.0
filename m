Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50490346FCF;
	Thu, 12 Mar 2026 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346843; cv=none; b=k9zmitLFJ1VJmeuclY4dj55+LoCd/IcelYSmrNY8YFOrWEuqn2RT3SRmiTlEji93JfuQVcboEqtr+Od23O5O2hNFWVzZp1On3KVF3XoM1Y6BiPAOAWNF+Ubw7AVPovqOEb9fBMsyX5GhDm0z9WT+ggKv1sgabKEph9jaLVQARAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346843; c=relaxed/simple;
	bh=3YCd+uBIXvKFK2X77R0AdCmIyf7SXDpmHdfsXco0NRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ro3i9/NbjlS+wcwOurZfG+/LtjH/fsCSHYxLb3rxVl5lxdhdq4RGfwu4oEErmHIDwnYecGjhW81747bkTLIBlyKXpfFjkWW1APHszIM0dLdRgrzaMZ4EkvGwJj66DVxU+zZbLmBCuZ9qUU/LLE2AblAe5hW1iUAZ3XXfrXKnvV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhl+EM++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhl+EM++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9741C2BC86;
	Thu, 12 Mar 2026 20:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346843;
	bh=3YCd+uBIXvKFK2X77R0AdCmIyf7SXDpmHdfsXco0NRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhl+EM++ug3ah4BFUqDSpjbF+LwrBZW6Hhag/WXBGmjzNck8uaC6CDUxp74ocWuOV
	 1nCcA6GWK/nNFxjj74qwF35MoJVDkv/Rk8ew2i/SGdTt4Ig2a/MRU2NOQjNCI38Z2w
	 xMOKl74bY6qNGmFQTPQS9qHs/5JOHsLiCUYH0cqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Bastien Nocera <hadess@hadess.net>,
	linux-input@vger.kernel.org,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 139/265] HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them
Date: Thu, 12 Mar 2026 21:08:46 +0100
Message-ID: <20260312201023.277430873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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


