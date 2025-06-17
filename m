Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F36B2DFF3D;
	Tue, 17 Jun 2025 15:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175487; cv=none; b=NNFEGcUyy98eSjO7bcOK3JXjX7QKNvU1D8Mng4kDk5Nx7azR9yq9DNoRhyFwhmzFC4d0MBupcp9loBmAmrwh5sb7D2vZme6xEPir8+kLO0tgAEOp1rFb9oW1TVCrphhgSVGVhUx0STCK4njl83ugXQexVPF57fzrHbaO29gKSio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175487; c=relaxed/simple;
	bh=iFIGHR9QiYicykvaWT2bwSs/FpySXtwkD04FKQHZUPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYHmwwQPZd6891qNR07zIhVIBa2zX5y3ff39sBJRix0D3fu0bGAgzKtpynyKI1EPlXpwWWyJAIdhUI/F3AQugWIjBd0U/UU4SXtzrlhfAho+ugRvG0QdNzZZNrpqqI9hGEt3/CKnxyN9PSLS+3IbgUuheLJgtcS5AV3pL38hRRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1MGSIg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1MGSIg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB7FC4CEE3;
	Tue, 17 Jun 2025 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175486;
	bh=iFIGHR9QiYicykvaWT2bwSs/FpySXtwkD04FKQHZUPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1MGSIg/6SdJZtcnBeWwb5ao6fAn65hLdDPeDMSRiw+2arhcxQEF8pmbfK/4CkgsU
	 hfLyi2rsz9KielEkBt3k2DUCGFg3A+2iYf0qjGVFuLvbRwREJCOxJcVUaAYhDE3/nG
	 /+2T1Xzxyo9C5w8CsZr3C7GBPDgH+BZZVEt3km9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Jan Kara <jack@suse.cz>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/356] ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery
Date: Tue, 17 Jun 2025 17:24:56 +0200
Message-ID: <20250617152345.505199642@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit cdc3ed3035d0fe934aa1d9b78ce256752fd3bb7d ]

If ocfs2_finish_quota_recovery() exits due to an error before passing all
rc_list elements to ocfs2_recover_local_quota_file() then it can lead to a
memory leak as rc_list may still contain elements that have to be freed.

Release all memory allocated by ocfs2_add_recovery_chunk() using
ocfs2_free_quota_recovery() instead of kfree().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Link: https://lkml.kernel.org/r/20250402065628.706359-2-m.masimov@mt-integration.ru
Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 0ca8975a1df47..c7bda48b5fb21 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -671,7 +671,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			break;
 	}
 out:
-	kfree(rec);
+	ocfs2_free_quota_recovery(rec);
 	return status;
 }
 
-- 
2.39.5



