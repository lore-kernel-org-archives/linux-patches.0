Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB7A3469EC;
	Tue, 26 Aug 2025 13:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213973; cv=none; b=cE17ywxlrG0GUsp3wgwgzD3Fs9+yToa8l36/PVOIV2ZQDWJgm2sm8C3blng8NlMg3w1v37ZJTvk+MziRbwxUN42ygDaLtc78ReHWphnaOZZh6JV72OBBm3Fj96IDU3pMAGoJiCw9nCntL3Zca/cfI8t0/m+htdWZeq23WKMCEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213973; c=relaxed/simple;
	bh=5aYy8jbJv5fJSCTvfdVT3kfT2ezTzWspFJAwSXxhhx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7FqSGJ99WK1VdBGKmEC96y1pWDf9mFIyds+KTVc1o0OHBLYrOy62NE7+C24Nkc5DK+jKs6qyM41d+EDKmEoAI+9WmVBdICaWj2XgbxQT/kf8JwC51xJERa+lBAnDUCrKly0iWQsPRjKQzRqTwq353Xdg1jqd/qcFXgOplF/Mds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USeyVYGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USeyVYGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5D3C113CF;
	Tue, 26 Aug 2025 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213972;
	bh=5aYy8jbJv5fJSCTvfdVT3kfT2ezTzWspFJAwSXxhhx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USeyVYGJHTPo50QJIJu1pHq0fkAj6Al2oru0/XFBC9EXCheZNSc+RD4TSNIJ9le4g
	 fz6nL03PCM3UrC+wtgU0QR9585nUgQkITOpOur+bc9LOtTdWS0pBbwh77xuWSzks/x
	 AUpn4MjtoHe8ujjAi35sUxCIOQFgM35sMEGiKm+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 6.6 518/587] cdx: Fix off-by-one error in cdx_rpmsg_probe()
Date: Tue, 26 Aug 2025 13:11:07 +0200
Message-ID: <20250826111006.173402439@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 300a0cfe9f375b2843bcb331bcfa7503475ef5dd upstream.

In cdx_rpmsg_probe(), strscpy() is incorrectly called with the length of
the source string (excluding the NUL terminator) rather than the size of
the destination buffer. This results in one character less being copied
from 'cdx_rpmsg_id_table[0].name' to 'chinfo.name'.

Use the destination buffer size instead to ensure the name is copied
correctly.

Cc: stable <stable@kernel.org>
Fixes: 2a226927d9b8 ("cdx: add rpmsg communication channel for CDX")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://lore.kernel.org/r/20250806090512.121260-2-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdx/controller/cdx_rpmsg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cdx/controller/cdx_rpmsg.c b/drivers/cdx/controller/cdx_rpmsg.c
index 04b578a0be17..61f1a290ff08 100644
--- a/drivers/cdx/controller/cdx_rpmsg.c
+++ b/drivers/cdx/controller/cdx_rpmsg.c
@@ -129,8 +129,7 @@ static int cdx_rpmsg_probe(struct rpmsg_device *rpdev)
 
 	chinfo.src = RPMSG_ADDR_ANY;
 	chinfo.dst = rpdev->dst;
-	strscpy(chinfo.name, cdx_rpmsg_id_table[0].name,
-		strlen(cdx_rpmsg_id_table[0].name));
+	strscpy(chinfo.name, cdx_rpmsg_id_table[0].name, sizeof(chinfo.name));
 
 	cdx_mcdi->ept = rpmsg_create_ept(rpdev, cdx_rpmsg_cb, NULL, chinfo);
 	if (!cdx_mcdi->ept) {
-- 
2.50.1



