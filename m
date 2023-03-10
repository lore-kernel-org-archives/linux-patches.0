Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05598484
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D59C433EF;
	Fri, 10 Mar 2023 14:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457260;
	bh=/ISt0GTpFYVXOAsQAa23iQD4POWGA3YHPQzB8KAXXK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4CIqXyOBPxc0Kq7GYFQL8dSQxVLt3j792QGMchEXbMWK0p9c1/hbbZfnwxco8lXW
	 9mXH2CkhVMB92LYTd2ZKM/o/b6BwtcRT2tEsQmbCEzajQ+c4c7zmA+/WqjEsbsHhgV
	 J8xhel5YCCxM8vok6xzV/0AugE71ebZv0JcN270c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Simon Horman <simon.horman@corigine.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/200] 9p/xen: fix connection sequence
Date: Fri, 10 Mar 2023 14:38:03 +0100
Message-Id: <20230310133719.444753323@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

[ Upstream commit c15fe55d14b3b4ded5af2a3260877460a6ffb8ad ]

Today the connection sequence of the Xen 9pfs frontend doesn't match
the documented sequence. It can work reliably only for a PV 9pfs device
having been added at boot time already, as the frontend is not waiting
for the backend to have set its state to "XenbusStateInitWait" before
reading the backend properties from Xenstore.

Fix that by following the documented sequence [1] (the documentation
has a bug, so the reference is for the patch fixing that).

[1]: https://lore.kernel.org/xen-devel/20230130090937.31623-1-jgross@suse.com/T/#u

Link: https://lkml.kernel.org/r/20230130113036.7087-3-jgross@suse.com
Fixes: 868eb122739a ("xen/9pfs: introduce Xen 9pfs transport driver")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 80cc0289dd0d6..75c03a82baf38 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -371,12 +371,11 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 	return ret;
 }
 
-static int xen_9pfs_front_probe(struct xenbus_device *dev,
-				const struct xenbus_device_id *id)
+static int xen_9pfs_front_init(struct xenbus_device *dev)
 {
 	int ret, i;
 	struct xenbus_transaction xbt;
-	struct xen_9pfs_front_priv *priv = NULL;
+	struct xen_9pfs_front_priv *priv = dev_get_drvdata(&dev->dev);
 	char *versions, *v;
 	unsigned int max_rings, max_ring_order, len = 0;
 
@@ -404,11 +403,6 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 	if (p9_xen_trans.maxsize > XEN_FLEX_RING_SIZE(max_ring_order))
 		p9_xen_trans.maxsize = XEN_FLEX_RING_SIZE(max_ring_order) / 2;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->dev = dev;
 	priv->num_rings = XEN_9PFS_NUM_RINGS;
 	priv->rings = kcalloc(priv->num_rings, sizeof(*priv->rings),
 			      GFP_KERNEL);
@@ -467,23 +461,35 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 		goto error;
 	}
 
-	write_lock(&xen_9pfs_lock);
-	list_add_tail(&priv->list, &xen_9pfs_devs);
-	write_unlock(&xen_9pfs_lock);
-	dev_set_drvdata(&dev->dev, priv);
-	xenbus_switch_state(dev, XenbusStateInitialised);
-
 	return 0;
 
  error_xenbus:
 	xenbus_transaction_end(xbt, 1);
 	xenbus_dev_fatal(dev, ret, "writing xenstore");
  error:
-	dev_set_drvdata(&dev->dev, NULL);
 	xen_9pfs_front_free(priv);
 	return ret;
 }
 
+static int xen_9pfs_front_probe(struct xenbus_device *dev,
+				const struct xenbus_device_id *id)
+{
+	struct xen_9pfs_front_priv *priv = NULL;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = dev;
+	dev_set_drvdata(&dev->dev, priv);
+
+	write_lock(&xen_9pfs_lock);
+	list_add_tail(&priv->list, &xen_9pfs_devs);
+	write_unlock(&xen_9pfs_lock);
+
+	return 0;
+}
+
 static int xen_9pfs_front_resume(struct xenbus_device *dev)
 {
 	dev_warn(&dev->dev, "suspend/resume unsupported\n");
@@ -502,6 +508,8 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
+		if (!xen_9pfs_front_init(dev))
+			xenbus_switch_state(dev, XenbusStateInitialised);
 		break;
 
 	case XenbusStateConnected:
-- 
2.39.2



