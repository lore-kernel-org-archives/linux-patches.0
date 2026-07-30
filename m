Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3BE435AB0;
	Thu, 30 Jul 2026 14:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421603; cv=none; b=Aos3mIQYzTNo2n6MO6mdlJNyTenGRpCvP0wEpL9nC5m+o7odGIFowiAipJLGSB4aUIBa2zK/zGHqDj+5kTaGphmRrvgWnH0uF7nnhgRP+C37XYZF3zi8IpPwF30xZJqynKcGB59oGgz4RAhYA/SRLrsDK1AIXOieaOhbs8c8mNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421603; c=relaxed/simple;
	bh=BgWpGKIhJ+7UZztLBxWglfW8dRVn6dlCgnXqmo6r4Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0Ll+pmJltMXkMEntzvFAPw6DnG5CCEAEKM4rMA1nyEVHxRMKmU73KlTCuXWh1tRPP8IrWwzdOJqv9iWN1p5MDwog1Nt9fIfNmEdwbKC0J4KwPdHl9/JpVbNOJIVzrpgQ9Wt4jmuVRMQu0W4YEYq5OdMg6iUq3B36PQfCkMN8Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeWLjnn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeWLjnn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F021F000E9;
	Thu, 30 Jul 2026 14:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421601;
	bh=upB398yoroqpnV7l9ZpZkALm0z//HezwUjV00LXqhWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeWLjnn/LKXpBb6FHfnAz286Oq4K4cPWwE1xrhV+6DkvgCJdRYbjWesTLjOj+rSbj
	 OrzuvA/dFWTKwN7yeuCRt1IBhRux1C16Qk07HLviPxmBJ+nUf7kSC9heZ2uMXT51J2
	 +gYZF7sZRYg1VUD7WkuWBt6mcHrFqYVxN+PujNLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
Subject: [PATCH 7.1 158/744] usb: typec: ucsi: Add duplicate detection to nvidia registration path
Date: Thu, 30 Jul 2026 16:07:11 +0200
Message-ID: <20260730141447.652729717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

commit f1aa17f72f9b9589bd724dc826c5b17d164193d1 upstream.

Extend the duplicate altmode detection to ucsi_register_altmodes_nvidia()
which is used when a driver provides the update_altmodes() callback.

This ensures all drivers benefit from duplicate detection, whether they
use the standard registration path or the nvidia path with update_altmodes
callback.

Without this fix, drivers using the nvidia path (like yoga_c630) would
still encounter duplicate altmode registration errors from buggy firmware.

Fixes: a79f16efcd00 ("usb: typec: ucsi: Add support for the partner USB Modes")
Cc: stable <stable@kernel.org>
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Link: https://patch.msgid.link/20260713084323.287516-2-acelan.kao@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -675,19 +675,25 @@ ucsi_register_altmodes_nvidia(struct ucs
 
 	/* now register altmodes */
 	for (i = 0; i < max_altmodes; i++) {
-		memset(&desc, 0, sizeof(desc));
-		if (multi_dp) {
-			desc.svid = updated[i].svid;
-			desc.vdo = updated[i].mid;
-		} else {
-			desc.svid = orig[i].svid;
-			desc.vdo = orig[i].mid;
-		}
-		desc.roles = TYPEC_PORT_DRD;
+		struct ucsi_altmode *altmode_array = multi_dp ? updated : orig;
 
-		if (!desc.svid)
+		if (!altmode_array[i].svid)
 			return 0;
 
+		/*
+		 * Check for duplicates in current array and already
+		 * registered altmodes. Skip if duplicate found.
+		 */
+		if (ucsi_altmode_is_duplicate(con, recipient, altmode_array, i,
+					      altmode_array[i].svid,
+					      altmode_array[i].mid, i))
+			continue;
+
+		memset(&desc, 0, sizeof(desc));
+		desc.svid = altmode_array[i].svid;
+		desc.vdo = altmode_array[i].mid;
+		desc.roles = TYPEC_PORT_DRD;
+
 		ret = ucsi_register_altmode(con, &desc, recipient);
 		if (ret)
 			return ret;


