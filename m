Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D74248F6E;
	Tue, 20 May 2025 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750341; cv=none; b=e+43pzzh0kgbD5Bg3nCXS6nLfO48PbGZ3xTLYNiuJn0JSBEa90COYjYcNkPP4Nx0WQU9o2JVhRuBBmTteiD7TeIdIJ69A5s1jkyZs3pGPgbFDXe5yeK8nn4mOf5PuXzqzR+44RWc7DYHDILFvAypdhI0pAn2fciX7wfw32F6xXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750341; c=relaxed/simple;
	bh=Y3rwfs3Qqrq1fUfB/nEaJxhWS/NKMQ3FPXjSXNg0YPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6ncFO09xMyKWBzp/bnJOORS8gEaO9dJQwPAbcwtL3M2au7x3SV2mQFShJlMqCA/qL5CEZFxzuk18oDClteAxwYFPziHCie3Cc/GpHd32JoJ0wC5nTiitmlUr7daV7ZuXe3WjTDGQE41plP8jpCI6PF1cMVVdkEdhuOQZfghGUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEk8O3bW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEk8O3bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CC6C4CEE9;
	Tue, 20 May 2025 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750340;
	bh=Y3rwfs3Qqrq1fUfB/nEaJxhWS/NKMQ3FPXjSXNg0YPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEk8O3bWSnzxiH2jkvVGZ/RU4/6ICLBEJvdvNmv98WwMx15i7tL89FbNJKEClT5/Q
	 AGj8wXl2lUkFw+K3avT7vwBVSOKJdl6bqS+kMOmmuk1oywxoxADOGVJIueBYVf7juK
	 /Tn4heiWRAvJJHuq81J23+mUpl855zdgdtu271iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 121/143] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
Date: Tue, 20 May 2025 15:51:16 +0200
Message-ID: <20250520125814.781732565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 817bced19d1dbdd0b473580d026dc0983e30e17b upstream.

Memory allocated for engines is not freed if an error occurs during
idxd_setup_engines(). To fix it, free the allocated memory in the
reverse order of allocation before exiting the function in case of an
error.

Fixes: 75b911309060 ("dmaengine: idxd: fix engine conf_dev lifetime")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Link: https://lore.kernel.org/r/20250404120217.48772-3-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -273,6 +273,7 @@ static int idxd_setup_engines(struct idx
 		rc = dev_set_name(conf_dev, "engine%d.%d", idxd->id, engine->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(engine);
 			goto err;
 		}
 
@@ -286,7 +287,10 @@ static int idxd_setup_engines(struct idx
 		engine = idxd->engines[i];
 		conf_dev = engine_confdev(engine);
 		put_device(conf_dev);
+		kfree(engine);
 	}
+	kfree(idxd->engines);
+
 	return rc;
 }
 


