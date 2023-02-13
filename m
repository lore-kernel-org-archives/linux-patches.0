Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459FE8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E69C4339B;
	Mon, 13 Feb 2023 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300617;
	bh=FcxAh5FFxo0L7c0ME5wW2ufvNYVb1VrU28unkTIhWZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ae2VMJllBlsn778E4zyHPicJlaXWcMwo0i0kuraSqmXuE04QgnUcZ3PuvfHkgoH9l
	 AbdZI4yZnYcBYXF09nKISJexZk8xIiFwDAZzJ9WfKUY2BfQfJKVEuOlfT72Rpm/BDj
	 kuEsZ+CzB57SplobzSwe2jQf5NyKvDYk0BzmuYO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 083/139] nvmem: core: fix cell removal on error
Date: Mon, 13 Feb 2023 15:50:28 +0100
Message-Id: <20230213144750.249037695@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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
@@ -695,7 +695,7 @@ struct nvmem_device *nvmem_register(cons
 	if (config->cells) {
 		rval = nvmem_add_cells(nvmem, config->cells, config->ncells);
 		if (rval)
-			goto err_teardown_compat;
+			goto err_remove_cells;
 	}
 
 	rval = nvmem_add_cells_from_table(nvmem);
@@ -712,7 +712,6 @@ struct nvmem_device *nvmem_register(cons
 
 err_remove_cells:
 	nvmem_device_remove_all_cells(nvmem);
-err_teardown_compat:
 	if (config->compat)
 		nvmem_sysfs_remove_compat(nvmem, config);
 err_device_del:


