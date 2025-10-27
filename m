Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1F32D8DB7;
	Mon, 27 Oct 2025 19:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593452; cv=none; b=MWkDIhS4ttShK/6umZIENVrURFeHTdIJP8UNorHg9PBb17Mlsh+SwDv4riyi3WafvDrdMNLeXmpD5FHohkLcRao1BN7lK56k/DzjNntdI0WEdhLdzeMsoxq9RHoYMlhDucBNYn74V7ygtWSlAFO6768CjrO5/PPDWJ1/F00Qgl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593452; c=relaxed/simple;
	bh=SI2i5xN0enzzJKVN2a2GD/5z6IE6pCXsMfyiSjsk4BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVi7mLyHRSW4Bf+Dr/Md74TbQBgahrlS+dRtuoZnlGFKmm/qLBBoToPacaDrMVfBgsnzM6brg9AccXLjT6wYZVrZdbPHjdyzXu/SuBx9KWqg2vRiAJyPXL25M8F/KO5dsr3ZmwXgZCwx2hLBI3tYeIoyfiHFKwmdDGlyJrAYO9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTSNj8Vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTSNj8Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E732CC4CEF1;
	Mon, 27 Oct 2025 19:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593452;
	bh=SI2i5xN0enzzJKVN2a2GD/5z6IE6pCXsMfyiSjsk4BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTSNj8VvdGdtvBBQAC9zljYHpDn8fMI7amNprjm+/8M8yMiwaYwQolxuYydE8GXCu
	 FPPSp2g53MC3GTTrdVIaCAFUCsMpaO1Xn1FhyUlOtm6GQMYOPPmL9Gn4LEJChdzXwB
	 Lry4t7vacgYqwgwKcINLngTFFIGuUJbc7ULmLm7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 138/184] io_uring: fix incorrect unlikely() usage in io_waitid_prep()
Date: Mon, 27 Oct 2025 19:37:00 +0100
Message-ID: <20251027183518.663695835@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 4ec703ec0c384a2199808c4eb2e9037236285a8d ]

The negation operator is incorrectly placed outside the unlikely()
macro:

    if (!unlikely(iwa))

This inverts the compiler branch prediction hint, marking the NULL case
as likely instead of unlikely. The intent is to indicate that allocation
failures are rare, consistent with common kernel patterns.

 Moving the negation inside unlikely():

    if (unlikely(!iwa))

Fixes: 2b4fc4cd43f2 ("io_uring/waitid: setup async data in the prep handler")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/waitid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 3101ad8ec0cf6..c8ca00e681f77 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -252,7 +252,7 @@ int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	iwa = io_uring_alloc_async_data(NULL, req);
-	if (!unlikely(iwa))
+	if (unlikely(!iwa))
 		return -ENOMEM;
 	iwa->req = req;
 
-- 
2.51.0



