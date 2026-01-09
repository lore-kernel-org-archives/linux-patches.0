Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457C031ED6D;
	Fri,  9 Jan 2026 12:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962211; cv=none; b=BnovGgNZLFRfaRj6e+X3NaXW39z3+OxDo+5erA8zoqEO7sB8wfSn4ozH1ZmQXv9MxFjVQGqVJepimXB+ZZW3RlC4bO0b4yXuO3YrPtOnA2wRHUCFLD54z6JtkblcCxhLXgcI2LxBIVpZv6y35FuuOhcclinENbao3KgMCQ5mAKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962211; c=relaxed/simple;
	bh=7DmcFliDCamXxp4OX6LyGOQDKA96MjN4+QJtMjKJ9S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyIcjbOowP0RDTQk3pE7CQ2ErZaab4IGyNUYuOlCYcpzIJIOk8XjZgEW1R5nyo5cyQ5GJbDJOlz83HbjDXacpXhuOqdFfZjqnu2bLSQpQ4ogI0/rOKlFA1yez5YzlaSn3cZHngrqPIjEvQGzAUvpKu6Vqp58LBke4IbhJun+CQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebpGeMl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebpGeMl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C579AC4CEF1;
	Fri,  9 Jan 2026 12:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962211;
	bh=7DmcFliDCamXxp4OX6LyGOQDKA96MjN4+QJtMjKJ9S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebpGeMl0W1aQ8X8refMYLNMhJ5MR2zWZ9S0G4d409NMtArq5xw6ejXtsHjfJA0ACH
	 oFrsNNLUXdLoTXVdqFFgoti1FBlL/urpQAv4wyhl6/B7kjmpPWbvSalORg/EBAaHQA
	 NN7dLKNvfzt3QJbxU5YwE4U8+vsKZnxp43u4u8A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	stable@kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 286/634] HID: input: map HID_GD_Z to ABS_DISTANCE for stylus/pen
Date: Fri,  9 Jan 2026 12:39:24 +0100
Message-ID: <20260109112128.293759142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -871,7 +871,7 @@ static void hidinput_configure_usage(str
 
 		switch (usage->hid) {
 		/* These usage IDs map directly to the usage codes. */
-		case HID_GD_X: case HID_GD_Y: case HID_GD_Z:
+		case HID_GD_X: case HID_GD_Y:
 		case HID_GD_RX: case HID_GD_RY: case HID_GD_RZ:
 			if (field->flags & HID_MAIN_ITEM_RELATIVE)
 				map_rel(usage->hid & 0xf);
@@ -879,6 +879,22 @@ static void hidinput_configure_usage(str
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


