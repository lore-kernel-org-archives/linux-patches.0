Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32F83F482E;
	Thu, 16 Jul 2026 13:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209328; cv=none; b=u39qSSl/X6TczKKYisN5hhvOcbmEkN0iwE2ZRt1or36bfiUWw+0h8UzAa1fV6BoHy3BBUJNzI17VEVnDUFu60t82iMebCnLiaU+bpYNm31z08b56p52VrnQN/LTh9iXFSCSif9S5YJHBKrq73oROF6QWDfqQJIaHNtA0bFw2lcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209328; c=relaxed/simple;
	bh=Afh0/24861kPSjE8vPX5Jmg+RYHa1BKbg/mLx+azszg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7YhiFth2qDMcs4rm/hw5A+doiEMetPo00e0rXVoFNPdfOAY6Oav2Ni6zlfG02/y9K9xYb8QblWOS2zRgCNEjllS5JAzkfV2NGZelnbKg4txabXSG1O80r6kFz+uUlf/aoAq539w/aIqlIkuG4BNZR00dyef/2Jru3exxvJmkBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOrzdQFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOrzdQFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448CB1F000E9;
	Thu, 16 Jul 2026 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209326;
	bh=WWwQgwvyT77qNopijuVdf30vTzljQ2qzaHswKdfwyug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOrzdQFaWt28334yjEhIprN7ITCjLyY0kI5BYs4aYWeXJHdf3RvWSU7WDGqA7Xlwa
	 doZ8YJT08v75a5FnrmlBRJV9e6EOXswTrFwOyHXLPVNuVHy9A0Z7RHRL4j/LY3DD90
	 r8faunt1fTkIxV/gVvqEvtIzvHxYndMSZTbbcVeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichun Zhang <yichun@openresty.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Yuka <yuka@umeyashiki.org>,
	Ammar Faizi <ammarfaizi2@openresty.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 7.1 143/518] virtio_pci: fix vq info pointer lookup via wrong index
Date: Thu, 16 Jul 2026 15:26:51 +0200
Message-ID: <20260716133050.981634948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ammar Faizi <ammarfaizi2@openresty.com>

commit f7d380fb525c13bdd114369a1979c80c346e6abc upstream.

Unbinding a virtio balloon device:

    echo virtio0 > /sys/bus/virtio/drivers/virtio_balloon/unbind

triggers a NULL pointer dereference. The dmesg says:

    BUG: kernel NULL pointer dereference, address: 0000000000000008
    [...]
    RIP: 0010:__list_del_entry_valid_or_report+0x5/0xf0
    Call Trace:
    <TASK>
    vp_del_vqs+0x121/0x230
    remove_common+0x135/0x150
    virtballoon_remove+0xee/0x100
    virtio_dev_remove+0x3b/0x80
    device_release_driver_internal+0x187/0x2c0
    unbind_store+0xb9/0xe0
    kernfs_fop_write_iter.llvm.11660790530567441834+0xf6/0x180
    vfs_write+0x2a9/0x3b0
    ksys_write+0x5c/0xd0
    do_syscall_64+0x54/0x230
    entry_SYSCALL_64_after_hwframe+0x29/0x31
    [...]
    </TASK>

The virtio_balloon device registers 5 queues (inflate, deflate, stats,
free_page, reporting) but only the first two are unconditional. The
stats, free_page and reporting queues are each conditional on their
respective feature bits. When any of these features are absent, the
corresponding vqs_info entry has name == NULL, creating holes in the
array.

The root cause is an indexing mismatch introduced when vq info storage
was changed to be passed as an argument. vp_find_vqs_msix() and
vp_find_vqs_intx() store the info pointer at vp_dev->vqs[i], where 'i'
is the caller's sparse array index. However, the virtqueue itself gets
vq->index assigned from queue_idx, a dense index that skips NULL
entries. When holes exist, 'i' and queue_idx diverge. Later,
vp_del_vqs() looks up info via vp_dev->vqs[vq->index] using the dense
index into the sparsely-populated array, and hits NULL.

Fix this by storing info at vp_dev->vqs[queue_idx] instead of
vp_dev->vqs[i], so the store index matches the lookup index
(vq->index). Apply the fix to both the MSIX and INTX paths.

Cc: Yichun Zhang <yichun@openresty.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: stable@vger.kernel.org # v6.11+
Tested-by: Yuka <yuka@umeyashiki.org>
Fixes: 89a1c435aec2 ("virtio_pci: pass vq info as an argument to vp_setup_vq()")
Signed-off-by: Ammar Faizi <ammarfaizi2@openresty.com>
Message-Id: <20260315141808.547081-1-ammarfaizi2@openresty.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_pci_common.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -423,10 +423,11 @@ static int vp_find_vqs_msix(struct virti
 			vqs[i] = NULL;
 			continue;
 		}
-		vqs[i] = vp_find_one_vq_msix(vdev, queue_idx++, vqi->callback,
+		vqs[i] = vp_find_one_vq_msix(vdev, queue_idx, vqi->callback,
 					     vqi->name, vqi->ctx, false,
 					     &allocated_vectors, vector_policy,
-					     &vp_dev->vqs[i]);
+					     &vp_dev->vqs[queue_idx]);
+		queue_idx++;
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto error_find;
@@ -485,9 +486,10 @@ static int vp_find_vqs_intx(struct virti
 			vqs[i] = NULL;
 			continue;
 		}
-		vqs[i] = vp_setup_vq(vdev, queue_idx++, vqi->callback,
+		vqs[i] = vp_setup_vq(vdev, queue_idx, vqi->callback,
 				     vqi->name, vqi->ctx,
-				     VIRTIO_MSI_NO_VECTOR, &vp_dev->vqs[i]);
+				     VIRTIO_MSI_NO_VECTOR, &vp_dev->vqs[queue_idx]);
+		queue_idx++;
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto out_del_vqs;


