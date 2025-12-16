Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054493559C4;
	Tue, 16 Dec 2025 11:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886253; cv=none; b=AUv1uobVapLSqnSl4WxzYkfNTH8/dRPWnFzt2fw+ExKR9J7QL6Jwph/7nnZA4BpcvAWFQ20eqeiid5SuHfWCqw6r73Slk0P4saXHvQuTPlXpv4bd3AdXIblKRt6K4fWECJMBgx2Cu9MtWiLH2Z/8lB4KEbUKN2oNf6sweHiw/dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886253; c=relaxed/simple;
	bh=NCjoqnwYe6sEWJNrKcA71v+YX3lcWHaC8yFuRy+Vo3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwXa3zKmJmMq9hsS8gTy7IG9WwbLMdQbr7pjvdUeTCmcQFSkjP3u2Uwfkns6rrI21IonxG+uQQYE1K6l6YvYoil1dVrLuPZZzNudySWO4E0l7oibkrySIWl8ZhtQUxzPB5lkKOku50DjQO3bCPfa08km+DJ//Jo1+XqwVNk1jDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwsqYkre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwsqYkre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FA0C4CEF1;
	Tue, 16 Dec 2025 11:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886252;
	bh=NCjoqnwYe6sEWJNrKcA71v+YX3lcWHaC8yFuRy+Vo3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwsqYkrexi02DwJCD4zTLEZ7Eklt2xjKiiJQgz3+dZE858eHEZA2aepe1WFSrwmPw
	 8T573+X4PVrnfT1ul3QBy97Er3IrgDi2xFjUJBScD682V/ztOiqaf96TwLKPMiPNQN
	 ml2Pl7KexSv6Gw0HUQkUP0n7lWdNH6Z0yFJ/a62c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 381/507] vhost: Fix kthread worker cgroup failure handling
Date: Tue, 16 Dec 2025 12:13:42 +0100
Message-ID: <20251216111359.262866102@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a78226b37739d..bccdc9eab267a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -804,11 +804,13 @@ static int vhost_kthread_worker_create(struct vhost_worker *worker,
 
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



