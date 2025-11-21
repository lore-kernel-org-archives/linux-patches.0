Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A698190477;
	Fri, 21 Nov 2025 13:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731780; cv=none; b=CjY+Gbk9f9dcmCEevR18H/lyvg+RnEKOj9N0cEANNCvGY+FqDzl75mqNWATd/eTqiNz69AIzbiAiJs6kfK3+OSe3V23VhyfFbVdU4bMeN6f7F/VhmPoceV3Ugk8wHXgmo8+c8rhWmlJ6+wxmqIyUaUOkPkOV1G2JtxIfovab+ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731780; c=relaxed/simple;
	bh=mmunOk1O262ZVXdE1M3Bg+R2EK1TPF0sz6WU2+Ism00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5vv6EIbB5S/tSMtB4QBDYMSOPpV17v8koHXTXu8ZGGFuJ63upeh5HsisTOX8k7Qsh3oQ5pWG1FM7+gdE61RnpeS0qHv7PBvqXe4WRPxuGyti4hgpghzYHgm8G9AYOnGC0JpZPQ/VzZKMNE8kihIRf6Atg7ufio3G7BQSIxJklQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpAmJibF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpAmJibF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27BEC4CEF1;
	Fri, 21 Nov 2025 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731780;
	bh=mmunOk1O262ZVXdE1M3Bg+R2EK1TPF0sz6WU2+Ism00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpAmJibFJ+6SyL+2vN71MEr7htHJyn+I1i/aDCjN/2C8+N0PQ9MjsRqgH002rZGNc
	 uhL9yrXWLuRFX5y9sbywEV4igPHfyi3VxWXqOPY9fnI5G0AOU+M0j+sMKzjfKqNJYH
	 1LKwK6cVz+YS97TfauVX9OvJUY39K9/PiBHFAe3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Benjamin Coddington <ben.coddington@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/185] NFS: sysfs: fix leak when nfs_client kobject add fails
Date: Fri, 21 Nov 2025 14:11:44 +0100
Message-ID: <20251121130146.650492567@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 7a7a3456520b309a0bffa1d9d62bd6c9dcab89b3 ]

If adding the second kobject fails, drop both references to avoid sysfs
residue and memory leak.

Fixes: e96f9268eea6 ("NFS: Make all of /sys/fs/nfs network-namespace unique")

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Benjamin Coddington <ben.coddington@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/sysfs.c b/fs/nfs/sysfs.c
index 784f7c1d003bf..53d4cdf28ee00 100644
--- a/fs/nfs/sysfs.c
+++ b/fs/nfs/sysfs.c
@@ -189,6 +189,7 @@ static struct nfs_netns_client *nfs_netns_client_alloc(struct kobject *parent,
 			return p;
 
 		kobject_put(&p->kobject);
+		kobject_put(&p->nfs_net_kobj);
 	}
 	return NULL;
 }
-- 
2.51.0



