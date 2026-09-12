Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E72F39C2;
	Sat, 12 Sep 2026 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237959; cv=none; b=icsVkduBpLAUyV9ZJEjsDWSk6J20Qcqm1zLIaKO7G9zbHpM638VPvXnZkqyWfuKS//tkIDTkrJYjCfFTELg8hR+dBa0oDscKSUCRypGAGVvxWnBCmaeTiJsLVrk3gwi4nw9e3AX79TGX4bCfPIWjX6yvsqz6kqmbRNIAQdG9pb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237959; c=relaxed/simple;
	bh=tyGlHUJNGh3mxv5Et352saSPDM3kWhOdkao/U1Zc7c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJWilbYSO0NnSpyd/kDiNfCLVUhoALzfPQGnOXQObXazoNuvqR7R6q2IcW0Wfi4AEg3P2ibOs4UGW1lzOravmmfcD2//h0K/n8ttPXcRihWBLlJxwe9x9rP1+Z8C/SZvyu8/ww/X7rD/QNJWkl44ew+lFAvxPfQ2dmuvbYQsBgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiS7pAQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiS7pAQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67D41F000FF;
	Sat, 12 Sep 2026 18:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237957;
	bh=3ZQnmixb6xDL4LtTWBV72JxBm2bxoS75HZBexrJbm74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiS7pAQztWJbzCY3iFPs0K/qNIadQmxzyUY6jYwIq2fgLFUW7uqUjhogdK9lRodhR
	 YViKu3OO3sA1tYTDKUT+Z99ZBt13z9/Px6BavS1ab/ZhRzX1SGFLuHGgWiyZ9hUPSq
	 ivPnx/yHCVh4a8MlKV2afLdirEPJK6WS5IGZp1I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9ae8e7884e451eaed5b4@syzkaller.appspotmail.com,
	Tao Yu <tao1.yu@intel.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 5.15 365/935] drm/gud: validate TV mode names before creating enum property
Date: Sat, 12 Sep 2026 08:56:35 +0200
Message-ID: <20260912065535.180735315@linuxfoundation.org>
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

From: Tao Yu <tao1.yu@intel.com>

commit da1ea35fea67ad841f4ada28dd61b41be65e5437 upstream.

The GUD protocol returns TV mode names as fixed-size
GUD_CONNECTOR_TV_MODE_NAME_LEN entries and requires each name to be
NUL-terminated.

gud_connector_add_tv_mode() currently passes each fixed-size entry
directly to drm_mode_create_tv_properties_legacy(), which eventually
reaches drm_property_add_enum() and strlen(). If a device returns an
entry without a terminating NUL byte, strlen() reads past the end of
the slot and can run beyond the allocated buffer, triggering an
out-of-bounds read.

Validate that each returned TV mode name contains a NUL terminator
within its fixed-size slot before passing it to the DRM property code.
If a malformed entry is found, reject the device response with -EIO.

This fixes the out-of-bounds read without changing the handling of
valid devices, and avoids silently truncating malformed protocol data.

Reported-by: syzbot+9ae8e7884e451eaed5b4@syzkaller.appspotmail.com
Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Signed-off-by: Tao Yu <tao1.yu@intel.com>
Reviewed-by: Ruben Wauters <rubenru09@aol.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260819072835.4074130-1-tao1.yu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_connector.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gud/gud_connector.c
+++ b/drivers/gpu/drm/gud/gud_connector.c
@@ -399,8 +399,11 @@ static int gud_connector_add_tv_mode(str
 	for (i = 0; i < num_modes; i++) {
 		char *mode = &buf[i * GUD_CONNECTOR_TV_MODE_NAME_LEN];
 
-		/* The device is not trusted to NUL-terminate the name */
-		mode[GUD_CONNECTOR_TV_MODE_NAME_LEN - 1] = '\0';
+		if (!memchr(mode, '\0', GUD_CONNECTOR_TV_MODE_NAME_LEN)) {
+			ret = -EIO;
+			goto free;
+		}
+
 		modes[i] = mode;
 	}
 


