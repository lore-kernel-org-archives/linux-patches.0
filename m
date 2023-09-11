Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E634432
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B88C433C9;
	Mon, 11 Sep 2023 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441419;
	bh=S0iqzVFt9mWY8/4Hx8NMfT5iDw9NGELxRCxcBolGnQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuImTUfEutZuHoN7a1kB+FPQKPoO5b2CVbUVfRukCX200q1t0jFh5S3em8eigMlmI
	 bElri1L7/vXVBJzyy41Mp0yV01pUuVbd2q3lH9lD/cb6Ro/Ko5HBTohrot66ol/hAB
	 WZ/tyxzfzpYqil51L+M8cIXFksAdXMQIm0OlE7Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 399/739] kvm/vfio: ensure kvg instance stays around in kvm_vfio_group_add()
Date: Mon, 11 Sep 2023 15:43:18 +0200
Message-ID: <20230911134702.327419651@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 9e0f4f2918c2ff145d3dedee862d9919a6ed5812 ]

kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
dropping kv->lock. If we race group addition and deletion calls, kvg
instance may get freed by the time we get around to calling
kvm_vfio_file_set_kvm().

Previous iterations of the code did not reference kvg->file outside of
the critical section, but used a temporary variable. Still, they had
similar problem of the file reference being owned by kvg structure and
potential for kvm_vfio_group_del() dropping it before
kvm_vfio_group_add() had a chance to complete.

Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
of kv->lock. We already call it while holding the same lock when vfio
group is being deleted, so it should be safe here as well.

Fixes: 2fc1bec15883 ("kvm: set/clear kvm to/from vfio_group when group add/delete")
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20230714224538.404793-1-dmitry.torokhov@gmail.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index af3d0cf06e4c6..365d30779768a 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -180,10 +180,10 @@ static int kvm_vfio_file_add(struct kvm_device *dev, unsigned int fd)
 	list_add_tail(&kvf->node, &kv->file_list);
 
 	kvm_arch_start_assignment(dev->kvm);
+	kvm_vfio_file_set_kvm(kvf->file, dev->kvm);
 
 	mutex_unlock(&kv->lock);
 
-	kvm_vfio_file_set_kvm(kvf->file, dev->kvm);
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
-- 
2.40.1



