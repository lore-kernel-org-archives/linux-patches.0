Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6878824677D;
	Tue, 20 May 2025 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750247; cv=none; b=QgSUm2FC7v1KFAqGiGYR9wdd1kbFVgA+wePoi6ZMiMgbICOmDgzShcQhVARswY2YmTBCeE73QJLPA2wGljOVIA0L6ZKWKDRTCpixEGFkvVVe7es73vy81dutaTLTB4+NvvKuG8d3Nyb8VgcU5mLAD5wimlK27zE1tv2r0Xlkzbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750247; c=relaxed/simple;
	bh=sYvFiyeFQfl1ZtUYfVhPzVSxJpDCArDuKzAjHP0SSKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDIhUo+yaIR7NEY0WfJyzCN1Ru83RGWG1dv/Bb5S6BC6qNrFqImJWcyTrADeNH+dbyJw+2SikpLatWQNS9SwcwNuPcNbIVRfAdS4W0umD7IMBVVE3FZkwjxYr1VVprfOp0cMzKQCsXZuKV1SYgjvYWAC5kq/EGWuUvVkE4j/U7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKyUm5nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKyUm5nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA03C4CEEA;
	Tue, 20 May 2025 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750246;
	bh=sYvFiyeFQfl1ZtUYfVhPzVSxJpDCArDuKzAjHP0SSKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKyUm5nqgLwD0JKMzGV0SFagrV3Iwm96sNeLMfHxaTATMcMxVS4BbsxiEve2PPIpl
	 RxerrJGKVWzowHcRLgOxUm/9xKL8oIW5GCnaRp9KSAV2prl9Zq/RMm6JOQG9ky6KB1
	 0U2TG00niyjeStJ+L6wNxRp2hzJf2cJ4IG7O8IxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Petr Tesarik <petr@tesarici.cz>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 072/143] HID: bpf: abort dispatch if device destroyed
Date: Tue, 20 May 2025 15:50:27 +0200
Message-ID: <20250520125812.898024459@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rong Zhang <i@rong.moe>

commit 578e1b96fad7402ff7e9c7648c8f1ad0225147c8 upstream.

The current HID bpf implementation assumes no output report/request will
go through it after hid_bpf_destroy_device() has been called. This leads
to a bug that unplugging certain types of HID devices causes a cleaned-
up SRCU to be accessed. The bug was previously a hidden failure until a
recent x86 percpu change [1] made it access not-present pages.

The bug will be triggered if the conditions below are met:

A) a device under the driver has some LEDs on
B) hid_ll_driver->request() is uninplemented (e.g., logitech-djreceiver)

If condition A is met, hidinput_led_worker() is always scheduled *after*
hid_bpf_destroy_device().

hid_destroy_device
` hid_bpf_destroy_device
  ` cleanup_srcu_struct(&hdev->bpf.srcu)
` hid_remove_device
  ` ...
    ` led_classdev_unregister
      ` led_trigger_set(led_cdev, NULL)
        ` led_set_brightness(led_cdev, LED_OFF)
          ` ...
            ` input_inject_event
              ` input_event_dispose
                ` hidinput_input_event
                  ` schedule_work(&hid->led_work) [hidinput_led_worker]

This is fine when condition B is not met, where hidinput_led_worker()
calls hid_ll_driver->request(). This is the case for most HID drivers,
which implement it or use the generic one from usbhid. The driver itself
or an underlying driver will then abort processing the request.

Otherwise, hidinput_led_worker() tries hid_hw_output_report() and leads
to the bug.

hidinput_led_worker
` hid_hw_output_report
  ` dispatch_hid_bpf_output_report
    ` srcu_read_lock(&hdev->bpf.srcu)
    ` srcu_read_unlock(&hdev->bpf.srcu, idx)

The bug has existed since the introduction [2] of
dispatch_hid_bpf_output_report(). However, the same bug also exists in
dispatch_hid_bpf_raw_requests(), and I've reproduced (no visible effect
because of the lack of [1], but confirmed bpf.destroyed == 1) the bug
against the commit (i.e., the Fixes:) introducing the function. This is
because hidinput_led_worker() falls back to hid_hw_raw_request() when
hid_ll_driver->output_report() is uninplemented (e.g., logitech-
djreceiver).

hidinput_led_worker
` hid_hw_output_report: -ENOSYS
` hid_hw_raw_request
  ` dispatch_hid_bpf_raw_requests
    ` srcu_read_lock(&hdev->bpf.srcu)
    ` srcu_read_unlock(&hdev->bpf.srcu, idx)

Fix the issue by returning early in the two mentioned functions if
hid_bpf has been marked as destroyed. Though
dispatch_hid_bpf_device_event() handles input events, and there is no
evidence that it may be called after the destruction, the same check, as
a safety net, is also added to it to maintain the consistency among all
dispatch functions.

The impact of the bug on other architectures is unclear. Even if it acts
as a hidden failure, this is still dangerous because it corrupts
whatever is on the address calculated by SRCU. Thus, CC'ing the stable
list.

[1]: commit 9d7de2aa8b41 ("x86/percpu/64: Use relative percpu offsets")
[2]: commit 9286675a2aed ("HID: bpf: add HID-BPF hooks for
hid_hw_output_report")

Closes: https://lore.kernel.org/all/20250506145548.GGaBoi9Jzp3aeJizTR@fat_crate.local/
Fixes: 8bd0488b5ea5 ("HID: bpf: add HID-BPF hooks for hid_hw_raw_requests")
Cc: stable@vger.kernel.org
Signed-off-by: Rong Zhang <i@rong.moe>
Tested-by: Petr Tesarik <petr@tesarici.cz>
Link: https://patch.msgid.link/20250512152420.87441-1-i@rong.moe
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -38,6 +38,9 @@ dispatch_hid_bpf_device_event(struct hid
 	struct hid_bpf_ops *e;
 	int ret;
 
+	if (unlikely(hdev->bpf.destroyed))
+		return ERR_PTR(-ENODEV);
+
 	if (type >= HID_REPORT_TYPES)
 		return ERR_PTR(-EINVAL);
 
@@ -93,6 +96,9 @@ int dispatch_hid_bpf_raw_requests(struct
 	struct hid_bpf_ops *e;
 	int ret, idx;
 
+	if (unlikely(hdev->bpf.destroyed))
+		return -ENODEV;
+
 	if (rtype >= HID_REPORT_TYPES)
 		return -EINVAL;
 
@@ -130,6 +136,9 @@ int dispatch_hid_bpf_output_report(struc
 	struct hid_bpf_ops *e;
 	int ret, idx;
 
+	if (unlikely(hdev->bpf.destroyed))
+		return -ENODEV;
+
 	idx = srcu_read_lock(&hdev->bpf.srcu);
 	list_for_each_entry_srcu(e, &hdev->bpf.prog_list, list,
 				 srcu_read_lock_held(&hdev->bpf.srcu)) {


