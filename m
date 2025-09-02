Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D778304BA0;
	Tue,  2 Sep 2025 13:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820687; cv=none; b=J76dLm4mEBBUSbb+zInZ2qwLWBU11HjenqMf2aHb2m3VxCbbNokxU6eKg0TMyPs5iNN0rivIuDGn4EwgOCtDga1FO9rey/G/nhoYzpbPXwwfESY/dRLxLNTx3cvoTa6cH9SqENUt85XKYpQtahJiRDSBtP9QSNTqL5cDKaYAI+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820687; c=relaxed/simple;
	bh=rhOawZDNyEwLR/wh0ImnaNMetcaq7idO8vfUO0OVSXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/vEH5eZc9CEGGR9ugRBfxzTaAJvDkr5JQfSHY4Jn/CxNzAxXFAdwMAREqeChmuYHnwijE0g7rHa1eU56PZ7n1ms3QzT9qvBeFfngAxRvCJ17VY/KSSwgDcjFQ4H67C5KRKvROyq/UMRLfpnvse4CipGhRTyDoOsYm8qKFGLQy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MU722h4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MU722h4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A270EC4CEED;
	Tue,  2 Sep 2025 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820687;
	bh=rhOawZDNyEwLR/wh0ImnaNMetcaq7idO8vfUO0OVSXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MU722h4tUwFnxkDFHrgsdlbyalJzQCQkhwTecNLNCEzQamh7DpnzKYWwp9olQJy9F
	 me/oScla1lb7Oj/hVSg6qLe/zSuUSEA/gYRQ9qjBsMFvDRHHyHpWyzPRaSN3xu860C
	 jlVNBKGxCltpyDHLhTr34IqHC7M7ocsgSyyw001w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Ryabinin <arbn@yandex-team.com>,
	Hillf Danton <hdanton@sina.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 07/34] vhost/net: Protect ubufs with rcu read lock in vhost_net_ubuf_put()
Date: Tue,  2 Sep 2025 15:21:33 +0200
Message-ID: <20250902131926.908498638@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit dd54bcf86c91a4455b1f95cbc8e9ac91205f3193 upstream.

When operating on struct vhost_net_ubuf_ref, the following execution
sequence is theoretically possible:
CPU0 is finalizing DMA operation                   CPU1 is doing VHOST_NET_SET_BACKEND
                             // ubufs->refcount == 2
vhost_net_ubuf_put()                               vhost_net_ubuf_put_wait_and_free(oldubufs)
                                                     vhost_net_ubuf_put_and_wait()
                                                       vhost_net_ubuf_put()
                                                         int r = atomic_sub_return(1, &ubufs->refcount);
                                                         // r = 1
int r = atomic_sub_return(1, &ubufs->refcount);
// r = 0
                                                      wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
                                                      // no wait occurs here because condition is already true
                                                    kfree(ubufs);
if (unlikely(!r))
  wake_up(&ubufs->wait);  // use-after-free

This leads to use-after-free on ubufs access. This happens because CPU1
skips waiting for wake_up() when refcount is already zero.

To prevent that use a read-side RCU critical section in vhost_net_ubuf_put(),
as suggested by Hillf Danton. For this lock to take effect, free ubufs with
kfree_rcu().

Cc: stable@vger.kernel.org
Fixes: 0ad8b480d6ee9 ("vhost: fix ref cnt checking deadlock")
Reported-by: Andrey Ryabinin <arbn@yandex-team.com>
Suggested-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Message-Id: <20250805130917.727332-1-kniv@yandex-team.ru>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -95,6 +95,7 @@ struct vhost_net_ubuf_ref {
 	atomic_t refcount;
 	wait_queue_head_t wait;
 	struct vhost_virtqueue *vq;
+	struct rcu_head rcu;
 };
 
 #define VHOST_NET_BATCH 64
@@ -248,9 +249,13 @@ vhost_net_ubuf_alloc(struct vhost_virtqu
 
 static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
 {
-	int r = atomic_sub_return(1, &ubufs->refcount);
+	int r;
+
+	rcu_read_lock();
+	r = atomic_sub_return(1, &ubufs->refcount);
 	if (unlikely(!r))
 		wake_up(&ubufs->wait);
+	rcu_read_unlock();
 	return r;
 }
 
@@ -263,7 +268,7 @@ static void vhost_net_ubuf_put_and_wait(
 static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
 {
 	vhost_net_ubuf_put_and_wait(ubufs);
-	kfree(ubufs);
+	kfree_rcu(ubufs, rcu);
 }
 
 static void vhost_net_clear_ubuf_info(struct vhost_net *n)


