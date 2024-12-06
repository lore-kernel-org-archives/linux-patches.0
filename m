Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A9514D717;
	Fri,  6 Dec 2024 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495987; cv=none; b=WQYkaC481uK0OttUGENa4+jHncEYkPMtbxss+mAD4U5akcMzaAiiseutqdW4p9Sn/ODvkKZ+AWmo/uSg5RvQCUtGICrno9HoYHCic7qJiZIi75JOqoust+rCPkT3i+z82hr2Kot8fD01jbX3gOd85G8+uJqlLVL+YPcBcbt/c/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495987; c=relaxed/simple;
	bh=IInn1rvLFlcE51qN7IG92FUtpa3EsWNdKPoJUX7Cxms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5g2d2/z2zjF8v60NBQZAH9WaRurGaevbihEnqVOEvML04W575xli7SVyimp+88vF3tpEateXJctf5SqPSwHCegfBHA5B8m6QRVbfRvW/vVT781YOmCeTuhcUyjELye3qlwPLpc/hQnlR92mk8bP6TGuzYHijxf+cgKhPBoRqGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsr2iNh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsr2iNh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622F6C4CEDE;
	Fri,  6 Dec 2024 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495986;
	bh=IInn1rvLFlcE51qN7IG92FUtpa3EsWNdKPoJUX7Cxms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsr2iNh6uTABZBOMeWNmi2zqGu4Z5N1o093mgBOPpVRsV9+tNkwwBLW1hf6elt1BD
	 yuVpx7hzGsPpjRmlXLLQmUv7mESj4rM5QnhwlPik77DcZQmYA959xBrdEpoyXkObK1
	 t/i33aEe6xYoHNGsUezYUj/in9bN7jKtGe6JXLxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.12 012/146] md/raid5: Wait sync io to finish before changing group cnt
Date: Fri,  6 Dec 2024 15:35:43 +0100
Message-ID: <20241206143528.143022583@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Ni <xni@redhat.com>

commit fa1944bbe6220eb929e2c02e5e8706b908565711 upstream.

One customer reports a bug: raid5 is hung when changing thread cnt
while resync is running. The stripes are all in conf->handle_list
and new threads can't handle them.

Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
pers->quiesce from mddev_suspend/resume. Before this patch, mddev_suspend
needs to wait for all ios including sync io to finish. Now it's used
to only wait normal io.

Fix this by calling raid5_quiesce from raid5_store_group_thread_cnt
directly to wait all sync requests to finish before changing the group
cnt.

Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
Cc: stable@vger.kernel.org
Signed-off-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20241106095124.74577-1-xni@redhat.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7177,6 +7177,8 @@ raid5_store_group_thread_cnt(struct mdde
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
+	raid5_quiesce(mddev, true);
+
 	conf = mddev->private;
 	if (!conf)
 		err = -ENODEV;
@@ -7198,6 +7200,8 @@ raid5_store_group_thread_cnt(struct mdde
 			kfree(old_groups);
 		}
 	}
+
+	raid5_quiesce(mddev, false);
 	mddev_unlock_and_resume(mddev);
 
 	return err ?: len;


