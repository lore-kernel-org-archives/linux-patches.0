Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214850;
	b=iTefQGqzKs1EtVRPp2pT/N7yDITo12FjJOLYEB/bU7naEeOslGAYa97O0LVI7lHh262x
	 v0YRIf7MU+BQ7VulMz+weXZj9ozQNl5zujqICMQ8XaE1jHRTMycgLk27jZJ6TLIjtD6oi
	 xGZGdVKIOeGcq/auZMrLkHRB7c9qYNKNYggzFF0SmgBsgsqHgZcHHJzco+n8Tk9n64sDn
	 xhBalxjVY5mnsrTjoavtjVBqUFd1Lcvi14rCDtmGTOHLN2FY85y7DPtLZVFvvrJULhs2W
	 kXL5w+U9hAMl9h5c75Y8Jz5wugKlVr5tUhtRhRw9jkydImW0+zBP7uVw/wJQpQ9KULQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YxIpSFwTPaOaLV+x6HneGNMJkhQ1P4S4QbW0JVJVoe4=;
	b=sozYNHv1+phfmT3Tkehrl+aqoCPV8emRlv9+xFONuTy/V3QajjJGGT3p3GvurzpdS5IJ
	 xHkoAXUGEfCp5rMNJkbET0nXAdVCAG083brX0ZcWL8Xh231tep9fvk+V9h0821fWGjTso
	 j2ZxdZlLC2oC9yDR/DZfZ17Bo58NRjX+yzzG1+uKwNlSveuAvv3jd8eLcBTlwIJ4mf7VA
	 c3zhC3xBV9e5uduPFcuwOOUegy/RVBcPGc8ecO35qecEXfDGp9Xpd6FjzJKALBMyPCa08
	 ikAN9TYuR0lDirwWL5b2KmsWjtnJpf5U0HpBbTAqW7GDFIiduu67y0OxlM4DG0cwflQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EA9Z8na9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C22606A324;
	Wed, 28 Oct 2026 19:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EA9Z8na9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4685D1F01825;
	Wed, 28 Oct 2026 19:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214849;
	bh=YxIpSFwTPaOaLV+x6HneGNMJkhQ1P4S4QbW0JVJVoe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EA9Z8na9yWwRGLSdxA+/G9mBVlrRnXIJCDrEfgV7G5m7nyid4aepU2APM0q1bTM6Y
	 3j2Uquj6rC1K2vI5/12tUumXIlccKfaiYEfv6gfcNWeaDMl23yDazVDuK5Fo11PPK/
	 y9MIHA8REvWwJI/TjNkvsGecO5F6YvALLJ+8F+B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1005/1887] md-cluster: fix NULL pointer dereference in process_metadata_update
Date: Wed, 28 Oct 2026 17:51:41 +0100
Message-ID: <20261028170522.283033260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit f150e753cb8dd756085f46e86f2c35ce472e0a3c ]

The function process_metadata_update() blindly dereferences the 'thread'
pointer (acquired via rcu_dereference_protected) within the wait_event()
macro.

While the code comment states "daemon thread must exist", there is a valid
race condition window during the MD array startup sequence (md_run):

1. bitmap_load() is called, which invokes md_cluster_ops->join().
2. join() starts the "cluster_recv" thread (recv_daemon).
3. At this point, recv_daemon is active and processing messages.
4. However, mddev->thread (the main MD thread) is not initialized until
   later in md_run().

If a METADATA_UPDATED message is received from a remote node during this
specific window, process_metadata_update() will be called while
mddev->thread is still NULL, leading to a kernel panic.

To fix this, we must validate the 'thread' pointer. If it is NULL, we
release the held lock (no_new_dev_lockres) and return early, safely
ignoring the update request as the array is not yet fully ready to
process it.

Link: https://lore.kernel.org/linux-raid/20260117145903.28921-1-jiashengjiangcool@gmail.com
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-cluster.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 7484bb83171a9..c3394112e91cf 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -526,11 +526,20 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
 {
 	int got_lock = 0;
+	struct md_thread *thread;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	mddev->good_device_nr = le32_to_cpu(msg->raid_slot);
 
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
-	wait_event(mddev->thread->wqueue,
+
+	thread = mddev->thread;
+	if (!thread) {
+		pr_warn("md-cluster: Received metadata update but MD thread is not ready\n");
+		dlm_unlock_sync(cinfo->no_new_dev_lockres);
+		return;
+	}
+
+	wait_event(thread->wqueue,
 		   (got_lock = mddev_trylock(mddev)) ||
 		    test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));
 	md_reload_sb(mddev, mddev->good_device_nr);
-- 
2.53.0



