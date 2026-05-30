Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3976E2628D;
	Sat, 30 May 2026 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163676; cv=none; b=tJc1dAuENWt6nSus25QFnUvxE5mM5qcH6QE7gj98eYCTEgkLe+KeGQMZuU01KYYE0JBkQj39SBWL2EG/mJ2nlgTqXNKf1H/ubr8IhK70T8T87UveDVe3ce9/PKBo1l91FjHaV38W3jDh4V5GTjczXMi88Hi2Ff4BOC/75v9p1to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163676; c=relaxed/simple;
	bh=qATxPr7tuiI9/KLjHuWxKmFD9qOPcir++BxCkTopnow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCpUCo/gg6ZUHcBBEizykMTBAZ2Rg0Dwaiaxt92uimtJ3qAayD5r7yobdYgz03o5qrih9K/6wOqkM8T18vhwaiwrI6x+585LWNEFnCXuXZd3oqr3egiTJWwj8sja5GVzuRdc9nPOSZXrDEpvyYWxmBzSj5+dDVIZrDboUi5W9Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6hCgb6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6hCgb6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760151F00893;
	Sat, 30 May 2026 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163675;
	bh=Uavf3k8IK/aRwxAyGoMsL/ym1W0iSxBIL57e+UzWrCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6hCgb6i4i7I9d4Ic6/2h3Mz/ygH289Y4oEMjNVBlO1srcFpCPsyAJyIwYcu/Nn2U
	 5IZ2/6A2GbdbQtmdu9ODaFz+JC+N2WxIkazC1IYWQCPbuzdDe6I1B/SIDaRXQsv2cL
	 jKE1PNJhmyQIqQ65EHJwpXkKmn8CO8z0Ee7eD398=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 299/776] usb: ulpi: fix memory leak on ulpi_register() error paths
Date: Sat, 30 May 2026 18:00:13 +0200
Message-ID: <20260530160248.292298821@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 0b9fcab1b8608d429e5f239afb197de928d4de7d upstream.

Commit 01af542392b5 ("usb: ulpi: fix double free in
ulpi_register_interface() error path") removed kfree(ulpi) from
ulpi_register_interface() to fix a double-free when device_register()
fails.

But when ulpi_of_register() or ulpi_read_id() fail before
device_register() is called, the ulpi allocation is leaked.

Add kfree(ulpi) on both error paths to properly clean up the allocation.

Fixes: 01af542392b5 ("usb: ulpi: fix double free in ulpi_register_interface() error path")
Cc: stable <stable@kernel.org>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260407-ulpi-v1-1-f3fafe53f7b2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -244,12 +244,15 @@ static int ulpi_register(struct device *
 	ACPI_COMPANION_SET(&ulpi->dev, ACPI_COMPANION(dev));
 
 	ret = ulpi_of_register(ulpi);
-	if (ret)
+	if (ret) {
+		kfree(ulpi);
 		return ret;
+	}
 
 	ret = ulpi_read_id(ulpi);
 	if (ret) {
 		of_node_put(ulpi->dev.of_node);
+		kfree(ulpi);
 		return ret;
 	}
 


