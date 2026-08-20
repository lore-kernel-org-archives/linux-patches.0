Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294DA46D0BD;
	Thu, 20 Aug 2026 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243537; cv=none; b=UURT1WeNpg/dClaT4OSJSUIGwj19Y4mrTULWKYTppqNIxE+GltuthHdjzUPIIy1U7yZKkVabEt8PSo01ibvhiITRLNggSTGKoDPHptC5WGCx94z13fzbA5JAGeZwSCeTCDUI3uwVfeTiatIc77AZIuH2LbldX6NkM7/ctE7bCH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243537; c=relaxed/simple;
	bh=zFSIQC6orEd0TcjOhIqv7xWP1U9ddLnvMJODs4w6ARA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn86WNgA0DL4tIxK/siy4Ds5sGakac0XB+pvm6vvOmSkZIkzLRHzg3FMIBx1FR0jhsmNiHRjlgsQiU7Z+w3lwHCRfPe5HTljnR4wWBLO6uaCFik7BtjMHfLEy2485eolDjTeNCpEu+iBgB3cXhlMVdwOaGLILGejJrbKVFMxbq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIyENIzt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIyENIzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845C71F000E9;
	Thu, 20 Aug 2026 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243536;
	bh=Y5TaPt+IH+2m2kZ5vntRgZoAGmWWzQRBP4djDzECiQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIyENIztV2AbvH9+dE9KsV50gXbumTD6tohfbjDqoO4tS3qAtp4gVLcPPcaeo+Iwd
	 SqCKFB3XuJT6WWhMLpUMWCkkjHbYkEYu4/dRFItdyRir2lzjIKgYa+SNMoCcCK0UJ0
	 iBmIOd3QiOZWvRLVmhMtW3LKGVH0wPsh/psUxkgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/272] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Thu, 20 Aug 2026 16:55:13 +0200
Message-ID: <20260820145235.131056438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
@@ -811,6 +811,7 @@ static void tb_service_release(struct de
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 struct device_type tb_service_type = {
@@ -919,7 +920,7 @@ static void enumerate_services(struct tb
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);


