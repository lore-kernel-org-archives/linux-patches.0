Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3970A3587DE;
	Sat, 17 Oct 2026 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256560; cv=none; b=R3Wwzy859Jq2Sw7WV6f9Mbf/EKwadP+Hgc+M8OnnxNXQNk2u8r+w52DIA5G58q0yKui/zgWEltbLxoX3Fvu52PHKfW109/KzaH1fQtxwLckBEuL+48wMawsLl3YZRLICKjGfO81qst66/kAQZLd1lpWfz0a1OCT7O6jyf2FQSZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256560; c=relaxed/simple;
	bh=lNgW1DpDFecyT28EfRTHfpZP65rOX361YobWq6kBXGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odCWkayoDkUloMvT02XSHD+876JV7c7XgvEyrUDi9rvoFRlcuHSM+KiN1DPbhshLwHC/PWyOgzkuj8zAb4VftlHAi9LFVIeF67wmJnob35WgjynZtcDNkfruQt1fkdBL74TNNb4f3Qruo11qNiuBFjCUlkemEqwRVl4EeK8+KP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8poAZBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8poAZBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861F21F000C4;
	Sat, 17 Oct 2026 17:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256559;
	bh=TgM8IO16JRfsMfZHmnId1v2lGdKpAwBuW82AGA9Knro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8poAZBHGSYrLntr9lgBkxaWS4KApnu7OLcxeLz/r2/ymwlIaV7vz92W/JnESLQOU
	 Nl2NSU1mFl7Rnh25HAk1wZ8X57YD0TiXCzoEen8ZllVPnjLXhI7pY2efVAeI6AcwNu
	 mjqMu5RKLygKBJw4f7Q/zX3NWz9pII1rP2/orGhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>
Subject: [PATCH 6.6 0276/1674] usb: typec: ucsi: displayport: Current CAM OOB index fixup
Date: Sat, 17 Oct 2026 17:42:28 +0200
Message-ID: <20261017160438.202328413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


