Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81D533D50F;
	Fri,  9 Jan 2026 12:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960348; cv=none; b=Kqkysley3rFoTjzSDNrb24kAJaN2sxNBpbHQI2/BxlmTAbncJK2iXzhIwtzztzWRd/k0J3tdKI8qiZH0mAjyEM99Vo49dmL5dvgnPSsok/q9qSqRohePJDtmJEO8p9U24FYRTZw05VwxgExy7d+X3yEzWqkV1X7Fb3718CqmU2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960348; c=relaxed/simple;
	bh=GypZXVQG1fvbNKVgUPj6ZIGDQIOEtHrtBVGZWABsrqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpzoTZEz3T/tQbZ5Ie85RxdmfxltxOHp6DOGx6Mz8cGfGaYlOvHF9C7DCekXBL5PpjjIh0iM2oo5Gb9gwaAsoRNy7Qlp7iPoV69isfVx7XaGyOjgMeeRCINnrcFbuFTLXkW2YGLQPjjmL7jCk8Aa+R8AyavdbqTzUX7A2nIsiKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkM4xXik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkM4xXik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68030C4CEF1;
	Fri,  9 Jan 2026 12:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960348;
	bh=GypZXVQG1fvbNKVgUPj6ZIGDQIOEtHrtBVGZWABsrqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkM4xXikcalNOeJR/L/L1n5fWi2L/ngFSVCer5GlHnPBAst42w6TFdsi7D4roulX6
	 beb3SoVogWoqpkNxhR1bM31o6QCq7vwOpuJsNew5XFTmRoqGp53vjqhHPyLgc8UKzD
	 H0B0iyXF/qE11RBomwbfKWN9112mfsTTvcfHXMB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	stable@kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 372/737] HID: input: map HID_GD_Z to ABS_DISTANCE for stylus/pen
Date: Fri,  9 Jan 2026 12:38:31 +0100
Message-ID: <20260109112147.988120842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Ping Cheng <pinglinux@gmail.com>

commit 7953794f741e94d30df9dafaaa4c031c85b891d6 upstream.

HID_GD_Z is mapped to ABS_Z for stylus and pen in hid-input.c. But HID_GD_Z
should be used to report ABS_DISTANCE for stylus and pen as described at:
Documentation/input/event-codes.rst#n226

* ABS_DISTANCE:

  - Used to describe the distance of a tool from an interaction surface. This
    event should only be emitted while the tool is hovering, meaning in close
    proximity of the device and while the value of the BTN_TOUCH code is 0. If
    the input device may be used freely in three dimensions, consider ABS_Z
    instead.
  - BTN_TOOL_<name> should be set to 1 when the tool comes into detectable
    proximity and set to 0 when the tool leaves detectable proximity.
    BTN_TOOL_<name> signals the type of tool that is currently detected by the
    hardware and is otherwise independent of ABS_DISTANCE and/or BTN_TOUCH.

This patch makes the correct mapping. The ABS_DISTANCE is currently not mapped
by any HID usage in hid-generic driver.

Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-input.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -864,7 +864,7 @@ static void hidinput_configure_usage(str
 
 		switch (usage->hid) {
 		/* These usage IDs map directly to the usage codes. */
-		case HID_GD_X: case HID_GD_Y: case HID_GD_Z:
+		case HID_GD_X: case HID_GD_Y:
 		case HID_GD_RX: case HID_GD_RY: case HID_GD_RZ:
 			if (field->flags & HID_MAIN_ITEM_RELATIVE)
 				map_rel(usage->hid & 0xf);
@@ -872,6 +872,22 @@ static void hidinput_configure_usage(str
 				map_abs_clear(usage->hid & 0xf);
 			break;
 
+		case HID_GD_Z:
+			/* HID_GD_Z is mapped to ABS_DISTANCE for stylus/pen */
+			if (field->flags & HID_MAIN_ITEM_RELATIVE) {
+				map_rel(usage->hid & 0xf);
+			} else {
+				if (field->application == HID_DG_PEN ||
+				    field->physical == HID_DG_PEN ||
+				    field->logical == HID_DG_STYLUS ||
+				    field->physical == HID_DG_STYLUS ||
+				    field->application == HID_DG_DIGITIZER)
+					map_abs_clear(ABS_DISTANCE);
+				else
+					map_abs_clear(usage->hid & 0xf);
+			}
+			break;
+
 		case HID_GD_WHEEL:
 			if (field->flags & HID_MAIN_ITEM_RELATIVE) {
 				set_bit(REL_WHEEL, input->relbit);


