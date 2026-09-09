Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEACF53B5FD;
	Wed,  9 Sep 2026 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961712; cv=none; b=EfYuWeyFUHQKfNFlEbVoEc2mhu8RaVpndPmCbAVTYwCnmSud+Wl3X7uDCYo78c47YMxxU+ntCUNFnJixonSMN/kSRYql1pG1HjIbKoUMbnw4nz3ZuBpQWjfBqOuUTTAxMLIX+RG4x5BYQEaqVSazZvf8n/Mmz2n7fAaUBSGtuc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961712; c=relaxed/simple;
	bh=LTqJsH+DoCi0ksP41jfjmxcZ2rFax+ilRaKsZxGDilw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGxLp1ZPLOrKanHJ4nogxQCu/w65anxdRMlf5d8uaH4dfVTfdWzFaVYNl8blqX+RMXPCH6X+NBGLAJA5HCEgMFabmZEhE9ToIe4+8iFKyMFZWY9GVYSOcnkJt+lyZwUQ81nPqE3lRTaMLz5+6DoQq6ouRl3XGuxLnERNlXjBNpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/fx+wcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/fx+wcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234561F00A3A;
	Wed,  9 Sep 2026 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961711;
	bh=VbRmOUdmn/bdFsv8OhSKtFZFNdAc4eJYB4GBBDwJ6dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/fx+wcDKYdbwY3EsgXEBC1fENH9K0lEXz9uCWVtyxnMihqHrWKRdFOYyB4p0rUzg
	 YsKf86YJhEmg4cvlyOz/ByFbmj2L9KT72khHQmZlYy+0Gug60i8kDmh1uETXxm/kg7
	 HtVl4OW3IMm66HSba1ynvJo9JMoP9FoVG+0bPz7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 7.2 043/556] usb: typec: ucsi: displayport: Fix OOB altmode array index
Date: Wed,  9 Sep 2026 15:35:23 +0200
Message-ID: <20260909134232.004604275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


