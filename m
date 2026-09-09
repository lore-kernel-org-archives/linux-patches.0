Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0825577E2E;
	Wed,  9 Sep 2026 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963285; cv=none; b=sGzforrmt1CdGo5ho0uwec3lCuyyUHThTLay1deOG2prW+vb8xWqHtZA4x9Y5DlmXtCB+WVFuWaQV0lwqAe4pAAeq8JzjappHEUPobxzr1Q0OKaZ2Y+/0XKlOe90h2/QpUTCQL78FEBOFvxQKKuuA+MhA9pVYo/Wd1+DGuENou0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963285; c=relaxed/simple;
	bh=OeAmkLBaq9LsAdeTVEHPD6Nh/pK/wgpdABG+6MjyfKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghh+rlytOQeTCVUIfKBPylnguM/F/vXTEF9zlVfvrMRxyHxwwYL50aJuDGgf5h7v4qK1H18oAvWeIwX1BwaO7n91fbfKTL8IPlvDUACRCprVondQesJpNEzrpngCSKyHpEwXLArco6WFpIFCOrHbKZjMJq3Swa4jEE/H98MMgeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXLtzC2E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXLtzC2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E92F1F00A3A;
	Wed,  9 Sep 2026 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963284;
	bh=I2wbAuKlbOMQLxDkmmsc8LNpB2Kk31djV0cw0722yYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXLtzC2EudAb+2OWxdec81brsIQT8yXNzglD8Jzqk2AbN4lXL2Hk15QVsMTuVvdwb
	 e02E/cLtZmOmLGZdbJDps8eT99t8qnZEPU2DNdwCH/wqh8BkKkScQWGrmuZp63eQh5
	 WvckSRzUPb3el/vKAaTp+TvrFsDRjkxYB0o3eOR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.18 026/583] usb: typec: ucsi: displayport: Fix OOB altmode array index
Date: Wed,  9 Sep 2026 15:35:11 +0200
Message-ID: <20260909134238.729484366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


