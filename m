Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610A13D810C;
	Tue, 16 Jun 2026 19:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636726; cv=none; b=or18Y3J+6gYxojkKcwHR8yhZ6yMYuRJty73e1t5T5prpcVALwMS+8Ut99iPPDwj4/bNZZg1F19YO+1HYxTAkHmWGkfFg9OHjBMoNHbx8r4rOXVx+iEzSsp28ugWG8DZ0tcL5+yZadvRVL8/hcYd7L7jyjwnM8senswmKE9j+adE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636726; c=relaxed/simple;
	bh=m7QMBbzOrnjrmrFnVZN1Y+sqT4r2cg3WOrQgmSi6ftE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHM7Z5ca/AmV5lfD4bs6BU1KfqWMI/DHpgzUP3FLJMQZYY4sy5V1dJAwFBb5s3iN70WqS8oDT0CxNjO1tBl9oZYiI9wIqOjKhH5I7LHUH21BwchFI9Xw8AT3kDtPum0zBjpJkk3q4M6rbUdfPqBWQaHO0gizmYjxt1LtabttKbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znbiHwWP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znbiHwWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8301F000E9;
	Tue, 16 Jun 2026 19:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636725;
	bh=puSijuDd4gWG63WhNxwgrn1sYjV2V89r9frWhYZxbNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znbiHwWPR/AWMiee55vHqrR37VhuG1OD6H3cop5YbzZLFOXvmiudRWhel6ZlO9zEH
	 pFKCQdJ8XFD/9zvm5N8xgo9CLmT8iZTCLpiTzza9T1cEDF7zQBh3A96ZUAMAwT+nyD
	 p79IINueEmJ7Yih8KfCexrdf+5iAmshEwJtdtapc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/342] octeontx2-af: replace deprecated strncpy with strscpy
Date: Tue, 16 Jun 2026 20:29:50 +0530
Message-ID: <20260616145102.122220199@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit 473f8f2d1bfe1103f20140fdc80cad406b4d68c0 ]

`strncpy` is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We can see that linfo->lmac_type is expected to be NUL-terminated based
on the `... - 1`'s present in the current code. Presumably making room
for a NUL-byte at the end of the buffer.

Considering the above, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Let's also prefer the more idiomatic strscpy usage of (dest, src,
sizeof(dest)) rather than (dest, src, SOME_LEN).

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Signed-off-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20231010-strncpy-drivers-net-ethernet-marvell-octeontx2-af-cgx-c-v1-1-a443e18f9de8@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c0bf0a4f3f1f ("octeontx2-af: CGX: add bounds check to cgx_speed_mbps index")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -679,12 +679,12 @@ static inline void link_status_user_form
 	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
 		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
 			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
-		strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
+		strscpy(linfo->lmac_type, "Unknown", sizeof(linfo->lmac_type));
 		return;
 	}
 
-	strncpy(linfo->lmac_type, cgx_lmactype_string[linfo->lmac_type_id],
-		LMACTYPE_STR_LEN - 1);
+	strscpy(linfo->lmac_type, cgx_lmactype_string[linfo->lmac_type_id],
+		sizeof(linfo->lmac_type));
 }
 
 /* Hardware event handlers */


