Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208542;
	b=NMqMUyq5rFqU6wZK3HrDAqc3ei6xPxR1reE7b0w8ojnx663wA2fTa5XDJKDJQkiw87ED
	 u5umm/mWpDjcXzPxbnpFAuSEVD2I9RJ+9KMtRyWpCLjQto0HjITf37uJgmOA3I0mKuG3O
	 G08CGqvSebNzwAgB8FAHejC0Chrh3SSaTidEt0dQdNTQSTDF1Pb6G40Evse2fwZ7yaTvd
	 wRMA8sce4Wyrtz0uAuXU2V3q+J71fNI3/2PThOmuexykXZehi4ZMXwEhT0V8AvSifV8Yb
	 sbstS7Fse65FJABWO8L7x2QgyhqqJZr7AVSzY2qT836sdKR0BpHj/Xjz1o0Q1OX9u4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9j43cn7eI0iAiM0xVtDVX6rO9WHoD/p+IWPeucXyFZ8=;
	b=Y45MGyFH6rHbZOZ9vBeS6A8FuRNJOHqMECVhTFcbt6oMnFaohrle3V3I5QEKbFEP6Cg0
	 XKbJrgHeT+dulhwIEyzrkaYaGyOZ86vqTFxP/3DEBS+EuGQz2bC208LlqBfj5KRfts8WA
	 hu6b7rbi5Td365dERsVEEhUWlSPffBjN/4J6sN4KMzH2YWcu3VNd3R2OAdNgBD2Ay1TuP
	 3U8dSa7b3OJBYvYWUFKCJUEoHA2h57Jk4MuHLWLQGkM/aO7NF5x0UnESt5Qksb23POlde
	 yDYT/OrovwizPZw5oW2KZwp0OK8rv9ASa+HmTePfsl3Ab4wqY4G20yZ/FUfp6wHH65g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I5DjX49R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90889606A31C;
	Wed, 28 Oct 2026 17:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I5DjX49R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C65D1F01828;
	Wed, 28 Oct 2026 17:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208542;
	bh=9j43cn7eI0iAiM0xVtDVX6rO9WHoD/p+IWPeucXyFZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5DjX49RB8M3cvAApJN5PQUjbCvOEW+JFFvxlEIDRgTqfJofRyWGNKEqzZQZz8mPj
	 JbmHvMoGDnYzcJe/YrTMyKpn0XkeBp7tJM4NWqgMrbZyPOpMfbL7rhOR21sGJcT+a3
	 89XaSur26332tSiBrVNOeVi5SOVXc5SIN0pzBI80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/516] nvmet: preserve device path on allocation failure
Date: Wed, 28 Oct 2026 17:55:09 +0100
Message-ID: <20261028170007.225612273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f2d11fc047524..55057d34a4e99 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -341,6 +341,7 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	struct nvmet_subsys *subsys = ns->subsys;
 	size_t len;
 	int ret;
+	char *new_path = NULL;
 
 	mutex_lock(&subsys->lock);
 	ret = -EBUSY;
@@ -352,12 +353,14 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
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



