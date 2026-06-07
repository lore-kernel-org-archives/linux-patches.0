Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183F131E832;
	Sun,  7 Jun 2026 10:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828076; cv=none; b=jK1CHIoiyiPhA0W+Q2CPcSKxkNdCpFRvNjt4eqNOoZjhOMxCWU22IxBJgK4LOcm2tZPetHjfWlqc2nQS8Yb/r3d/v0xfxCxSU1zcHarVw27QfoGaazpizvYnbtM0IYv6HILIlbedPSv5q9e2r9tUTtWfY+kbfpl3Yzc1WzlF8v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828076; c=relaxed/simple;
	bh=4B1TCOht/LJBUnV3/WFBG1s8vagKMLhrsRQg6t7We0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJRGe/c3D/Nq3NnI5F0rbExcz/AZlHlQfYPjI9DsIA65danacMkj005s3yZI5Q9xsGO4S9ucOZfRFWiT9YLfXSot7LIGYbw5Ziorf7otIEOww9cTFhAz7Hzw0tBqaVxBUTrsF3kztzqJ/krqmDHXFB2NBLDFWUMOq+avKxFKYWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJWR0oiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJWR0oiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FDF1F00893;
	Sun,  7 Jun 2026 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828075;
	bh=H+2Z5vM/jhsnQu7qrEd3/7Oa/VhAwWu8VA+B5vE059o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJWR0oiAJ+Pa+HXqyQYAfqx1V1XeWr7MynRbHbD1Y5HGVZe60KN1BmxsiAwwI3hPY
	 JRp0bnOi8AOkr0quZy5HT7YuXY9yIzM16X69XUyvP8XfeyrpohOyGltKs6Xjlc2P/D
	 3ebUB+ZGejsTmKtWHKaALhawci348RSzVVz3clT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 107/315] usb: typec: ucsi: ccg: reject firmware images without a : record header
Date: Sun,  7 Jun 2026 11:58:14 +0200
Message-ID: <20260607095731.579239928@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -1242,6 +1242,11 @@ not_signed_fw:
 	 *****************************************************************/
 
 	p = strnchr(fw->data, fw->size, ':');
+	if (!p) {
+		dev_err(dev, "Bad FW format: no ':' record header found\n");
+		err = -EINVAL;
+		goto release_mem;
+	}
 	while (p < eof) {
 		s = strnchr(p + 1, eof - p - 1, ':');
 


