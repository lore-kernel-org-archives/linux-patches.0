Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D5E2BE7B2;
	Tue, 16 Dec 2025 11:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884631; cv=none; b=Uj8Qy+bxafXjF/ba2zq0wj8dn9FkrtNYcsG+54IE1UJYkxzmJ8iQRSTeHrINLnTG7dPbXbA8F+Q8k9isdf4CSZfcBOgvO9vlfpCsf+xB+E9j8GW/dLA2fmA+D0NlkDD9oWGn/k2az1Vm/vxrV4/EsF/bz549JldGAM6XlQUGEaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884631; c=relaxed/simple;
	bh=wAQeFYIia22l5aaaH6mfNnE4ZZPsDN56IEYbR2Hu4fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtLYJOXnXYjZjDbposXhPuYEHRZLh6xHNFhGhERq9jbThtmnOjt4uPADLd5sNDcYhiyQjS7LovqJ9a4NtCKWff44Kv8LHca7G2mM619Xh+bdRGNeQsahZiQGu4axR2EOJkJc+T3QPwHu4LqpORZrqrrebHYJ4H7oIxKphqidzKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATR5LgE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATR5LgE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A7EC4CEF1;
	Tue, 16 Dec 2025 11:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884631;
	bh=wAQeFYIia22l5aaaH6mfNnE4ZZPsDN56IEYbR2Hu4fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATR5LgE6EfZdNpCtcP1TtVUA2HjxeDbdfRGGbe1Z1ZIrenDRTyzFHsP8XmBgLKlOz
	 On/QahDfduRmph0aH1Yaqe4A2SXcuJJA2yVZdIqj/yL8mRAJLRzA7+Y7rE1QNR6ieH
	 R/9ESG1o+t8uAN0lYZxEB6q1RRaqLH5+sfiE3ZN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/354] vhost: Fix kthread worker cgroup failure handling
Date: Tue, 16 Dec 2025 12:13:40 +0100
Message-ID: <20251216111330.082780818@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit f3f64c2eaffbc3169bbe1e5d1e897e6dacc839d1 ]

If we fail to attach to a cgroup we are leaking the id. This adds
a new goto to free the id.

Fixes: 7d9896e9f6d0 ("vhost: Reintroduce kthread API and add mode selection")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251101194358.13605-1-michael.christie@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 71604668e53f6..276dded52212c 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -798,11 +798,13 @@ static int vhost_kthread_worker_create(struct vhost_worker *worker,
 
 	ret = vhost_attach_task_to_cgroups(worker);
 	if (ret)
-		goto stop_worker;
+		goto free_id;
 
 	worker->id = id;
 	return 0;
 
+free_id:
+	xa_erase(&dev->worker_xa, id);
 stop_worker:
 	vhost_kthread_do_stop(worker);
 	return ret;
-- 
2.51.0



