Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA821509AE;
	Tue, 20 Feb 2024 21:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462907; cv=none; b=Zx1II02S8KVLdhqi/7CgCdFsrJo7gmqPlv/e7eKFcMkhcDUqfTeLJ7kzvgqdigBhA3q9znSx6yPV78NcpuCHHQd8j6fCUsWCCa/m7ty0l23HVGgNEErLsHeMhPsFuDcZEmzFywBj0Era+aWnXnwMnTrVK/MTTM8VyBFiNJBKgXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462907; c=relaxed/simple;
	bh=z7VBpX8v5qwHHZVtOPMryUTB7KS123aEEHq3MKU6fsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PU44N7P540sLPvITdX3zP2XMpQmUYDWyQZqzx4duDkeU+HQpwSHUlBsl+wjWkGy3I0QlxySAu4fUr/KetlsA5g7ewUZwUuBPfMZtsrePVi4C4PGJaFLF/g479DC1lOWScywuf7EyXZamQPxMqAE04BxkjjqivR0ohtWW5jHP3L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7JvYHRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7JvYHRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F101FC433C7;
	Tue, 20 Feb 2024 21:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462907;
	bh=z7VBpX8v5qwHHZVtOPMryUTB7KS123aEEHq3MKU6fsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7JvYHRJLYBU0cjHILHCmkkBpt6+AFeZhGGG7jbGZ7/oixxk+FfJSzvtWG9ksTDFH
	 RMqcA9i6ZoxxRFMt+i78Q8wFLSUcKPQVggT1PXCXwiHFeXIPyXCUEt/QhGDR3aSbG1
	 J0MRbIVBzlXXpXrLjQxX48F+GDJMBJ/wS13GANX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 045/197] HID: wacom: generic: Avoid reporting a serial of 0 to userspace
Date: Tue, 20 Feb 2024 21:50:04 +0100
Message-ID: <20240220204842.429241572@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>

commit ab41a31dd5e2681803642b6d08590b61867840ec upstream.

The xf86-input-wacom driver does not treat '0' as a valid serial
number and will drop any input report which contains an
MSC_SERIAL = 0 event. The kernel driver already takes care to
avoid sending any MSC_SERIAL event if the value of serial[0] == 0
(which is the case for devices that don't actually report a
serial number), but this is not quite sufficient.
Only the lower 32 bits of the serial get reported to userspace,
so if this portion of the serial is zero then there can still
be problems.

This commit allows the driver to report either the lower 32 bits
if they are non-zero or the upper 32 bits otherwise.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
Fixes: f85c9dc678a5 ("HID: wacom: generic: Support tool ID and additional tool types")
CC: stable@vger.kernel.org # v4.10
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2571,7 +2571,14 @@ static void wacom_wac_pen_report(struct
 				wacom_wac->hid_data.tipswitch);
 		input_report_key(input, wacom_wac->tool[0], sense);
 		if (wacom_wac->serial[0]) {
-			input_event(input, EV_MSC, MSC_SERIAL, wacom_wac->serial[0]);
+			/*
+			 * xf86-input-wacom does not accept a serial number
+			 * of '0'. Report the low 32 bits if possible, but
+			 * if they are zero, report the upper ones instead.
+			 */
+			__u32 serial_lo = wacom_wac->serial[0] & 0xFFFFFFFFu;
+			__u32 serial_hi = wacom_wac->serial[0] >> 32;
+			input_event(input, EV_MSC, MSC_SERIAL, (int)(serial_lo ? serial_lo : serial_hi));
 			input_report_abs(input, ABS_MISC, sense ? id : 0);
 		}
 


