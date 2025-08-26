Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A61B3002D2;
	Tue, 26 Aug 2025 11:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208721; cv=none; b=h0a9kLLKftDG/7874NQ+ncopvrjMwbROJaA5LeSW/zBrJWTMKHsGW6GIcTBggaFJsmTZ+iXIwFCau8GTScb0yMzLzPOr/U1mWOZBL8+RixJpGy99h1Oe2JjMB3sD33On7IvhbiSFxwb/157yC3FHWxDOE6vQuhIa/FwABr344Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208721; c=relaxed/simple;
	bh=iE7ttiwl+gqK1Y9S5+o9H+pQYR0glhGZZEzUE4nUuUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo7BLH7pzQx2RZbTR1Wm3woZT1eIjv1/lY7REmGgdtygZa8ijPWurYHFZ5ZdbKmgvFpDzPU/BHemKuRBaQYbrRwt0VPKlBeUwelT+doY6PodFr7q/8Y/B6GUxUGQL5J2cqF+vyaUI/ylG1hulUwmDJ+IYsFm/BwkcQPBu65gFy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovRg/KYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovRg/KYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502CCC4CEF1;
	Tue, 26 Aug 2025 11:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208720;
	bh=iE7ttiwl+gqK1Y9S5+o9H+pQYR0glhGZZEzUE4nUuUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovRg/KYGskMBfUZnIpzdGE1niWWhQzbs4rn+yYvMlB/nAAQLK2A9M4Rq4GZ3HE0Um
	 v29CP8X7H7utYfth2UBBOeytFt76ZSBcFpOZcDu5Fc5KyNpGLkgIGnVDnXd8WzeUIz
	 H3MNXXCrj5oAHSO6XmLEgQUMnprHZa2wpeuz1Bng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 6.12 220/322] cdx: Fix off-by-one error in cdx_rpmsg_probe()
Date: Tue, 26 Aug 2025 13:10:35 +0200
Message-ID: <20250826110921.320673257@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/cdx/controller/cdx_rpmsg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/cdx/controller/cdx_rpmsg.c
+++ b/drivers/cdx/controller/cdx_rpmsg.c
@@ -129,8 +129,7 @@ static int cdx_rpmsg_probe(struct rpmsg_
 
 	chinfo.src = RPMSG_ADDR_ANY;
 	chinfo.dst = rpdev->dst;
-	strscpy(chinfo.name, cdx_rpmsg_id_table[0].name,
-		strlen(cdx_rpmsg_id_table[0].name));
+	strscpy(chinfo.name, cdx_rpmsg_id_table[0].name, sizeof(chinfo.name));
 
 	cdx_mcdi->ept = rpmsg_create_ept(rpdev, cdx_rpmsg_cb, NULL, chinfo);
 	if (!cdx_mcdi->ept) {


