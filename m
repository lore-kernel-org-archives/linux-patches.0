Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38CF269817;
	Thu, 17 Apr 2025 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914435; cv=none; b=r6l01ZJuFmkMMfazunyxZGqD++S7JVNysOztgBciIImnr4chmFXKhHz8stctWOTwwo0BJfAfpbpYDcuB2E3gw0gfDDpYCAk590l5PN4hKZ+EoP+/rQU+pkOWmwaVqBY22/DiHWuLUXTudwUqwN7ZScYbSOe8IbqtKos49O0l9pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914435; c=relaxed/simple;
	bh=g/cytp7c5r6l3mcnwZdOo8nQRyJeY/2pKbzxZxKqfV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OoCvsvqJLV1L54wWwcrKMr4qFSGran1k2D+qIii8zxb+5KF+OQem060pCeP7mejgtYS9eLjwZj69hElD8Pr2HyLyAqg4kjLwqtfDz/bw0XBreAklSaQUvV9s585/HywrlY64mq83CYHQuwEZTu/tX0nWr750p0w8hvqYD1fRZ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxKBz4Zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxKBz4Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F54C4CEEA;
	Thu, 17 Apr 2025 18:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914434;
	bh=g/cytp7c5r6l3mcnwZdOo8nQRyJeY/2pKbzxZxKqfV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxKBz4ZdhmuIxd+7sEihbm0uxvGzgTyOyT0m/+ocBP78inEv9w1W6yOZ0FiZ3Bu4l
	 HgYz9lBJ6Kfgs07N5LSv5/fA1bJm63T296ZG9THLYziqzZxC/RF0tzuBHQoZVZu7ab
	 Hqh16dEjM1yldGpHroIRbokSjo/lW3s4coDgHu7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 185/414] HID: pidff: Make sure to fetch pool before checking SIMULTANEOUS_MAX
Date: Thu, 17 Apr 2025 19:49:03 +0200
Message-ID: <20250417175118.889687513@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 1f650dcec32d22deb1d6db12300a2b98483099a9 ]

As noted by Anssi some 20 years ago, pool report is sometimes messed up.
This worked fine on many devices but casued oops on VRS DirectForce PRO.

Here, we're making sure pool report is refetched before trying to access
any of it's fields. While loop was replaced with a for loop + exit
conditions were moved aroud to decrease the possibility of creating an
infinite loop scenario.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index f23381b6e3447..503f643b59cad 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -604,28 +604,25 @@ static void pidff_reset(struct pidff_device *pidff)
 }
 
 /*
- * Refetch pool report
+ * Fetch pool report
  */
 static void pidff_fetch_pool(struct pidff_device *pidff)
 {
-	if (!pidff->pool[PID_SIMULTANEOUS_MAX].value)
-		return;
+	int i;
+	struct hid_device *hid = pidff->hid;
 
-	int i = 0;
-	while (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] < 2) {
-		hid_dbg(pidff->hid, "pid_pool requested again\n");
-		hid_hw_request(pidff->hid, pidff->reports[PID_POOL],
-				HID_REQ_GET_REPORT);
-		hid_hw_wait(pidff->hid);
+	/* Repeat if PID_SIMULTANEOUS_MAX < 2 to make sure it's correct */
+	for(i = 0; i < 20; i++) {
+		hid_hw_request(hid, pidff->reports[PID_POOL], HID_REQ_GET_REPORT);
+		hid_hw_wait(hid);
 
-		/* break after 20 tries with SIMULTANEOUS_MAX < 2 */
-		if (i++ > 20) {
-			hid_warn(pidff->hid,
-				 "device reports %d simultaneous effects\n",
-				 pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
-			break;
-		}
+		if (!pidff->pool[PID_SIMULTANEOUS_MAX].value)
+			return;
+		if (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] >= 2)
+			return;
 	}
+	hid_warn(hid, "device reports %d simultaneous effects\n",
+		 pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
 }
 
 /*
-- 
2.39.5



