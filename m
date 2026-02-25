Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E3224A06D;
	Wed, 25 Feb 2026 01:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982854; cv=none; b=M8ul+J4/St/AdL8yrq6b4LY5S9vEjMId27qGRe76VTupjDaXaxq1AVtXX673BVBT42azw0w2FDy4oUJYG+ywDX6gWx0TksLcNwy1xkpAHKhJ+tIU9Z7NBnf563PVTpfcaEVO25b/Nq6B5NsfFDTwr8LcTGPwU9FBwvGDp2haTmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982854; c=relaxed/simple;
	bh=HOJ1ke+mbnTsfjSUH80Ots1o/KEm7ZPRqzo3WctfT9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq5qp2fb+dVIkXPcshBOxUwXwt7kffswUfeH0vBSkcVj5jHrzD1+FkUVVho++jePyNoH1G2BF/zwt5yO09G11u9Cses2TBTmoj+/yXT1VH7hcMZEXKHFr56S8EDmtSpDpdU1YDhT7PchAvw8mbaXpUGTigZ2K5YBtSpXU3MWMgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pz7s95fD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pz7s95fD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01C8C19423;
	Wed, 25 Feb 2026 01:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982854;
	bh=HOJ1ke+mbnTsfjSUH80Ots1o/KEm7ZPRqzo3WctfT9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pz7s95fD9gSQJvdCwurxQDYQhSnbbOGB/MGGDmQVPGCpEooxqC9W3Ju7qO0pwlR1z
	 vnTA/d+X1mqxmsZPAFMTxXLa8HgiQPjNx0wK1ExBpkCIYa3jNffNLpMM6pqL8PTz3S
	 +DGmrKb15ykiixromsPj9VkExYBSnjWrBg4Buk70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 043/781] io_uring/sync: validate passed in offset
Date: Tue, 24 Feb 2026 17:12:32 -0800
Message-ID: <20260225012400.760850872@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 649dd18f559891bdafc5532d737c7dfb56060a6d ]

Check if the passed in offset is negative once cast to sync->off. This
ensures that -EINVAL is returned for that case, like it would be for
sync_file_range(2).

Fixes: c992fe2925d7 ("io_uring: add fsync support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/sync.c b/io_uring/sync.c
index cea2d381ffd2a..ab7fa1cd7dd63 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -62,6 +62,8 @@ int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	sync->off = READ_ONCE(sqe->off);
+	if (sync->off < 0)
+		return -EINVAL;
 	sync->len = READ_ONCE(sqe->len);
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
-- 
2.51.0



