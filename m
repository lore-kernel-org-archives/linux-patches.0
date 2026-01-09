Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1EA33B97F;
	Fri,  9 Jan 2026 11:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959961; cv=none; b=DGi4ruNwcnpPAvLJ8kedzaA1dMB6+YFg8cUCLA1bfbnKonokw3xHbPaZUSEPmPGqCEfMn3UKO1jMnkS5BnoXNdZMdbvJcw+Rb2BLtMuOjghiDCW0kmFUCFW5/sqvri/Cff72RhoQUjRLhDOpiJ2aks/ALh1ILntJTJmL9oKK2xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959961; c=relaxed/simple;
	bh=t1OiQLYvfV8S1fbYgrBlnq9yGLNSFT2krUsYS2jazoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUIDetGdXrd4WPl9+ksS21vT597kMMpK04z2ngyi5ibpLC7GQwcQr1zMSMwnvVhrMQI1BFz6nhr9enOXSuqTpShqxxEdLyZwZUttEzbE6BOLPD9evHUfnq26VYLCnI2vGVrJCCsLgDRZo8gtundxm61RyJFgo4huXRZPdc8weBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vd8+fWU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vd8+fWU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AE0C4CEF1;
	Fri,  9 Jan 2026 11:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959961;
	bh=t1OiQLYvfV8S1fbYgrBlnq9yGLNSFT2krUsYS2jazoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vd8+fWU7GI1ra+Q+UC7K319Z3kgBBJv15R9UgdpMqc0WOsDenJBQ75W0YXoua/bU7
	 vWurDw86ny28YvY0w0stbomr1vpaIQ4296ltdHLx1VVLNTALoVIg76ncIau0x44flM
	 hM9HxEqfkjArH5m6EBC8y9gZ71+Ih6D7eV8C0LPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/737] resource: Reuse for_each_resource() macro
Date: Fri,  9 Jan 2026 12:36:15 +0100
Message-ID: <20260109112142.875951386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 441f0dd8fa035a2c7cfe972047bb905d3be05c1b ]

We have a few places where for_each_resource() is open coded.
Replace that by the macro. This makes code easier to read and
understand.

With this, compile r_next() only for CONFIG_PROC_FS=y.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230912165312.402422-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6fb3acdebf65 ("Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 6506839f8a811..79fba72cb7d2e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -77,13 +77,6 @@ static struct resource *next_resource_skip_children(struct resource *p)
 	     (_p) = (_skip_children) ? next_resource_skip_children(_p) : \
 				       next_resource(_p))
 
-static void *r_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	struct resource *p = v;
-	(*pos)++;
-	return (void *)next_resource(p);
-}
-
 #ifdef CONFIG_PROC_FS
 
 enum { MAX_IORES_LEVEL = 5 };
@@ -91,14 +84,26 @@ enum { MAX_IORES_LEVEL = 5 };
 static void *r_start(struct seq_file *m, loff_t *pos)
 	__acquires(resource_lock)
 {
-	struct resource *p = pde_data(file_inode(m->file));
-	loff_t l = 0;
+	struct resource *root = pde_data(file_inode(m->file));
+	struct resource *p;
+	loff_t l = *pos;
+
 	read_lock(&resource_lock);
-	for (p = p->child; p && l < *pos; p = r_next(m, p, &l))
-		;
+	for_each_resource(root, p, false) {
+		if (l-- == 0)
+			break;
+	}
+
 	return p;
 }
 
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct resource *p = v;
+	(*pos)++;
+	return (void *)next_resource(p);
+}
+
 static void r_stop(struct seq_file *m, void *v)
 	__releases(resource_lock)
 {
@@ -336,7 +341,7 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 
 	read_lock(&resource_lock);
 
-	for (p = iomem_resource.child; p; p = next_resource(p)) {
+	for_each_resource(&iomem_resource, p, false) {
 		/* If we passed the resource we are looking for, stop */
 		if (p->start > end) {
 			p = NULL;
@@ -1684,13 +1689,12 @@ __setup("reserve=", reserve_setup);
  */
 int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 {
-	struct resource *p = &iomem_resource;
 	resource_size_t end = addr + size - 1;
+	struct resource *p;
 	int err = 0;
-	loff_t l;
 
 	read_lock(&resource_lock);
-	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+	for_each_resource(&iomem_resource, p, false) {
 		/*
 		 * We can probably skip the resources without
 		 * IORESOURCE_IO attribute?
-- 
2.51.0



