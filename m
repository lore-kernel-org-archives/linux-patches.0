Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2D82451C8;
	Tue, 20 May 2025 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749512; cv=none; b=taUjGtIJAXu8j3c+nCXY4hQUvSuhUzY72U4N1R1H8vJM3SUNDC6xQKmqXwJwgOUOJfTRWGvwzKPt7KcZwyaTQxE/SJY7rzuG3Cs3sOyX6KeyYLEWXxTlCn0/5MB3h//PquwNFRswKD0VDwFlE1Ym6eY3mQBZ0fv+4mHTyvh4f5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749512; c=relaxed/simple;
	bh=LO9ZJJ+j1NPsKRh8CxnT0t7BFdl56UiSkKozkY1yCbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USlJkrnBVfCR13Gd8PAT9sxVuG9Ad1SfMZi/dFPNmlTIyq7mUnbF3dMbmDrSq1Vl7lm330J1AUAPqW6Oqm+FCnFHzJIqTosASAGG1VEGfxN7RBIyLuUMULs0mNp84y6z8t+cyWmMMWGfYAIF+NuwsaDBDa43+LFD331jsjv5MMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5BmfWlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5BmfWlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C67C4CEEB;
	Tue, 20 May 2025 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749512;
	bh=LO9ZJJ+j1NPsKRh8CxnT0t7BFdl56UiSkKozkY1yCbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5BmfWlpAs6hBgG3yqdCA6A8qkZNHSALPjePqMQilSj8cAOUgHDr7SQ79xmVSZol9
	 dw4cMgIE+S9w0J0NiIcQKG7Yi5SvmYj83zF4IejefXr9c6eHOZIgoT45m41wjzqTQT
	 +SFQdB0b5rUXkC3VPdk9yyqJXIhHIw9U7aZKDykc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 69/97] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
Date: Tue, 20 May 2025 15:50:34 +0200
Message-ID: <20250520125803.356330544@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -310,6 +310,7 @@ static int idxd_setup_groups(struct idxd
 		rc = dev_set_name(conf_dev, "group%d.%d", idxd->id, group->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(group);
 			goto err;
 		}
 
@@ -329,7 +330,10 @@ static int idxd_setup_groups(struct idxd
 	while (--i >= 0) {
 		group = idxd->groups[i];
 		put_device(group_confdev(group));
+		kfree(group);
 	}
+	kfree(idxd->groups);
+
 	return rc;
 }
 


