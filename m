Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF6918455C;
	Tue, 30 Jul 2024 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357864; cv=none; b=maYHYMmmVfB+fLfSYAXbEUP5GDnxzKUcxeas3ibKyPGakBLLR6xsO5j3XIPdW9W4G70T/cWtLmC7LBhQqXvHYE/UexUUdfdhDsUKJvyFpTOkAfeSQ0IJovrV4AlzmOsZhqj0ZF5iDjHty7GFhAUEIwzXeoGWzDsI+yavsTqU8cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357864; c=relaxed/simple;
	bh=wu9aie8iNldYeUPWcbJMOY5IGzvxVce+zDZrsfT2GPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVkCYMNCwA9KGXMPX25cg480gaC7/ZgwWfWgjz+7jYybz/kig9sZqoEJnxbPp0xUgDqcCsRb5OhbRZTAHZvHvzP6CcsbbFQWaKAu4udDCUNV/TUo+/KQ0qESh6PzKQ6uj7VAjqR66GB8uCfYHAW6R6FXbn1sYI7wKsVAtjlULKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSww9BqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSww9BqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EA9C4AF0A;
	Tue, 30 Jul 2024 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357864;
	bh=wu9aie8iNldYeUPWcbJMOY5IGzvxVce+zDZrsfT2GPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSww9BqWe0v3d+O7E31y+ztxV+Dwjnp7ja5Ep5LQeho3KLZHod/AcFzL/OVpZukWc
	 HD0v41q6ByvL0wAFKQWDbyEMRqy+cYyoBLDnHWnG5IBVDa5Nms29vggG5XZA7r6wXR
	 ufu0PwpX4JeyflVQXgu+8TlUqYIMFgO2eoSmelLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.1 334/440] ubi: eba: properly rollback inside self_check_eba
Date: Tue, 30 Jul 2024 17:49:27 +0200
Message-ID: <20240730151628.866823506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 745d9f4a31defec731119ee8aad8ba9f2536dd9a upstream.

In case of a memory allocation failure in the volumes loop we can only
process the already allocated scan_eba and fm_eba array elements on the
error path - others are still uninitialized.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 00abf3041590 ("UBI: Add self_check_eba()")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/eba.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1560,6 +1560,7 @@ int self_check_eba(struct ubi_device *ub
 					  GFP_KERNEL);
 		if (!fm_eba[i]) {
 			ret = -ENOMEM;
+			kfree(scan_eba[i]);
 			goto out_free;
 		}
 
@@ -1595,7 +1596,7 @@ int self_check_eba(struct ubi_device *ub
 	}
 
 out_free:
-	for (i = 0; i < num_volumes; i++) {
+	while (--i >= 0) {
 		if (!ubi->volumes[i])
 			continue;
 


