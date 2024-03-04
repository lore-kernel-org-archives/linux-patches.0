Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDE2DDCB;
	Mon,  4 Mar 2024 21:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588190; cv=none; b=RrS8hMNcKnkTbfZf7U9cuubnJE3XdkBSmvtGRcOJrs8nLOEi2NfTCi9oaIwEu33UYFM5WM7gjx3KYzT7T7YNZkfeQIGExD5xPFgHivcvpuvgW3mFz5GRO/f4wpWRHwzQ4LcaTWQdvNYoZBLQaVR4JOYkiQMqR2SY9PIf0QvnXp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588190; c=relaxed/simple;
	bh=id8/kLCkDxfH+W8XWaiqc/GJvWJb5bn3O84BPZS8AJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNtHb/47frXSXp9QYO/dx6Im6qjNuythhK6ewu1IMosdfu30lkSzrR+T844Pi4WlYPu4Z4hLzgaH9wI864nu3uy62cdepv0C+E6B/1aFeFU+zJtQ8z1iX3+Qd2QdvCEf8mv6aG9BVYZmpE4I+9xHytt1eXcY+KzhGmmPei4+dh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObXkq7Cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObXkq7Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5836FC433F1;
	Mon,  4 Mar 2024 21:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588190;
	bh=id8/kLCkDxfH+W8XWaiqc/GJvWJb5bn3O84BPZS8AJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObXkq7CdSFi0bemgRLpZYhpPnnp0vjsQxKolu/IhfpWg9VfmeQ5rZ4cQ68jOerCKO
	 sS1GPk+qeuihS9rMz3gvw16P+XUgE28hR1U82080yW8LPggxpvRCKl8olvfPuh56jm
	 iO3Qvre00LRNis6qj8NppMP+S5oLU56GFxvGZ2Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/143] tun: Fix xdp_rxq_infos queue_index when detaching
Date: Mon,  4 Mar 2024 21:22:13 +0000
Message-ID: <20240304211550.359230920@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 2a770cdc4382b457ca3d43d03f0f0064f905a0d0 ]

When a queue(tfile) is detached, we only update tfile's queue_index,
but do not update xdp_rxq_info's queue_index. This patch fixes it.

Fixes: 8bf5c4ee1889 ("tun: setup xdp_rxq_info")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Link: https://lore.kernel.org/r/1708398727-46308-1-git-send-email-wangyunjian@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4a4f8c8e79fa1..8f95a562b8d0c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -653,6 +653,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		ntfile->xdp_rxq.queue_index = index;
 		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
 				   NULL);
 
-- 
2.43.0



