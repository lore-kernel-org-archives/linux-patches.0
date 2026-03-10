Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20829389113;
	Tue, 10 Mar 2026 11:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142017; cv=none; b=nkgCb5gT6kA7pMZl8sWJ3Q+59LhOHWYZwosUUOF/NlFfhBazQOqUbrKgK6a3/Zxfi0+/yzEqjX3LUYirmQ+omA3q/YIL+J+1V+zxHbul9K5vdk0wNTD95Sk0f68ucBERVrsivQLJu5r46wJD1tzjYQ8QyfBX4XC3wgNbJ10W8/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142017; c=relaxed/simple;
	bh=T/LNN9QFEpL+Sn5oAXB89WXMb/FCc6/ZM0k0NrdVFjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WReJXcR11fqQ48APhQAo9Mhmnehmwtpv+VBPXr18cvhMa/clE2mziWtbrSwegrqT6HCGFoOfIH04qr5tAAKT22Omf6/SuluXmmC7gOjLBmiL5abTliSih4ZLJhaXR6Bvh0brXFHAZjLGHsZYHPoYAU+SYONPbeJIA/+r+goi3KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byvjL3ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byvjL3ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21674C19423;
	Tue, 10 Mar 2026 11:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142017;
	bh=T/LNN9QFEpL+Sn5oAXB89WXMb/FCc6/ZM0k0NrdVFjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byvjL3ngyRT+vLQFtFHZno9MjhWOlgqT7y2JhfD1FczgH1j6jC92jRC9I22geIq64
	 kaWx7KOZc10Chb7eJDSipLWdt6dRe9bVCTjFXy4Io13QBz2jjhQ+OfdLr1b9C8iCkZ
	 MbFeA5ZEgmV8lM55I+ab8YQe5KLqI7e3lqIZxJtaAfBr+x7LO5WZdR7ofORNWw/PU2
	 2UIHvlVz8YPFVdH3MvgGFXpyd4hx5zOUHqiDPAbokuoEoUPB1KqGQF1JqL4EwTwi0o
	 Ufut4S5jsbnHEhcsgt6GUyzSzh7tDgF4OpwdB9sbYLLGU1oPt/YEhNPoc8ryLnkM7h
	 ZTLCG/BPmvFEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Bastien Nocera <hadess@hadess.net>,
	linux-input@vger.kernel.org,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 143/314] HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them
Date: Tue, 10 Mar 2026 07:16:42 -0400
Message-ID: <39461c943c51cf7de63895da203d485dec1b7bc7.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 drivers/hid/hid-cmedia.c          | 2 +-
 drivers/hid/hid-creative-sb0540.c | 2 +-
 drivers/hid/hid-zydacron.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-cmedia.c b/drivers/hid/hid-cmedia.c
index 528d7f3612157..8bf5649b0c793 100644
--- a/drivers/hid/hid-cmedia.c
+++ b/drivers/hid/hid-cmedia.c
@@ -99,7 +99,7 @@ static int cmhid_raw_event(struct hid_device *hid, struct hid_report *report,
 {
 	struct cmhid *cm = hid_get_drvdata(hid);
 
-	if (len != CM6533_JD_RAWEV_LEN)
+	if (len != CM6533_JD_RAWEV_LEN || !(hid->claimed & HID_CLAIMED_INPUT))
 		goto out;
 	if (memcmp(data+CM6533_JD_SFX_OFFSET, ji_sfx, sizeof(ji_sfx)))
 		goto out;
diff --git a/drivers/hid/hid-creative-sb0540.c b/drivers/hid/hid-creative-sb0540.c
index b4c8e7a5d3e02..dfd6add353d19 100644
--- a/drivers/hid/hid-creative-sb0540.c
+++ b/drivers/hid/hid-creative-sb0540.c
@@ -153,7 +153,7 @@ static int creative_sb0540_raw_event(struct hid_device *hid,
 	u64 code, main_code;
 	int key;
 
-	if (len != 6)
+	if (len != 6 || !(hid->claimed & HID_CLAIMED_INPUT))
 		return 0;
 
 	/* From daemons/hw_hiddev.c sb0540_rec() in lirc */
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index 3bdb26f455925..1aae80f848f50 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -114,7 +114,7 @@ static int zc_raw_event(struct hid_device *hdev, struct hid_report *report,
 	unsigned key;
 	unsigned short index;
 
-	if (report->id == data[0]) {
+	if (report->id == data[0] && (hdev->claimed & HID_CLAIMED_INPUT)) {
 
 		/* break keys */
 		for (index = 0; index < 4; index++) {
-- 
2.51.0

