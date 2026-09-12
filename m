Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40FC356744;
	Sat, 12 Sep 2026 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227902; cv=none; b=X35+wAcep+4l9m8f7fyGuBz0rFNcyDgCdcPx/VEuvU8Lmv7+Ie8IiqW5HJe0qnDxM9XYCizaK3zqIFsUbSAchsGuLUoggPrhX5mcMoa3ALDhwEWJ+MhzyR3RKp+AL7Dki4qweKM18dLhG63O+JENtfu/keg9EgNavMNO05uSd9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227902; c=relaxed/simple;
	bh=2oS4g/QJOpRodm8qaGMgsI+k2DeEN9g4+Vvjm99h7Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YU/3BKI06WeYTaUAqxxE9gfKjJO7n24KyQD7I2eKTaRyjkG/Lpv9/UnNrKNoN6eTOHQx3Effk28w7pUNNNo2LE2QNZmvphgnq8PnUs1BuMrceygSMs/TZ/u83/vfdkzLYnLuKCo3kD/YiKIzKz+X330HX6UQvgFT4X+vMJx+hWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tW4f+Qlk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tW4f+Qlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D0A1F000FF;
	Sat, 12 Sep 2026 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227901;
	bh=dzSjR/PUXiYRa21MmTz8Y8h6mf2gr0qDesFLJFmypak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tW4f+QlkzIYt5AYV75vfK/K46x/6qcGFhuHFChgZJRI2gLSxs0yHUAXjoPG3kt/aq
	 28crvZmRdbvO+FoWLfw4ozu2DVzI3VRDi7iLi33PAoL50LEIEG78dTT5oY5RotTsdG
	 ZEyBKqloSIoFTdK4/XNbnul8E7IMXwlFN/UOCrak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.1 0275/1191] usb: typec: ucsi: displayport: Fix OOB altmode array index
Date: Sat, 12 Sep 2026 08:50:03 +0200
Message-ID: <20260912065554.403679187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Jameson Thies <jthies@google.com>

commit 04cec690b1fd9d1c4c314b91a10d8c68a3acfe18 upstream.

The UCSI displayport driver indexes the connector's port altmode array
with the GET_CURRENT_CAM response after checking it is not 0xff. The
port altmode array is UCSI_MAX_ALTMODES elements long. If the PPM
returns an invalid GET_CURRENT_CAM response above UCSI_MAX_ALTMODES and
not equal to 0xff, the kernel may crash with an array index OOB error.

Update the UCSI displayport driver to verify the current cam is less
than UCSI_MAX_ALTMODES before accessing the port altmode array.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Cc: stable@vger.kernel.org
Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/20260825234545.2076049-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -74,7 +74,7 @@ static int ucsi_displayport_enter(struct
 		cur = 0xff;
 	}
 
-	if (cur != 0xff) {
+	if (cur < UCSI_MAX_ALTMODES) {
 		ret = dp->con->port_altmode[cur] == alt ? 0 : -EBUSY;
 		goto err_unlock;
 	}


