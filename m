Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999121C5D56;
	Wed, 19 Feb 2025 08:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954672; cv=none; b=QikIGeswZv6lvXmtOiXEe20kLZUOh4h+wVs0vqIwkbA5LB9dY2DnBJj3AMKj4Pie/TgszRMf0kkalmJOwtLVSqkbMDTIXW76TuryywTlUqkTazJ0yFkjZzYmi0YFTEG5a1/Kp5qjVw7ZmZRD7PjW2r6N8OclEOrTsler4jneBmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954672; c=relaxed/simple;
	bh=Nyqv4WT1l74ZM4cOw0UcIBlmNp/MNSY9W11iGbJGNjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5fdh+Ec8bduUBIjzJkfFrkxFZlcXCdRVgOavaghL3OfvL2313d3hSXfUvjge5FkAKKYx1Mc9onDIrqvvVOZsW53tqosWNn4DbYPc/3KqkBhdwUwY2/bvOl7CpYl2fOPUZ0s9xKrdrJ0xhQGBt6P9tF3yqHn4r7af0GB/5IFw44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaRiwe3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaRiwe3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F8C4CED1;
	Wed, 19 Feb 2025 08:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954672;
	bh=Nyqv4WT1l74ZM4cOw0UcIBlmNp/MNSY9W11iGbJGNjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaRiwe3hbDVJoH7GA7P/BjeECl9eTqzfmOcdSQuOYhfrpIjzWtUBcIwcnwLJVIUNr
	 twVrf3eYkLUcTwejkX0C20zNHmggihFWEVeJq91DvbtO+CD2jNHaC2LmAPOXXmix0Q
	 E16I3TcGhuAwY8IiNdvwIJEZGyjAJPjWLVuXjjs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 245/274] io_uring/uring_cmd: cleanup struct io_uring_cmd_data layout
Date: Wed, 19 Feb 2025 09:28:19 +0100
Message-ID: <20250219082619.169547663@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit eaf72f7b414f5944585e7dee9c915c7f8f7f6344 ]

A few spots in uring_cmd assume that the SQEs copied are always at the
start of the structure, and hence mix req->async_data and the struct
itself.

Clean that up and use the proper indices.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e663da62ba86 ("io_uring/uring_cmd: switch sqe to async_data on EAGAIN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/uring_cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f43adcc16cf65..caed143fb156d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -201,8 +201,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 		return 0;
 	}
 
-	memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = req->async_data;
+	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = cache->sqes;
 	return 0;
 }
 
@@ -269,7 +269,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		struct io_uring_cmd_data *cache = req->async_data;
 
 		if (ioucmd->sqe != (void *) cache)
-			memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
+			memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
 		return -EAGAIN;
 	} else if (ret == -EIOCBQUEUED) {
 		return -EIOCBQUEUED;
-- 
2.39.5



