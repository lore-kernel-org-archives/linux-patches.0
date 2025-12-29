Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810CC330B2A;
	Mon, 29 Dec 2025 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025245; cv=none; b=klsS0rw1s63y96l70V7pjDUsNe9PdGOGdjFQE4AyWG0SdJnYdkeKJ974/OP6TRA/yspMfW5I/1qsx4pXO1/tik+4Ylg8EoGYqS4HjxhbtvkibinrY15Sc3+WeDfruAwnxnrQ5lYdeCS2VDOeG+378TTN0MdCIXsddJ8Igy/S5DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025245; c=relaxed/simple;
	bh=rapYqrrUWlnW1NYPdPcsFC6rk3vCpLiyhCAE0NNrGnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvVIH1sS1iAUCAwL8/ThzDUrvbNzMKuDZm1ilFrHcgKkgpQNOGuNefk4e35n9RTGw1qWSIORt8Ekz7Foo950bISA3Jq2WcPytb/QVtBVc5hmm7rYcts7l3CYC55/qjw+i9hG7xBJF9oS0XvngX65Y4uv7c3ISzKyWqzAgeu+dQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0D0G466; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0D0G466"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08460C4CEF7;
	Mon, 29 Dec 2025 16:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025245;
	bh=rapYqrrUWlnW1NYPdPcsFC6rk3vCpLiyhCAE0NNrGnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0D0G4665EVnk2eybRpSp2d2MrO4fquIM5j38j2Xfgu75m0pMgnvRGK7Fn9++kN/S
	 BvqY7yX9F28+YabPicrzppn4sNbDeXTxGDRy0Q8MFNdc61TbneWiMSdQP3VJLvgi76
	 tywH2m27/UqLnXM4O2GMjcLY+u/nrF5XhWkltPAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	stable@kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 146/430] HID: input: map HID_GD_Z to ABS_DISTANCE for stylus/pen
Date: Mon, 29 Dec 2025 17:09:08 +0100
Message-ID: <20251229160729.734979059@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -878,7 +878,7 @@ static void hidinput_configure_usage(str
 
 		switch (usage->hid) {
 		/* These usage IDs map directly to the usage codes. */
-		case HID_GD_X: case HID_GD_Y: case HID_GD_Z:
+		case HID_GD_X: case HID_GD_Y:
 		case HID_GD_RX: case HID_GD_RY: case HID_GD_RZ:
 			if (field->flags & HID_MAIN_ITEM_RELATIVE)
 				map_rel(usage->hid & 0xf);
@@ -886,6 +886,22 @@ static void hidinput_configure_usage(str
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


