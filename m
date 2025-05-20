Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2392BEEDE;
	Tue, 20 May 2025 14:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749899; cv=none; b=J/k5rM0SFxpkorwhrcnsni9Rfh2ukaXBGzBS0L/+tnzmLLZaiSL1OIQTjHLrOsPrQ9vf0EfBTkORNzhXsO8K9ZcQ/OXtk/QOgRxYbcedGeSuczEywQU5WOR6UHeKyUoHqziLtt9nRnbd1RHItWregEyADKozfWfrmB+U7WmzVUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749899; c=relaxed/simple;
	bh=fcRUKLJQ3OOxLndxTFIF60TOV7PiihroP5H2wt9Pp9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM6/t/yrTeKMk9hv3vISZ8EXu23T9D07VYPrEYB/UVJLRTAE9e0tcKIjwjo8R/27fsx1Iw15V7kRRUvJWEOUEsCex6BAEKruqPRD1EYgS2jonHxV0kMOkSv3xrL7IyMrIgjeRcaRoY7Ot56t7WCHmLAuEm9Stw7ULX2fkU4Al1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No2GNND2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No2GNND2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848DAC4CEEA;
	Tue, 20 May 2025 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749899;
	bh=fcRUKLJQ3OOxLndxTFIF60TOV7PiihroP5H2wt9Pp9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No2GNND2ZySIXqdLmAsPfAzHs9gejMdWzj5PHBkXNpNhcOOKew8+mg7MXL6UNIgx8
	 qxqZBUfWFkOFOICADDgSkgO/2tNNVzLoS2UuAtUPR0477JkKN1cf7BuiLt7RUwiBKR
	 S0OSlac9pedWroehCdRyBcLJlOjECvtDSGPkVHhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 096/117] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
Date: Tue, 20 May 2025 15:51:01 +0200
Message-ID: <20250520125807.802393715@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit aa6f4f945b10eac57aed46154ae7d6fada7fccc7 upstream.

Memory allocated for groups is not freed if an error occurs during
idxd_setup_groups(). To fix it, free the allocated memory in the reverse
order of allocation before exiting the function in case of an error.

Fixes: defe49f96012 ("dmaengine: idxd: fix group conf_dev lifetime")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Link: https://lore.kernel.org/r/20250404120217.48772-4-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -316,6 +316,7 @@ static int idxd_setup_groups(struct idxd
 		rc = dev_set_name(conf_dev, "group%d.%d", idxd->id, group->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(group);
 			goto err;
 		}
 
@@ -340,7 +341,10 @@ static int idxd_setup_groups(struct idxd
 	while (--i >= 0) {
 		group = idxd->groups[i];
 		put_device(group_confdev(group));
+		kfree(group);
 	}
+	kfree(idxd->groups);
+
 	return rc;
 }
 


