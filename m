Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B8947B436;
	Sat, 12 Sep 2026 18:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237347; cv=none; b=Xr+NYAvNvzahTfotPV0fgAkeWKlaNlzNlvzJLh8O3n5SSzC4KSrci3qiRG72u9ahK6AgAGVC/poyw2BSDWNJ745T2X83/Wv48b3cmh4trBM6MDT079PdhX/YECmIrMhyuScK+7s+USVqZb+CLdYGgbi/sKiIgvS1dx0CZu3ugic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237347; c=relaxed/simple;
	bh=DYTDI++9u7dzYRpAxA89c7WYfGExeJLK+qA6qalqEl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SN5QhExCKV1c1yVJQNY5X/69Y7aAFHxDnxo3MRFXeHaCRVm6oIEq9NQNGKt4Nqa0oEUTJd+g6a8iMZ6i16ci6z89dmlH+ozU6oHz58TMZH4XY4VGw8R/Wab47Eu1HuanArDXnXkv48CRQWUcoKpOchqpuddnoWkX7eH4bpekYkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya6LU+IR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya6LU+IR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E5D1F000FF;
	Sat, 12 Sep 2026 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237346;
	bh=7KHvv3jVI97cmZgBHOkNy8oU8b++J68qCEug588fzWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ya6LU+IRK9bHfE9vQCy3zidvqQvghfUvwa5y3XtRFZISrG6cfJUuiraJpIN0mEjk1
	 NWt+8slTz7lEOHMSAOI0pvzVABiNn3VZ49t5oS5+MIhf1aRPekvlL7esBU0mPhRUuI
	 ez4bMML2Ei/xjXWD2c5819CU071lTiVmtFJFNFCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.15 240/935] usb: typec: ucsi: displayport: Fix OOB altmode array index
Date: Sat, 12 Sep 2026 08:54:30 +0200
Message-ID: <20260912065532.329877645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


