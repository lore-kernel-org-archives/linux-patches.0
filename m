Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210834;
	b=r/A0WwkzKcWZf0xloUlKAKOvnTiDEMcwYodaTrC/s1IXokfdw8hXbYF0J7kqLecxNPjT
	 XEwMh1El8hvf21v220eIynZLX8SnOiTt9DQZgEnw70HuuF/0I3ouV3DFxpuVaOQozne3a
	 Dd9SRrVbCyAJKagwi3ml+03ifMznVDGBMBn763rsL93E3GBJJrrqzpszhiDoQEROuW3s3
	 qpERIvFeN1wirdgU9jnisj0c2qyHVx5PV54aChIRg1aehS8yLQGyDXM3o6DN86MEn+JzY
	 eNPhgbikA7pPXi/5cYdAxFrab6oBXQ+3CMvAq2e6BnG35WIp+CGYihpLTKWs+cGHkJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+xTMcWaYg8M6hGuMgY6gBKlkWNN5GZ9Ac/MEtFlKrk=;
	b=sUTGR9xnDiBUe6jFWkknTDWDrOnO4Dqn4L4WnGz/4eE1YGeVRuLE0O2rArXXbKubw/JX
	 KPPsJQ4nqABmJYlRXfqW2Sn35mtlw89X6iCxCGdLFQ2DizGa5mtBMuOP7mgM2uTlvw709
	 vXCABNQIYb74VHuz3p4uEr6e80CebU+WtJw1DAkr9JtlSdOvok3Hoy0dbXgYyQqDK2WL6
	 ZZj8+yz4+6bxnqWUhCNlhB2x0u2/4k+toYB3j3+ZWyldw9P3LeVW2ATOZgYbiTMjQG3bv
	 yK11stFSo+ClBZ5krVN0SKYIY+ajdvMbknsUzDD7svVlz+zIf2IqlfQe2w1goxPFrxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSZtf7CI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77832606A31A;
	Wed, 28 Oct 2026 18:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSZtf7CI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A861F01828;
	Wed, 28 Oct 2026 18:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210834;
	bh=x+xTMcWaYg8M6hGuMgY6gBKlkWNN5GZ9Ac/MEtFlKrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSZtf7CISB4161Dj+S4Ur6lm3tebAa4GOSTylrNFaTMotNcxqVjkFDVMwgedQRBY4
	 ZUOzPx1/agDJrmQrHTDXM6nyrK+hl3Bsnl9PrOqzjMnO+oerZLFD3/r4D0pHvwlkP/
	 ohcZzQKM/7W3MyeJGTePLHyE4iA4e6OO717mooiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/571] nvmet: preserve device path on allocation failure
Date: Wed, 28 Oct 2026 17:55:11 +0100
Message-ID: <20261028170011.907625583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 2f271b812170d4cad578bae1f91db72f3c2e36e7 ]

nvmet_ns_device_path_store() frees the old path before allocating its
replacement, losing the existing configuration if allocation fails.
Allocate the new path before freeing the old one.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index a3d3a1bfd292d..110d33900a001 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -339,6 +339,7 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	struct nvmet_subsys *subsys = ns->subsys;
 	size_t len;
 	int ret;
+	char *new_path = NULL;
 
 	mutex_lock(&subsys->lock);
 	ret = -EBUSY;
@@ -350,12 +351,14 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	if (!len)
 		goto out_unlock;
 
-	kfree(ns->device_path);
 	ret = -ENOMEM;
-	ns->device_path = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!ns->device_path)
+	new_path = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!new_path)
 		goto out_unlock;
 
+	kfree(ns->device_path);
+	ns->device_path = new_path;
+
 	mutex_unlock(&subsys->lock);
 	return count;
 
-- 
2.53.0



