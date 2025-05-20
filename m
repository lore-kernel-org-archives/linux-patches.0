Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1C819F137;
	Tue, 20 May 2025 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749255; cv=none; b=HjVBBfhrC83QVA62Q4a+DvuFVftA+WNVZYZfvtldT0XGALodTHXv3lqQDECcNOlhIgbMh/D/R62p9PUvRZibzPhz1Jq0wh3Ug2rREkFYsi4CV0ykObvITuWyih+IM0gMcGaTqdy9uxFMvdAMSF+yoa+Snu93Z3whfSgnFJVPrMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749255; c=relaxed/simple;
	bh=+tBx2R5yLNxtN1vc1hUfuyQ6Rj0o+O/Z56szf3e+OLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAKNuLH5eu43RkBCQAy23b44Z81ewMNC1VGif/v30fh6tNtbh0kE7AZyciT5P0eBkO8LNOM3VkER1cjT+mrFyFFoRCvsrsiAbOtNtiucfDXJs9LCtKPbEubWsR+sC/zcIJ4xwiMP8ZaNjFBr2nZHHomctYNL+tHrA/RridAm5mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KspfqqZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KspfqqZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C45C4CEE9;
	Tue, 20 May 2025 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749254;
	bh=+tBx2R5yLNxtN1vc1hUfuyQ6Rj0o+O/Z56szf3e+OLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KspfqqZpZpj0NPO5/lzeZz5RY7s6ZMgqw1gPP5YY93s5bKmbduFdVMuAXWEQX2Cfq
	 Xt/hAgTUgeSsUVtbOm6GMHm2Eep5/eod+xxqH81R8t9s+4l+2oO5QgDxnFY4GXiCqg
	 651MhcJ/lcuTttO6XPNZBpVd+Tov8RiT/etWqTl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 45/59] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
Date: Tue, 20 May 2025 15:50:36 +0200
Message-ID: <20250520125755.634281711@linuxfoundation.org>
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
@@ -340,6 +340,7 @@ static int idxd_setup_groups(struct idxd
 		rc = dev_set_name(conf_dev, "group%d.%d", idxd->id, group->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(group);
 			goto err;
 		}
 
@@ -359,7 +360,10 @@ static int idxd_setup_groups(struct idxd
 	while (--i >= 0) {
 		group = idxd->groups[i];
 		put_device(group_confdev(group));
+		kfree(group);
 	}
+	kfree(idxd->groups);
+
 	return rc;
 }
 


