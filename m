Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0A738B7D2;
	Sat, 12 Sep 2026 11:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212974; cv=none; b=DUZtvz9RtbNyu2K9O88YnuJClW1Ml9SNUalm4wqdXuiZ2i8Exa3I0RnMqMZFV7cmfp+mxDnw7opIpPdIUd9WCFZFYK6Zt5ug/RCgR5aZCYVTMasxXX8RMR0Gxej94DX3+XacxlSPue0ENoRMwFDO1bKJLyO6XqiJc6v4xpaBkaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212974; c=relaxed/simple;
	bh=2AEVsu3RGXWnqxA8Qa4s+DhHeqXklzOJo+ssTWCqVsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pquuRkgmhktiyQEKJvh97Ofi/werp+Pd69LVUMIVYjEAL2IQjJSTERq0HnrTT7iiK2aSn08x7YAchRIDOshUQO98f/qy5eF5UVs2NVynHL4j2skoHLCZENl9WQ6YBcjQ+XuUas54KJU6inid0YVVSVjmAnhUgPK+vWZoqxX0oQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJg8pktQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJg8pktQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4986D1F000FF;
	Sat, 12 Sep 2026 11:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212970;
	bh=PgngixlxO0bqC/HbbyxeORPrNywYMm2QR/mjlqRHSkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJg8pktQtRfRjGs9ObeaTS9CEAFiDXLBHCL3/T/FCPljq4TRG6IyJwj24YY/dmUKv
	 KyovZJyrFrq0mVQxzgS6sUgIhUEtULowrOJN0WAB9Dz83VCII1f+t4DIYbcaU+/iSu
	 X7APLdc4hBS/y3eP7PRu7nx3IT0uiaelqJoLB/KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.12 0026/1376] usb: typec: ucsi: displayport: Fix OOB altmode array index
Date: Sat, 12 Sep 2026 08:40:52 +0200
Message-ID: <20260912065608.132486209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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


