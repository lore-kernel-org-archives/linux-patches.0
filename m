Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB44346AFB;
	Fri,  7 Aug 2026 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115092; cv=none; b=C4lhl5W+iqqU8DrSrBk2fH949IhDfafLgYgiFgTfMcUAFQ8jYfN1u+EPJQx1kGoU8piIloALo6z6kuACvothrknhx/Zo0rpZMfUSeDCHShaK817cKwbigZV1Czeyg0tAirlUscFGj8scRNB16Lb9I3UsqJmLV1n+cSKSmHsdenk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115092; c=relaxed/simple;
	bh=U56c/D7nSby3HlvF+8fyxbQ0Qg3fqtd5E/oP6W2DeO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8RYeXg4IUhvpez38DwIwRVg8m0MAXInFFvoty1ZMw4ceUegbGOh92QAwTAjG21lCR04n1Kf+7KUzndxOHHhsROzDyGfC2nHFH90R41NWUt6ETfpmoIHLwLWtxV3QSsxQ0XSmss0ds4FWzwEUPsA3S7YuCOE8p41Mgn79Pv/ES8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBO16cAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBO16cAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE4D1F00A3A;
	Fri,  7 Aug 2026 15:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115087;
	bh=ay5YCSPmzwn3Ae28h1tU1UgkwBuA7CM4wbf4HnisPcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBO16cAH8k65q2hNf6/ax0tm+P5vs20aOWP2/+j9XshI+qCLgox+UgL4T7pDTshWi
	 S2vF3CcNSzOFO4f2BazgbXgKFZuEIKuQUVAj09aNAxDmaZ5/G0VvBSbmdEffC//IBI
	 M+RXnJBdqIpDyTidWPehYWkap0UUiKgl40ogguzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yunseong.kim@est.tech>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/396] ksmbd: fix use-after-free in __close_file_table_ids()
Date: Fri,  7 Aug 2026 16:35:14 +0200
Message-ID: <20260807143427.633707964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e7188199eff46a636f3436356f0aae039be6dd66 ]

A ksmbd_file can remain alive after logical close while another session
holds a temporary reference obtained through ksmbd_lookup_fd_inode().
ksmbd_close_fd() currently marks the file closed and drops the idr-owned
reference, but leaves the pointer published in the closing session's idr
until the final reference is dropped.

If the foreign holder performs the final ksmbd_fd_put(), __put_fd_final()
supplies the foreign session's file table to __ksmbd_close_fd(). The object
is then freed without being removed from its owner's idr, and the owner
session later dereferences the stale pointer during file-table teardown.

Remove the volatile id from the owner's idr while ksmbd_close_fd() still
holds that table's lock, and clear volatile_id before dropping
the idr-owned reference. A later foreign final put then only performs
physical destruction and cannot remove the object from the wrong table.

Fixes: 8510a043d334 ("ksmbd: increment reference count of parent fp")
Reported-by: Yunseong Kim <yunseong.kim@est.tech>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 0d3341927b483..51e37e89d1aa5 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -502,6 +502,8 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 			fp = NULL;
 		else {
 			fp->f_state = FP_CLOSED;
+			idr_remove(ft->idr, id);
+			fp->volatile_id = KSMBD_NO_FID;
 			closed = true;
 			if (!atomic_dec_and_test(&fp->refcount))
 				fp = NULL;
-- 
2.53.0



