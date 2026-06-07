Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717F9202C46;
	Sun,  7 Jun 2026 10:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827899; cv=none; b=ldA0hOLOrMh7ftvMgpvznL94qmJ3ehBczqizkKgu7g10XeYieLZRRKhyZc4iw4ZyFnQjlYqb4U8e/7XSu5oNWX6bbMpDfUX35pJpTwpYaFCzlWktRUkKBFnDzeQ1bqh+b1xidyVaPhSw8u/PODfU/Y/fxkfwX914p+n+TG6QIMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827899; c=relaxed/simple;
	bh=M5f5qASr35fwVLFP1mWpeglqslxX1vm+eQgspQmR1WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbrjT9sc+udiKWqw4kzU0+k7k9sRw4WYEZ4bOTvVvRUPqvnb+ekuV2oZVgwTJAP4vnhO3/1OBnnc/Xe7NQF4iDwC3xWE8IXc+GcLXw7wdDbJyLIiPWrNno0nmvH/InGenG8h8tCGEz/Md5RqV1ynFaZ5uE/cirGGbRNTS/6hOBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5G4Dtpd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5G4Dtpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794311F00893;
	Sun,  7 Jun 2026 10:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827898;
	bh=MELWGJipIk5FL9RWs4AMB9uMsQ+dM9pmYFjTZiiCKzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5G4DtpdShS0BuzJ9sBgGWEsDXEjUD0LeYBOrIMJkl0bp46mwMbCMINhj8XSWo5G4
	 AEZ2oA+mJkucadJvV9OWmTpnAGFRxS/Hc/MXAvmjn4C3RkY6z9Xj887Gfe1zpx2ey9
	 jjxHlPvw41xXWOyj+yxAE446VsrJjxOwvugahlFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 111/315] usb: typec: altmodes/displayport: validate count before reading Status Update VDO
Date: Sun,  7 Jun 2026 11:58:18 +0200
Message-ID: <20260607095731.719651419@linuxfoundation.org>
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

commit 8a18f896e667df491331371b55d4ad644dc51d60 upstream.

A broken/malicious device can send the incorrect count for a status
update VDO, which will cause the kernel to read uninitialized stack data
and send it off elsewhere.

Fix this up by correctly verifying the count for the update object.

Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/2026051350-reacquire-sculpture-4244@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -405,6 +405,8 @@ static int dp_altmode_vdm(struct typec_a
 				dp->state = DP_STATE_EXIT_PRIME;
 			break;
 		case DP_CMD_STATUS_UPDATE:
+			if (count < 2)
+				break;
 			dp->data.status = *vdo;
 			ret = dp_altmode_status_update(dp);
 			break;


