Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728EB509EF3;
	Wed, 30 Sep 2026 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784212; cv=none; b=SpoUg+X9xTF9Uqv+4Pay+TNkTMX/cM0qmDv4KvEMN7jrjlZcrVki20eJeYlT4Lj5L99RZp8R1HtuDmqwoVegUkUGoJxnAyIhkwsBGIc7aEz/D6HFpIuFZABtnye8sxuuyCSWVHl0k6xpBYilzvQ7CSfdgW8fTnnVTguaYEQe+HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784212; c=relaxed/simple;
	bh=A4/YewqPPnAHszdQ482qdvEFJfEWqojEbb98xsMxG6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kA6yfyWtDJslM5jaC3Xz2sQINL+CZ7RknV86e5x5puwCtVLfRSnprfYusBOj05GUHo5PyhuUA0U4Rh1lG+MtVb5PEEuE43CY8gHy+WevuhIdlLn609WeoChVVOHUoncW6ii2kPS7QvXS5PSSbTiLWH2iKuePuwXcX/qkvAQwrdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPMzp65+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPMzp65+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD8E1F000FF;
	Wed, 30 Sep 2026 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784210;
	bh=I8i0kFeBYr2NlA+SOID06UXlioIKK0tW/xgixKG9XpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPMzp65+wfQevsI0kbuWnMEzfz/2Sx/puiaTya7bhrMC9YUZAefcvlHXZAaEVphs4
	 sU3fuHI28EF1F893C8n66+2zQGZloNm7q9nDBMrUzICxsnm/f/n3H5Uiw4BvB2eGD9
	 XPIxHbtRDvh2Vdv70HIWxrDiixi9z1nUUI7eymNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/982] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Wed, 30 Sep 2026 17:12:35 +0200
Message-ID: <20260930152417.199687785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/xdomain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 6a003316b878b..58c91423e4f07 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1026,6 +1026,7 @@ static void tb_service_release(struct device *dev)
 	ida_simple_remove(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 struct device_type tb_service_type = {
@@ -1134,7 +1135,7 @@ static void enumerate_services(struct tb_xdomain *xd)
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);
-- 
2.53.0



