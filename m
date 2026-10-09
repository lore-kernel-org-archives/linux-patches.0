Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A5C48C403;
	Fri,  9 Oct 2026 14:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556739; cv=none; b=pSeqb3p93N61prtRbbUQ9RzlETFpTIIs5q8jtQkwB3pypBM9MMEH+yQdPlXmRhqi5VHGfDdlrVQAnSORsC6AO7CdHfuzVRsKaJhm+GVC+oGzVc/29JdSCrKjxV+2FadcQppAMeG+hNT6r5+9/3tY9xvNMWAxfSwbSFWFFqtdOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556739; c=relaxed/simple;
	bh=+c8/FA0Q7FW84DKY/93DoA30PBqPMMiSpCXF8FuuTnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrm0JydqVbDmo700NV4aWv9xK9KyWTkYBw4ShAVSNFOYiYLA0Mvo2+rr9PwrDsnsKqtw436pJbZq8NLmY/zhIfhiB/YJhGRMEwmLrpTarx4P59rnv0m5jxMzT6TmLeVt4F0OyHQrKBl2+jD9ixrEOly7VtnvdR8IMm6Jm4EY/jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvKlGTJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvKlGTJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E8E1F000FF;
	Fri,  9 Oct 2026 14:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556738;
	bh=rtY7Cr8cdnh1GewcokzVnkn48jsswIuRv526Frw7vq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvKlGTJvlNWPNetkIyPbYPzl4kq4yUWDYjflNxV4SGq6pQliFS9PdYsF9+vtEkU1x
	 novKXM11IFLPX2Z8oVV646clsVEEIsojxj8ixcSafkGa3t9bKWz9rZaM7RtbC3riwD
	 sBj/nt3Mdz9uh+mqVzUSzTr49ipmekgmySfVJMbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>
Subject: [PATCH 7.2 234/428] usb: typec: ucsi: displayport: Current CAM OOB index fixup
Date: Fri,  9 Oct 2026 16:09:31 +0200
Message-ID: <20261009140951.252407169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


