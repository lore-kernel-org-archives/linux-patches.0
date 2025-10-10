Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5E02F6560;
	Fri, 10 Oct 2025 13:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102383; cv=none; b=TYut+IR3XS6f8i6OTGZN3eZ0cQgmPPBfOsGWVdZiaWvBRCnK114jHo6HnWrl5KonYDU0IDDOGfrcMnTLayXgMo18emiSqusv9gbLOZqjJkZ7RDZTQwJ+owMz6+SwOm57Ii2RqRY9PRVVCQeoTsWJQ7fts1hd2ggLHA+8VnVUMBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102383; c=relaxed/simple;
	bh=Byw/6oOdQ4SOxuBp3RlABKDtdO8BhNq67KHJ0V5+sBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf7RIyhL2WWGuruzWReDW0hqgr/WooLu8DC8zCzhYcqRqG2/tGNbsCFryJcg56qg8pAaysGNrqLVfwp1gBs+Qcby1RLr8b4tLuDbHVMUFt84pW4x5EvKDXSnW0Bi9sFFzf9zO6IF4wbzrcq9tqUba/zpoVNL6UQ409sLb8KOEc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PI/hPTeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PI/hPTeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B113C4CEF8;
	Fri, 10 Oct 2025 13:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102382;
	bh=Byw/6oOdQ4SOxuBp3RlABKDtdO8BhNq67KHJ0V5+sBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PI/hPTeEyEej4ZZpHxRwYDZ/PzMNjWowJZGNnLYnhyzKKNCp+3OuxiETs3hmM+tvr
	 hE+ye4YFQe8h81YE56mpN0IG6fJf4/ZywEltpQT70sT2HPffxcKUjuzyH/Za0/aelj
	 qlRLdxDw07hY8QobaZr9XR3VaArVUHX+UdgIlOcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.16 29/41] nvmem: layouts: fix automatic module loading
Date: Fri, 10 Oct 2025 15:16:17 +0200
Message-ID: <20251010131334.471831133@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

commit 810b790033ccc795d55cbef3927668fd01efdfdf upstream.

To support loading of a layout module automatically the MODALIAS
variable in the uevent is needed. Add it.

Fixes: fc29fd821d9a ("nvmem: core: Rework layouts to become regular devices")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250912131347.303345-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/layouts.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/nvmem/layouts.c
+++ b/drivers/nvmem/layouts.c
@@ -45,11 +45,24 @@ static void nvmem_layout_bus_remove(stru
 	return drv->remove(layout);
 }
 
+static int nvmem_layout_bus_uevent(const struct device *dev,
+				   struct kobj_uevent_env *env)
+{
+	int ret;
+
+	ret = of_device_uevent_modalias(dev, env);
+	if (ret != ENODEV)
+		return ret;
+
+	return 0;
+}
+
 static const struct bus_type nvmem_layout_bus_type = {
 	.name		= "nvmem-layout",
 	.match		= nvmem_layout_bus_match,
 	.probe		= nvmem_layout_bus_probe,
 	.remove		= nvmem_layout_bus_remove,
+	.uevent		= nvmem_layout_bus_uevent,
 };
 
 int __nvmem_layout_driver_register(struct nvmem_layout_driver *drv,


