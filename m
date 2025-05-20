Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B1E242D7D;
	Tue, 20 May 2025 13:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749251; cv=none; b=bLmCINCeuCxlKEruhem/GTGJxbco+VS6ZJVsqpnU7iNeomGTliiqP++Bla/fRozu1ibaIDqoWzx2y3Tsw4S3YB+lCJCOMXh5rk7YqtKhvd9GAy4bX4VX2s4bxrNbp2WXSGHWnxJ8lsKn2UQDnF0PT5T62E80QcHmjia/bUEer4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749251; c=relaxed/simple;
	bh=rWGUNIo0GOdNmg/dFrsLdpZbMTfqobSUVa97qA0wKyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gl8Kzv5xiQ6aOcWe8HeKRgCNGEgYsj+r4Hfx78cqbffm2E+wQZORHtgbFIODPTaRedb5uZehyU08wBXUGTuk+AV3/AbRzZf6+jB5cBN0G0bttg4yNu1i292yN9FlbHBTQi21uqqURfURvq+GWwFQ/kCbbitC+56UNcpQGmmAyLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8KZ4LZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8KZ4LZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA42C4CEE9;
	Tue, 20 May 2025 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749251;
	bh=rWGUNIo0GOdNmg/dFrsLdpZbMTfqobSUVa97qA0wKyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8KZ4LZLobnrwWH77RL7goF3W6le7sLYrTZ0/6XyoM3ibNUnQn+y4+UD4owLSwRWv
	 uLWUECR7ABeAdDsKJybUZh3A0V7LwTeJqTCp8O3j9pLlXHSX0S1yjFs4pWdR2VWu0h
	 sYh6y617C02htH3ZhaYh4SrvY+Gtb4inh86S601o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 44/59] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
Date: Tue, 20 May 2025 15:50:35 +0200
Message-ID: <20250520125755.593144832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -289,6 +289,7 @@ static int idxd_setup_engines(struct idx
 		rc = dev_set_name(conf_dev, "engine%d.%d", idxd->id, engine->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(engine);
 			goto err;
 		}
 
@@ -302,7 +303,10 @@ static int idxd_setup_engines(struct idx
 		engine = idxd->engines[i];
 		conf_dev = engine_confdev(engine);
 		put_device(conf_dev);
+		kfree(engine);
 	}
+	kfree(idxd->engines);
+
 	return rc;
 }
 


