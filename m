Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05602FE595;
	Tue, 12 Aug 2025 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025037; cv=none; b=TWHeWNXX/afbiYsx8ggB/j+xV7pUvLPqN7xW4LYZPtnfkIOxIdGqsrDQYXCQ/YsG8rcMQYvilTnfz8YeqewUHYeUXdUpJDRCQtCK5dRSqRr0csRLfd2N6Dc0BbYRxL+hB7VmqOLZBtJmFq/82/8YX5cSt4Wm0QuKFbO5UjKuABs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025037; c=relaxed/simple;
	bh=jTfOhNiyUaWnKdH5jlbl1bUOi7qQnI4qo5FOWEqery0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrhNOOTE1U/LUnWpmpnmOIsgiukITsoRu0vcWR5TFvytGutCb5B0tVnPM0XO6sXbDvrLghJg0i5adDMlqR4S2I452AxWzFxDlt4nfK41NC74JA24OOplkETPdVvkSqwT+O3VG1+6CFBAFu/ZX/XQ8dABCofdceGBLBwui0BmpKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAs8jUoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAs8jUoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC346C4CEF0;
	Tue, 12 Aug 2025 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025037;
	bh=jTfOhNiyUaWnKdH5jlbl1bUOi7qQnI4qo5FOWEqery0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAs8jUoE91cftrXUZvPqlVhiO52FJqieaan7hEblS7Vtr07vWB23MVtZaXSwppxdv
	 vRwsqNZknMdp5jRZ1hw8cPMv5L8Oi8E6g/RdYLsGCBN6GneJN+XmAXNHAxoBt8JGR8
	 Jt3JsRn2sefqwCPhrvICVOpXY7Fs2K0HDj0+8RcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neil@brown.name>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 551/627] NFS/localio: nfs_close_local_fh() fix check for file closed
Date: Tue, 12 Aug 2025 19:34:06 +0200
Message-ID: <20250812173452.865851644@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e144d53cf21fb9d02626c669533788c6bdc61ce3 ]

If the struct nfs_file_localio is closed, its list entry will be empty,
but the nfs_uuid->files list might still contain other entries.

Acked-by: Mike Snitzer <snitzer@kernel.org>
Tested-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Fixes: 21fb44034695 ("nfs_localio: protect race between nfs_uuid_put() and nfs_close_local_fh()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/nfslocalio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index 05c7c16e37ab..64949c46c174 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -314,7 +314,7 @@ void nfs_close_local_fh(struct nfs_file_localio *nfl)
 		rcu_read_unlock();
 		return;
 	}
-	if (list_empty(&nfs_uuid->files)) {
+	if (list_empty(&nfl->list)) {
 		/* nfs_uuid_put() has started closing files, wait for it
 		 * to finished
 		 */
-- 
2.39.5



