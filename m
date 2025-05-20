Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D753242907;
	Tue, 20 May 2025 14:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750344; cv=none; b=YmE+ZJtiTM7plxNxOuU23SmHK3VOpQ67tcqE9k7z74wMXn0MHy6WkWAjAdSbPJ1fVivQn25B4VBMiUuY18+qTcOrG/w3dh6zhZ/MqJr61Dmcij93PopbjxBqgaNZY0q42NuZLsE6S5NRqlbHe8iGP6FfjUDAG1aQq9PIn/1m/Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750344; c=relaxed/simple;
	bh=ha99rJeK+05VJmcJlx/h3bktTiGxgkDpchXO99HmH6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY05y41IdaRMMaIy72q5P35b7iCLRrqi44cZTYwBzKHqZ3IJuAk8dNhnW3uwFeYCan6MhHHp6X6EgJf8lSOURB7SijYK80G6oC4uLOSVRmqGzyG1rdoUxFMcdd1sdWSJMeSme7rYhpBB9QBvQRsEECchOhXD2Aury/emp2r+M30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfzRTzWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfzRTzWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D60CC4CEE9;
	Tue, 20 May 2025 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750344;
	bh=ha99rJeK+05VJmcJlx/h3bktTiGxgkDpchXO99HmH6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfzRTzWw8qjl7vtOeIXGqkYd8CQPXRjMlo6hgoUocwkGaraft2r8vg3GCglf6NBnB
	 uPs0EZfIQsnZPHvdyU61j/LBrbv95Xy1SV93nZXHUfFY1fX4HLbP0ucXMIlMUE0ECU
	 vpwZ0dE1xgf+KXygYq0fTqVgpTs5uEvXZI5SSpOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 122/143] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
Date: Tue, 20 May 2025 15:51:17 +0200
Message-ID: <20250520125814.818245844@linuxfoundation.org>
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
@@ -324,6 +324,7 @@ static int idxd_setup_groups(struct idxd
 		rc = dev_set_name(conf_dev, "group%d.%d", idxd->id, group->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(group);
 			goto err;
 		}
 
@@ -348,7 +349,10 @@ static int idxd_setup_groups(struct idxd
 	while (--i >= 0) {
 		group = idxd->groups[i];
 		put_device(group_confdev(group));
+		kfree(group);
 	}
+	kfree(idxd->groups);
+
 	return rc;
 }
 


