Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0EFF9D4;
	Tue, 14 May 2024 11:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687994; cv=none; b=HI+VyDEGL9Sstui0Xjc4iSoqH2OIehHLojU1oTABn2XLrN2RkkDLcrc4IO5OPRIjx3bDitnDPHfTAW2BHQzMgeHVNIxkcGhyFStNMOP1xCmOLOE2IJ6mwthDd++qCqXodOXwQqTCEyOHp9LYZjdfnTrSCL8pkUTUrWidQIXDvzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687994; c=relaxed/simple;
	bh=blkENpqInJ5J87dWjcQF/5KQgwQT/3kCFZi2Td3Z0R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHoifZhoKcepOdCupXxq1CL5fFxRQDNOksrTF8nz38HeLM19WBHyTvE2hfkWgMAvFflmjst4XoHVulku6hUCJFukbHrrIfYObhPm+el+zazv2reRpKbyAQTyKF0l4pjwIwdgJ2ScBFzGfY7swsEGitfYO5Hb7lFBlvZTAtOqQY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nz7kTMeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nz7kTMeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C99C32782;
	Tue, 14 May 2024 11:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687993;
	bh=blkENpqInJ5J87dWjcQF/5KQgwQT/3kCFZi2Td3Z0R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nz7kTMeSpfwFwFOWPZUsSho4iaCioHtbtj7YOr5N+n6MmmbPOdbtbpsSYg4jYI7Ky
	 1/7+c855ZC2j+bEY0Hel7Mzbj9KuBhey6VoqqJHdNK05QI5iiGcThLFtDJOPr99nBB
	 gNnlp9fIWH+zRzFyKNqHRaNwBG9k6uKGR9Zndcdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 142/168] usb: typec: ucsi: Fix connector check on init
Date: Tue, 14 May 2024 12:20:40 +0200
Message-ID: <20240514101012.048724358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian A. Ehrhardt <lk@c--e.de>

commit ce4c8d21054ae9396cd759fe6e8157b525616dc4 upstream.

Fix issues when initially checking for a connector change:
- Use the correct connector number not the entire CCI.
- Call ->read under the PPM lock.
- Remove a bogus READ_ONCE.

Fixes: 808a8b9e0b87 ("usb: typec: ucsi: Check for notifications after init")
Cc: stable@kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240401210515.1902048-1-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1294,11 +1294,13 @@ static int ucsi_init(struct ucsi *ucsi)
 
 	ucsi->ntfy = ntfy;
 
+	mutex_lock(&ucsi->ppm_lock);
 	ret = ucsi->ops->read(ucsi, UCSI_CCI, &cci, sizeof(cci));
+	mutex_unlock(&ucsi->ppm_lock);
 	if (ret)
 		return ret;
-	if (UCSI_CCI_CONNECTOR(READ_ONCE(cci)))
-		ucsi_connector_change(ucsi, cci);
+	if (UCSI_CCI_CONNECTOR(cci))
+		ucsi_connector_change(ucsi, UCSI_CCI_CONNECTOR(cci));
 
 	return 0;
 


