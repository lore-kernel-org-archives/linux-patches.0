Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588E839EF16;
	Tue, 21 Jul 2026 15:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649068; cv=none; b=TPqSJ8vY4rXQWYDdKQrAmuT4BT/WyUJB2/jthLYuWBcZ1uqwaxEnczoaVjeUogkkPXRsUSfMe1oIUtw5AmhFdpxotlBXprEOE5Y7uflEEKHCg08vbPRVBw9E0yWEw2oiSdnJ/iiSfeGBDpPVojTTfrO/POJse11zh84zj6sjznA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649068; c=relaxed/simple;
	bh=6xlDj8nHOZvg2vxi4VMJSyUb8AbDCFXenJpNdT4+aCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZOwqHcPoxn5lqsUJsAdxq7Dl7M3zm1AmMBOEeCSFPVLBYXy5U9SDOkIbTYdBHa8ksgL3ZedHivO+2u9MaalDjXnFSahK8eJm0OsUtPWFswpXvAJ2hdp+ymjbujcTafDLizl0AhddRl34254lLV58uNq2CgeWaEXCa+s63dP85g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ijPG7I7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ijPG7I7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044D91F000E9;
	Tue, 21 Jul 2026 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649065;
	bh=oC/GYBtTTTL0Fb3Rbag0wQrYRDr6kOJd9DGK0iIX5hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ijPG7I7pm3AYq2tynU2EDe7IlQSs4WipPgrzbqeaPHeb8OsdG99TvqB2OW2H+BRL
	 +1+nGFoHI0b+EH/E1zRdv3cL0hPXzXB4e6RZJixcDcbSH1pAIz2/H6HsXxEk5mXp+c
	 k9qLi+TAm/YeUBcpHsr8X2Lk+v/1Zxbqo4WKPuEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0410/2077] liveupdate: fix u-a-f in luo_file_unpreserve_files() and luo_file_finish()
Date: Tue, 21 Jul 2026 17:01:23 +0200
Message-ID: <20260721152602.403709952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Pasha Tatashin <pasha.tatashin@soleen.com>

[ Upstream commit 291dcd37c8c8f8f8e1bccc92228f44bf371762a8 ]

In luo_file_unpreserve_files() and luo_file_finish(), reorder
module_put() and xa_erase() to ensure the file handler module remains
pinned while its operations are being accessed.

Specifically, luo_get_id() dereferences fh->ops->get_id, so the module
reference must be held until after xa_erase() (which calls luo_get_id)
completes.

For luo_file_finish(), this requires moving the module_put() call out of
the luo_file_finish_one() helper and into the main loop of
luo_file_finish() itself.

Fixes: 00d0b372374f ("liveupdate: prevent double management of files")
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://patch.msgid.link/20260527202737.1345192-5-pasha.tatashin@soleen.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/liveupdate/luo_file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a0a419085e2830..208987502f73a9 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -385,10 +385,11 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
-		module_put(luo_file->fh->ops->owner);
 
 		xa_erase(&luo_preserved_files,
 			 luo_get_id(luo_file->fh, luo_file->file));
+		module_put(luo_file->fh->ops->owner);
+
 		list_del(&luo_file->list);
 		file_set->count--;
 
@@ -677,7 +678,6 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 
 	luo_file->fh->ops->finish(&args);
 	luo_flb_file_finish(luo_file->fh);
-	module_put(luo_file->fh->ops->owner);
 }
 
 /**
@@ -738,6 +738,7 @@ int luo_file_finish(struct luo_file_set *file_set)
 				 luo_get_id(luo_file->fh, luo_file->file));
 			fput(luo_file->file);
 		}
+		module_put(luo_file->fh->ops->owner);
 		list_del(&luo_file->list);
 		file_set->count--;
 		mutex_destroy(&luo_file->mutex);
-- 
2.53.0



