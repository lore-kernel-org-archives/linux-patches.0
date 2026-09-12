Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6094F372EF0;
	Sat, 12 Sep 2026 11:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214169; cv=none; b=Ksbfwv/AzmX0YJLwyG/e+tRRQZkwMy2VQqTYR+Sa1JcChub7dVHq2i+EE1ObwkqOFq26sd5M6N6ZDGYfVypuPtPgYf+hi8s+Ri5ja6fTplMDl0zq6SFNlpYMPt3aHeaxlbRZI3T40WrFIU9OzIV++EMVPlPckCRz4TG7kzQXGbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214169; c=relaxed/simple;
	bh=G5ydlZMJbieuO80gGySqI+NfOUJFSv7RhNDfX2GJN9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRTwTSAAVoeFfVOAJkTU4gEAUSo5qBgnunjT53dbj08a/+mzbMblWnw65sI1badM/cqeDq0foP0KR/jn6wtHqthEOT1H0csc6CCyu6/tqLtUs0hpiTPJ/loETi6E1x7HyrA3P8zG2aSv71fv1lTFJsOh8fgjLNzAxyIVrcEK7LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrCO7DNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrCO7DNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648751F000FF;
	Sat, 12 Sep 2026 11:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214168;
	bh=cmYCb585otMSdkqm91OCk2gPzx/4NfNq9NfmD72WzmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrCO7DNERozAyPBim1Wtf0VHaxw2tBLE0qPMlBuvCncnQSvECToJX+HUamUg30ec1
	 7zn2NQIVxIZ7Uv6V5LafRJ/v3FL+sUPiDdEStQwfnsbPAYFXaYvQXiSqyfaXYDHGtt
	 7KTF8C9NIH9Dqu+oCxiW6rQbMSdc8vdDJeZdtbrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+916c888ba5f1a54c9526@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.12 0271/1376] drm/gud: NUL-terminate TV mode names read from the device
Date: Sat, 12 Sep 2026 08:44:57 +0200
Message-ID: <20260912065613.583275864@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 500cb24cd61bad8a2747ddfc49b7034899c82d94 upstream.

gud_connector_add_tv_mode() reads a buffer of fixed-size mode names from
the USB device and passes pointers into it to
drm_mode_create_tv_properties_legacy(), which calls strlen() on each one.
Nothing guarantees the device NUL-terminates a name, so strlen() can run
past the end of a slot and, for the last mode, past the end of the
allocation.

Terminate each name at the end of its slot before use.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Reported-by: syzbot+916c888ba5f1a54c9526@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=916c888ba5f1a54c9526
Tested-by: syzbot+916c888ba5f1a54c9526@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260816085234.22053-1-kartikey406@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_connector.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gud/gud_connector.c
+++ b/drivers/gpu/drm/gud/gud_connector.c
@@ -397,8 +397,13 @@ static int gud_connector_add_tv_mode(str
 	}
 
 	num_modes = ret / GUD_CONNECTOR_TV_MODE_NAME_LEN;
-	for (i = 0; i < num_modes; i++)
-		modes[i] = &buf[i * GUD_CONNECTOR_TV_MODE_NAME_LEN];
+	for (i = 0; i < num_modes; i++) {
+		char *mode = &buf[i * GUD_CONNECTOR_TV_MODE_NAME_LEN];
+
+		/* The device is not trusted to NUL-terminate the name */
+		mode[GUD_CONNECTOR_TV_MODE_NAME_LEN - 1] = '\0';
+		modes[i] = mode;
+	}
 
 	ret = drm_mode_create_tv_properties_legacy(connector->dev, num_modes, modes);
 free:


