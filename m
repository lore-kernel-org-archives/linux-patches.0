Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9158B2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19FCC433D2;
	Tue,  7 Feb 2023 13:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775255;
	bh=LIQxXsmKIFeBPBSGKFlNx8nbt9Fi0eq8somYwayTVMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPQfqGGgpaavgIIkr2k0MWICuKqxcPEm8ie+Q639LMvOL8H5O7eLHI6RhYBFkPk1B
	 Dk3lpqxXY6ip+eEcEoeM68ksNH5JGGth+mGeNTzhVi7PaLO4aWHu/ymu4R1hQXVNbb
	 jDNBNpgdQBczdpC5XaMcIS/e++7WWPnb4KQntnfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 189/208] nvmem: core: fix cell removal on error
Date: Tue,  7 Feb 2023 13:57:23 +0100
Message-Id: <20230207125643.035233342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <michael@walle.cc>

commit db3546d58b5a0fa581d9c9f2bdc2856fa6c5e43e upstream.

nvmem_add_cells() could return an error after some cells are already
added to the provider. In this case, the added cells are not removed.
Remove any registered cells if nvmem_add_cells() fails.

Fixes: fa72d847d68d7 ("nvmem: check the return value of nvmem_add_cells()")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-9-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -847,7 +847,7 @@ struct nvmem_device *nvmem_register(cons
 	if (config->cells) {
 		rval = nvmem_add_cells(nvmem, config->cells, config->ncells);
 		if (rval)
-			goto err_teardown_compat;
+			goto err_remove_cells;
 	}
 
 	rval = nvmem_add_cells_from_table(nvmem);
@@ -870,7 +870,6 @@ struct nvmem_device *nvmem_register(cons
 
 err_remove_cells:
 	nvmem_device_remove_all_cells(nvmem);
-err_teardown_compat:
 	if (config->compat)
 		nvmem_sysfs_remove_compat(nvmem, config);
 err_put_device:


