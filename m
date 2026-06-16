Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A253A451D;
	Tue, 16 Jun 2026 17:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632754; cv=none; b=l5nik8b1GOltBCSS23YH3hNhpK2LF+NZe4Y62fmRqo8uWEFJtDf7Jy8HeMq1kHT+oJ0sCt7L1qMFINIQyxGtfowZFJnvLGnT2gSS4GsIFiXQ8F9+bT5e2W6j7X+mhrcy3cs3tNtJGOz2+w7WkmDH2DIuHwREs/7RPoXOy0LpX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632754; c=relaxed/simple;
	bh=gtqh2VXTxcUwU8CBJGSKLs7BPVaaELKujyLCOj++B4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icpR8+gEU192b+PsiK9el78vgPA3VoKJ9OikGH6ltCxnIiIkwL7hGisNFCz5BO7WXgWIK5uAHcwUTq4zZc2tg5NFMf8BcdYtsJjZ648obbwdxdoTHlz8uuY0DtzqVuVnw7gR9NPLbh71BaokdDvfXSghc7WkdM2/e5QfH9L6vr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hpg+uNwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hpg+uNwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7475D1F000E9;
	Tue, 16 Jun 2026 17:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632753;
	bh=u1z8ck2ZXf4hNTtjPxmHVb3/oLSD/IbaK+JRZ6zG2H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hpg+uNwunFz6RPpZrvV2G/cbSRwVugIrpsIN01UJQDk4UHtWlkYtS699TYml2WvSw
	 g87jftg9HNmkp5KV+AVngjDXz3BZYig0k//h6NS7EWBiXnjG6r9cEZBhc/kjqO0jeE
	 fFRYxa0fvYE6Kl1pJRUYTngOrbaASK1nd73lS4nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 443/522] octeontx2-af: replace deprecated strncpy with strscpy
Date: Tue, 16 Jun 2026 20:29:50 +0530
Message-ID: <20260616145146.664195152@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1228,8 +1228,6 @@ static inline void link_status_user_form
 					   struct cgx_link_user_info *linfo,
 					   struct cgx *cgx, u8 lmac_id)
 {
-	const char *lmac_string;
-
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
 	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
@@ -1240,12 +1238,12 @@ static inline void link_status_user_form
 	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
 		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
 			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
-		strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
+		strscpy(linfo->lmac_type, "Unknown", sizeof(linfo->lmac_type));
 		return;
 	}
 
-	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
-	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
+	strscpy(linfo->lmac_type, cgx_lmactype_string[linfo->lmac_type_id],
+		sizeof(linfo->lmac_type));
 }
 
 /* Hardware event handlers */


