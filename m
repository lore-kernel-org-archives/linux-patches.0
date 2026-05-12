Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79413E5A04;
	Tue, 12 May 2026 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608530; cv=none; b=LzgeJJ2AF6mfCVJ0N+D6Jy821QJBPxc2jCaEtU8clIfJ1+gUwOo6S2JH5WjaomxEnHWtvreFV4HjCeTVIh9w4O/qMlMYPvHJqEXVbg2D4ulQ8Yuyh1OqY3fYpIXEjMQyD6DBXD2n0cjdfCsle+K7s4JnBbSphwIrS9H8qi/Tyxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608530; c=relaxed/simple;
	bh=K+XFbcjyz7At82nCvTdANR+dzLp+HrKsifrOu0OWx3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjVgH2iRqHjcztPgg6Q/ACSQy97JKWBXiV+4anRB3C3n/UQk/EMeXVHveIY7+VS3fHnTscpMBvVg+SKpWO5XagXYfnWpVZL8R3yLQDu1jLLkkSYUYw0cRkHQo3UsUf3HKOtMcwV03yRqCly/uZT/UgHBhQzMucOUzVFbcJIaQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xlf12YUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xlf12YUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D986C2BCB0;
	Tue, 12 May 2026 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608530;
	bh=K+XFbcjyz7At82nCvTdANR+dzLp+HrKsifrOu0OWx3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xlf12YUv+NZ1etIc3umcaQ84L6S2FOyUjm4cjeGtA8qPSEK4XVu/2DciUUrVXJfJV
	 zMZgU0no+jdnzott7roP6kR5/cIFniid0sS99MdCFGE2Pv1tQPkjAbP5/xgXcJOJlt
	 fXEXxLR6eSEZJ8J+K7UBOEpq/r7Zwj36qFvS/qLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 114/270] pmdomain: mediatek: fix use-after-free in scpsys_get_bus_protection_legacy()
Date: Tue, 12 May 2026 19:38:35 +0200
Message-ID: <20260512173940.859094222@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit ec1fcddb3117d9452210e838fd37389ee61e10e8 upstream.

In scpsys_get_bus_protection_legacy(), of_find_node_with_property()
returns a device node with its reference count incremented. The function
then calls of_node_put(node) before checking whether
syscon_regmap_lookup_by_phandle() returns an error. If an error occurs,
dev_err_probe() dereferences the node pointer to print diagnostic
information, but the node memory may have already been freed due to the
earlier of_node_put(), leading to a use-after-free vulnerability.

Fix this by moving the of_node_put() call after the error check, ensuring
the node is still valid when accessed in the error path.

Fixes: c29345fa5f66 ("pmdomain: mediatek: Refactor bus protection regmaps retrieval")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-pm-domains.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/pmdomain/mediatek/mtk-pm-domains.c
+++ b/drivers/pmdomain/mediatek/mtk-pm-domains.c
@@ -757,6 +757,7 @@ static int scpsys_get_bus_protection_leg
 	struct device_node *node, *smi_np;
 	int num_regmaps = 0, i, j;
 	struct regmap *regmap[3];
+	int ret = 0;
 
 	/*
 	 * Legacy code retrieves a maximum of three bus protection handles:
@@ -807,11 +808,14 @@ static int scpsys_get_bus_protection_leg
 	if (node) {
 		regmap[2] = syscon_regmap_lookup_by_phandle(node, "mediatek,infracfg-nao");
 		num_regmaps++;
-		of_node_put(node);
-		if (IS_ERR(regmap[2]))
-			return dev_err_probe(dev, PTR_ERR(regmap[2]),
+		if (IS_ERR(regmap[2])) {
+			ret = dev_err_probe(dev, PTR_ERR(regmap[2]),
 					     "%pOF: failed to get infracfg regmap\n",
 					     node);
+			of_node_put(node);
+			return ret;
+		}
+		of_node_put(node);
 	} else {
 		regmap[2] = NULL;
 	}


