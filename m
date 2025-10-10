Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4901F63FF;
	Fri, 10 Oct 2025 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102230; cv=none; b=hwrl4yp1qPicwBM/H6CrJZECMVyyAq/Imxeq1Jl1NCYvZtkSfyeGjU2hH6ClDglA9X0VOy9vKYT36259ZpB8u2IrWWE746Sqb4MBtLa/GGr2o52Y6qltRGDBleKIIm5hymgObIzN66BckX9B66Px0QoRUKi9MXnGo3six25gITg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102230; c=relaxed/simple;
	bh=07UUzyLkQDoaXjRGUi9yGE44x6okjuM909djfxyH0v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsXBt1CdhmBKrdxoSc7Ysq2PCiiFzlfNUWc3lVWAadmpps85YamK+xcALnaEz4g/evLxGbkXoddf2onEwTQkbkJXncohYuCVQvB9z/7U/9t5JiSNihX+xtllgonAWZoMn9ph7z5e0DrFvGnHcStfuSciytLLrYw8EqQwer6cgGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwvf944V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwvf944V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE30C4CEF1;
	Fri, 10 Oct 2025 13:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102229;
	bh=07UUzyLkQDoaXjRGUi9yGE44x6okjuM909djfxyH0v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwvf944Ve461hiZhsb6Kn9tu8oeWiJoxsHOSRs3rIaS/TZLmF1WiDq3+JyWug4wfl
	 VEdFOYg6sWmubpv/asBHiXH83px957ksdAYeOYCPFm5oLNyBlNKdDFxJeTKlDRpWIc
	 fcnUyqptI1J1KC/UhaTaWZBnMJd0cDleLHHMWko0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.17 11/26] nvmem: layouts: fix automatic module loading
Date: Fri, 10 Oct 2025 15:16:06 +0200
Message-ID: <20251010131331.621221854@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


