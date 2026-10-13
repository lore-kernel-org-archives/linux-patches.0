Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949E64FD785;
	Tue, 13 Oct 2026 12:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895085; cv=none; b=mwtftt1f7cgy8eOga9XXRoWc0Zv4w0Eo7V4fI6/+BMcZFInhxi01TrG1M/0GFf+GecEK8B+HbeKktvv9uqRA01pVkh/uLuKcWexPMDZY9M7bKTFWA+C23AI5g7dZXVUIHRW7HlDfuLpGau3jpcfPc/pevbhEwyF0ZBrCj/ON9r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895085; c=relaxed/simple;
	bh=zzdrqePcuF+0BZSm5rVuT18dd/Qav8hoWUDs7VhzSyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AivafF1Py8MJ7/gqGjESjC61mma2uHSg5xR4yk15z70AMy5CgGdXn6iuX0y5zQqP3NKcYcmejh9odhcmcuyomNuRbl/mwktSaxYhODBTYRGVFL2fWBBVOSQ55fDGpCvt1ZtvyOCTD5s+ZiIy6/2ePUi37jPADRFRTdRD3b77xME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fV7IitaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fV7IitaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAC21F0089A;
	Tue, 13 Oct 2026 12:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895084;
	bh=JJbHOAlhh3TC6lFCHi4QJHVHrn1hWLIzCqqtMKrxloM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fV7IitaZGS+Hx1t2Fnyy7MzRxJD/PwLybM1r02eQ9nH1apC+s4jr+dih7WNJn9uJM
	 2pf3U9//UpkYUKMtibeoBFW++NOU7fHFpoM3ewxO176ZVM5ooy2Pf2QZ5unGQSOFZT
	 kT8PVdloas+ahmEGuRJAXULv7K6JXxivXP5bYEJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>
Subject: [PATCH 6.12 156/497] usb: typec: ucsi: displayport: Current CAM OOB index fixup
Date: Tue, 13 Oct 2026 13:35:23 +0200
Message-ID: <20261013112911.590612154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Jameson Thies <jthies@google.com>

commit ea31c6498c61307dc0d8ce338a7f268cb8cbdd57 upstream.

Update ucsi_displayport_enter() to return invalid error when the PPM
reports an current alternate mode greater than or equal to
UCSI_MAX_ALTMODES. While here, remove 0xff current cam assignment on
failed GET_CURRENT_CAM response.

Fixes: 04cec690b1fd ("usb: typec: ucsi: displayport: Fix OOB altmode array index")
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Jameson Thies <jthies@google.com>
Link: https://patch.msgid.link/20260917032008.1701888-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -71,11 +71,14 @@ static int ucsi_displayport_enter(struct
 	if (ret < 0) {
 		if (ucsi->version > 0x0100)
 			goto err_unlock;
-		cur = 0xff;
 	}
 
-	if (cur < UCSI_MAX_ALTMODES) {
-		ret = dp->con->port_altmode[cur] == alt ? 0 : -EBUSY;
+	if (cur != 0xff) {
+		if (cur < UCSI_MAX_ALTMODES)
+			ret = dp->con->port_altmode[cur] == alt ? 0 : -EBUSY;
+		else
+			ret = -EINVAL;
+
 		goto err_unlock;
 	}
 


