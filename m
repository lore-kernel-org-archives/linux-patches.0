Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF4B1FE47B;
	Sun,  7 Jun 2026 10:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828300; cv=none; b=rgcqOIuTGMTz0MhaqmopwtG8ubVJrDsWiQ0RSI4pb3hZyFiq1m8w51kP158ESgyH/TdpzMKBBlF8edWAj4eMr00F+uQL8eoz1vkIs+1nguTF+W+VAY90QRBIZTB0bKlzXKbfd6V/F+9q8THbWrdI5yxPZEKh9qj3i2nZ4JJ0niE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828300; c=relaxed/simple;
	bh=Ftq4aPFZvbtczRz5jvxF1V5ke383+lD6QeQEYLVFNLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq/20x+c/ZFcnMIWpWo7HD89/eXAcSzBLRHgarfYQfpmHRVEmPbqbdN2haFJUF+/cBVXCVGjQywQYB63YEV31HUQUEewk0Lh8ARMMaHhRzbrVzY1QckbkPA6mlPMDnLqe2bq+Hy1qRAcX95kaE24YF++xNvJ+18Z8P86kfgSK/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qu+vvHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qu+vvHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9EA1F00893;
	Sun,  7 Jun 2026 10:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828299;
	bh=t9gvCE8iF/WXqP+KlGYGHdmweFsZ107pQUSbJ+LzHjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qu+vvHqquB3UO978VZA/tJj5xMLv05BlyHhSBqwHufO+7wZBkhUbibw4nnqQXidn
	 TACkLCtYm5csFGYmH6Ix+RnGodA9CpucYtPcCABx5FP0CGmWkVDy0udSmoFCb4Ylfe
	 yAEG0OY0TPJ7mqyZKG+4XWR4WTyCUfFQqJwajjh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 127/307] usb: typec: ucsi: ccg: reject firmware images without a : record header
Date: Sun,  7 Jun 2026 11:58:44 +0200
Message-ID: <20260607095732.423923191@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

commit d7486952bf74e546ee3748fb14b2d07881fa6273 upstream.

do_flash() locates the first .cyacd record with

	p = strnchr(fw->data, fw->size, ':');
	while (p < eof) {
		s = strnchr(p + 1, eof - p - 1, ':');
		...
	}

If the firmware image contains no ':' byte,  strnchr() returns NULL.
NULL compares less than the valid kernel pointer eof, so the loop body
runs and strnchr() is called with p + 1 == (void *)1 and a length of
roughly (unsigned long)eof, causing a wonderful crash.

The not_signed_fw fallthrough earlier in do_flash() and the chip-state
branches in ccg_fw_update_needed() allow an unsigned blob to reach this
loop, so a root user who can place a crafted file under /lib/firmware
and write the do_flash sysfs attribute can trigger the oops.

Bail out with -EINVAL when the initial strnchr() returns NULL.

Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026051405-posture-shrill-7884@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -1241,6 +1241,11 @@ not_signed_fw:
 	 *****************************************************************/
 
 	p = strnchr(fw->data, fw->size, ':');
+	if (!p) {
+		dev_err(dev, "Bad FW format: no ':' record header found\n");
+		err = -EINVAL;
+		goto release_mem;
+	}
 	while (p < eof) {
 		s = strnchr(p + 1, eof - p - 1, ':');
 


