Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1099D1BC08A;
	Tue, 27 Aug 2024 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771607; cv=none; b=AB2N/HOrW9OOyKDBsfI8dYmqPtDei0fEj4qhI9WZyUdFLgO5At4xwwapOm3hEILt8QOWI0BzHRDT1rB4Z1mt10664n8O04SZ56+d7Ljy6yQRm5nRMPMICDujw47qGtOq6Xbl0o6WKvVTINsGRHAgUAFlbMctNwDXX1nRRiikGDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771607; c=relaxed/simple;
	bh=64aYKj6asY+3qfeHeLKiHIGfDr0YSawTztjf5oqU8FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU1ZdU8cZScZASFRysUvM4A6786JFQhQCtAdMTsEU5xSzwsBSnJ0i7DSAgXmF2lerNQLDOX8XAeCgEgT2NPsblgZF+ELst9o0sb2nviQG7kChxqSnbXrtvSa5iNgM1m2NGdHe9d2jf6IjSPxwIILRv2Tj7keD+lqaAytE8TPH+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fw6nXA0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fw6nXA0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3BAC6105E;
	Tue, 27 Aug 2024 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771606;
	bh=64aYKj6asY+3qfeHeLKiHIGfDr0YSawTztjf5oqU8FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw6nXA0A4By8ll8V72Hj31LnN4cGdM8QN/n378z6tDyBRi3G/w/41pLjBWuhzej61
	 m4eRDzkn1Rzy/xNeDXBf4q4XGma7Hj4M2XMCvmQjVgfP1eJhjhGcXI/FbgQ79i5f2i
	 1L/3sQJ4KW3KMD+s5s5HZvIyvr6OY6HKIgYGlw+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.10 232/273] s390/ap: Refine AP bus bindings complete processing
Date: Tue, 27 Aug 2024 16:39:16 +0200
Message-ID: <20240827143842.235750355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit b4f5bd60d558f6ba451d7e76aa05782c07a182a3 upstream.

With the rework of the AP bus scan and the introduction of
a bindings complete completion also the timing until the
userspace finally receives a AP bus binding complete uevent
had increased. Unfortunately this event triggers some important
jobs for preparation of KVM guests, for example the modification
of card/queue masks to reassign AP resources to the alternate
AP queue device driver (vfio_ap) which is the precondition
for building mediated devices which may be a precondition for
starting KVM guests using AP resources.

This small fix now triggers the check for binding complete
each time an AP device driver has registered. With this patch
the bindings complete may be posted up to 30s earlier as there
is no need to wait for the next AP bus scan any more.

Fixes: 778412ab915d ("s390/ap: rearm APQNs bindings complete completion")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/ap_bus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 0998b17ecb37..f9f682f19415 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -971,11 +971,16 @@ int ap_driver_register(struct ap_driver *ap_drv, struct module *owner,
 		       char *name)
 {
 	struct device_driver *drv = &ap_drv->driver;
+	int rc;
 
 	drv->bus = &ap_bus_type;
 	drv->owner = owner;
 	drv->name = name;
-	return driver_register(drv);
+	rc = driver_register(drv);
+
+	ap_check_bindings_complete();
+
+	return rc;
 }
 EXPORT_SYMBOL(ap_driver_register);
 
-- 
2.46.0



