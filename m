Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8349442FD7;
	Thu, 30 Jul 2026 15:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425142; cv=none; b=Y6x7hSB+Ppa3stAKwppcrdlvK7YSPcDYZd8Q9Tim2CTnDauGKODJq1PPl1XOZMEvap+HrUXta/7bn94CfBDh6dVYtqYdE/dDVpxKD7KmR8EgqPkeaeRkPG7Jir5fOdgm7XgDgD2eNq2VlIv9plHG8GvJVDh/jtKkXn5AnHI/BQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425142; c=relaxed/simple;
	bh=tohJm1nmHpFtV95wSvRshVQ5f0zFcurlPCl5UgrVP5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj0gc/nP6SSZwnt5c53XN0CKU++qN3wqn92z+HKlGL26XXDOyQBlEUcUdtqknd6BLErgKjru8/QMxZ8plGj+/ZdowB0LvDBQPYYWEa31p9/ANuhZn92L1RFz1bxj1M73/g9WT/R/NzCrsIMSXcSOXf8gYTNogdqOeJEW/coH9Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQPv6Rf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQPv6Rf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1946D1F000E9;
	Thu, 30 Jul 2026 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425141;
	bh=Wo9nb0i03jJYZ8kMvyphFz0eV4oaska2oMX7/9mpBoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQPv6Rf7OsJ4B+i6bAbdd4LYf+27XSOgzT2YVBMrzFNag6YiKlIZs1jnWzbDw/JTX
	 j2OodWYkj7+LW5nc2Jq/SFClqxqPBPbwgNbEyxQYbO6xKLVi3JPO9jmuXiKxTDK6Y6
	 tEZjZIb2PmuJlOTVJRj5K/tdgYOIcyWeVQdEHqJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 637/675] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Thu, 30 Jul 2026 16:16:07 +0200
Message-ID: <20260730141458.669705189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1012,6 +1012,7 @@ static void tb_service_release(struct de
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 const struct device_type tb_service_type = {
@@ -1120,7 +1121,7 @@ static void enumerate_services(struct tb
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);


