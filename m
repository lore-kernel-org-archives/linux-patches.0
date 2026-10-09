Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3C81A682B;
	Fri,  9 Oct 2026 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556352; cv=none; b=hepl7GLH9e4enlTeaewlFoe4Sj4dhhqR7VKj5LyGUiHnHuKese1YkIQcUU7jRbgHX+q0aJkRY4W++X3nXjmcELztcZ7QezJLy0zPFSX4i+jNWfnLABUIap3o87FUHJOq13uI36sJgvXLilQ+ti5o1rWkNGQzOeHNmJjrfKX2o5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556352; c=relaxed/simple;
	bh=ydfIgtWXrylSPX0chbYT93M8293lxtUSrEWKOdkSUXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYKBHUFbpZRv/WaF8xUT+7XVpLd8v36bxDlZXROUdxR/D0eu5XgM/rnzRYSXzlOhZ+xpNe3BUtET0rkqjGI8qYjl33vGXAyUOAye/XPX7sUPQQuCvtfmABLUDlTlwBafcgbDaye9U02NKq7A90eFYC+NykVDqlTPk7wgzH3Jgsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMqXHv7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMqXHv7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF4C1F00893;
	Fri,  9 Oct 2026 14:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556351;
	bh=gS2dqgtlbOMT0PsQs956qLY616r7a/zlGVKVJbc9OB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMqXHv7my3brxJyU39/U3LkvXEzXog9EhMOMe9FQQ9GXBQ/8eXNiWHI6yFw52sOHK
	 FhUjbQrz6hJHJXUmrnXgKmjRzZEPay0qInAgO2r3wPCxuHohR540f4eVfqDmEQfIpB
	 B/c2iSccjo0kyWQVenMzH89fml0fgDTF1wXkhPj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 220/403] EDAC/altera: Fix memory leak on dci allocation failure
Date: Fri,  9 Oct 2026 16:09:41 +0200
Message-ID: <20261009140957.290684577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

commit 3e4a10a4718e3d963ee4d6c5f26bc5ad57c1d2b1 upstream.

Sashiko reports:

"If devres_open_group() fails, the function returns -ENOMEM without freeing the
dci structure allocated earlier with edac_device_alloc_ctl_info()."

Free the dci structure if devres_open_group() fails.

Fixes: c3eea1942a16 ("EDAC, altera: Add Altera L2 cache and OCRAM support")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # 6.18+
Link: https://patch.msgid.link/20260911120627.2634225-4-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1516,8 +1516,10 @@ static int altr_portb_setup(struct altr_
 	altdev = dci->pvt_info;
 	*altdev = *device;
 
-	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL))
+	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL)) {
+		edac_device_free_ctl_info(dci);
 		return -ENOMEM;
+	}
 
 	/* Update PortB specific values */
 	altdev->edac_dev_name = ecc_name;


