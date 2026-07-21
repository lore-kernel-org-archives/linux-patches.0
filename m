Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E163955F4;
	Tue, 21 Jul 2026 16:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649605; cv=none; b=eIyfFd4zqMOIvW5FHd4zu9IeE41a9TLPJvcX9XcF84k9BfNJfUDbjqEm0I1XvPOi+SFl1xPhAsERoNdk2mWzVk00dUHrlE0/mibdxvGddfKLqJQi2Yi1QH3diMEgf9qsFeDgJIX3CD7jxaQj0b9v+liWhShzb4u8/C8lksLaMLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649605; c=relaxed/simple;
	bh=hqKnZkPb6NXoFO/0Cj3t0/h+HQ6oDbMUbLhRsLKV0GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJQnsj7e0Mvl6EKXRrZJD1NYQ3io5zKbA5hnsaqMyep4JOTatZH85umqpAslHeCzK5aDyftT7Jo/KTdOx2zhLaOxaj7Oaft0GYn7oR6gEj70kMPE/7BZ9151q1m0mlQ2YWQQIjenXa4inwxoJPdWtLm9qTqolmHN9sLt/ZA9LcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnoPDhA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnoPDhA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C161F000E9;
	Tue, 21 Jul 2026 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649604;
	bh=pzeNj6QVi/TjqaD3kJcjxBDvDB9fj3m3GVLI3YnVs1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnoPDhA3WJZzI/q+oJF5B2FqyTZyqFwMBxW0aR6qW2wnOe0jONpknkA72D54yhoee
	 a3LGLh2xOBE5++B1rs7EEWNvG93Axanv7p9d3ZEEQGVBYPADFvEk0qQSewen9g/qqU
	 GLEGjgV3c0TG0Fg+ZikuWNv0d47i5vVAefXjbECE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0638/2077] iomap: pass the correct len to fserror_report_io in __iomap_write_begin
Date: Tue, 21 Jul 2026 17:05:11 +0200
Message-ID: <20260721152607.855421480@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit de654d66ff30e75d9308fd4d4f1627addef7923e ]

len is size of the (larger) write request, plen is the range for which
the read failed here.

Fixes: a9d573ee88af ("iomap: report file I/O errors to the VFS")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260610050642.1906695-1-hch@lst.de
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d55b936e698628..5fa9a2c7e30eb8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -850,7 +850,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 			if (status < 0)
 				fserror_report_io(iter->inode,
 						  FSERR_BUFFERED_READ, pos,
-						  len, status, GFP_NOFS);
+						  plen, status, GFP_NOFS);
 			if (status)
 				return status;
 		}
-- 
2.53.0



