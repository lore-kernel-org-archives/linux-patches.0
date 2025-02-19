Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108BD1DE2A4;
	Wed, 19 Feb 2025 08:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954676; cv=none; b=Z+FmmNXus4TP8uypS4KKwI3xnPuBFWqhZJQJOTOipQjG7l+1zsUfcWpH03/bz6P8KqC1l10xaLPMawbg/wptIY3yF+I3XAWF2rbCMPNpiniS6xb2aoIZ5Evx2y09Zdo2oI379648ZQYjDbze9iVzW2eQqJE47OJOnCkOBv9SpnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954676; c=relaxed/simple;
	bh=qMFZPa3+/bL3szjTOYoAd4ZbuREe1cd/Wnu83HsoaVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+Y5EbYA+j3k3n1TmWE13SLALfmvlNXvu62KOWDTXI2g/6HsuBrHAE9ZxFPgfQvw5RYExIJp5HlEm9T7KJvIyR1LeBHXAuMUUpw+WDNmSnG/ButlMX48XilAcmrWuK3xUuM9KQPlJCdLgTGTARruDRDka9wu5he1SgPwULhxBEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8MWqMVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8MWqMVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22222C4CED1;
	Wed, 19 Feb 2025 08:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954675;
	bh=qMFZPa3+/bL3szjTOYoAd4ZbuREe1cd/Wnu83HsoaVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8MWqMVqSnUMMOg04eM3zvlP2CssIhIZzbwJ1pb9kNyX3AfqUPMVs5+dv4pkW2Ryg
	 Eg4w+vxzkEpgvUmdVBFsqhmMtuk+DpJj2OCV6sgEOm9A9vq5ExDo/cKwDwLzfGyH+y
	 UJfXGPQXjiCLjFcz6RNbUTNnhBxOH+2dA3+fCUS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 246/274] io_uring/uring_cmd: dont assume io_uring_cmd_data layout
Date: Wed, 19 Feb 2025 09:28:20 +0100
Message-ID: <20250219082619.208320780@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 34cae91215c6f65bed2a124fb9283da6ec0b8dd9 ]

eaf72f7b414f ("io_uring/uring_cmd: cleanup struct io_uring_cmd_data
layout") removed most of the places assuming struct io_uring_cmd_data
has sqes as its first field. However, the EAGAIN case in io_uring_cmd()
still compares ioucmd->sqe to the struct io_uring_cmd_data pointer using
a void * cast. Since fa3595523d72 ("io_uring: get rid of alloc cache
init_once handling"), sqes is no longer io_uring_cmd_data's first field.
As a result, the pointers will always compare unequal and memcpy() may
be called with the same source and destination.

Replace the incorrect void * cast with the address of the sqes field.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: eaf72f7b414f ("io_uring/uring_cmd: cleanup struct io_uring_cmd_data layout")
Link: https://lore.kernel.org/r/20250212204546.3751645-2-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e663da62ba86 ("io_uring/uring_cmd: switch sqe to async_data on EAGAIN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index caed143fb156d..b72154fefbee9 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -268,7 +268,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret == -EAGAIN) {
 		struct io_uring_cmd_data *cache = req->async_data;
 
-		if (ioucmd->sqe != (void *) cache)
+		if (ioucmd->sqe != cache->sqes)
 			memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
 		return -EAGAIN;
 	} else if (ret == -EIOCBQUEUED) {
-- 
2.39.5



