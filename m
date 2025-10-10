Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D0F2F0C63;
	Fri, 10 Oct 2025 13:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102507; cv=none; b=MlHA87hpwN8cut/LcEOJfWMPipsXQ5L+Aiu1vmJwQhnO3LXlsCgSgbdXMxR5+WVnls2m982upg7ecTx5QfSi63VLiu17TbYqEr8FO9cJy2pWZJvGq4B7FygT9YNNwGC3WDyFY9OnlDnjjrB/5JgRWvvBc1ArqOG8+UQOvXDWkpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102507; c=relaxed/simple;
	bh=ZWEVcF9IRCwCNjVs7oj04zo1JsgOqjqVmg3/oIfv+fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVooMYMZXfDWtiaCsaoiP2WVOejQT76bfn2M+9Vr/gDFdoipVMPN4NZqeZnp0RvY/sIxqQzEHdZycoxrxoKlyIVlkfmce+f3k1TEpNydJVj05ZvXpWmGGlwGEu8pw5eIHhQSj3BKkMFJwCZogaXJxiDrZnikdvtctOyfBhlSX4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2nbDwpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2nbDwpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0EDC4CEF1;
	Fri, 10 Oct 2025 13:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102507;
	bh=ZWEVcF9IRCwCNjVs7oj04zo1JsgOqjqVmg3/oIfv+fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2nbDwptQdTc29+ayl5eTIjTyT6bQGmuJBPjPiNiP95LygxN/yk7bAw6Mjj9tm8hl
	 w4Mfwwkbj265aonnW/yvvZVfkJGhZdqfRFdnnwZi/Dubo3ycAiAFa8hnDhItXifw2G
	 a9RVderwGP/BQmKE/EdpraRchd8CxAKza2FBGJdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 26/35] nvmem: layouts: fix automatic module loading
Date: Fri, 10 Oct 2025 15:16:28 +0200
Message-ID: <20251010131332.735840526@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


