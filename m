Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F611DED64;
	Mon,  2 Jun 2025 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874668; cv=none; b=h5CXpUw12SWIrqrEBEUt+lhIDBZtsyzebKJXFqrntn9JuWxyIDpShgZeHHvdYHPzDu1xMK4aeKhU8t1BwUuQXrA8xEEaUY+ZGwJhep2LSVJUn6nFiQjvOBQ7Q/uNXGNKjzG32NC5VhVz+T+6e/TcM3Qfq0M0G6GtzSEg9o8uO2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874668; c=relaxed/simple;
	bh=sErGg95l7uOJd5HiGM7Hue6/m5nhxDnCRkTnnJj+DFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs2KO7klbYSk22BytXCg8mdNshW3gxFWO7j81EHf26L3cMMHAezbSMsvHg7O6f1oNv/VXBf/0iC8x8M2dQpYipYomsFi8OyKN1pAhd0aXwPxCotNX2ZE9kliN57nb3wUqho5GOp2o4YbUktnxWRwbNhEs2qlIsZk7ZHqprfaX5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUFS/y0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUFS/y0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A43C4CEEB;
	Mon,  2 Jun 2025 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874668;
	bh=sErGg95l7uOJd5HiGM7Hue6/m5nhxDnCRkTnnJj+DFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUFS/y0DD4LRGLjIY/Ec/zcRkmSt2NhdwS1ZswHHeIb3j4Ues8gNu+9Q/aR7FjNTl
	 7XTIpbm3ZfJ/vSH0sJvHoyIgWrVVDS+tT1z06eU52Ul6f7yHCvCcwPXoj1t15mEH7s
	 DNg3xEDFvfqDGQ50+TM3BZnNwPvKfnozjShHC8sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/204] pNFS/flexfiles: Report ENETDOWN as a connection error
Date: Mon,  2 Jun 2025 15:47:10 +0200
Message-ID: <20250602134259.475004290@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit aa42add73ce9b9e3714723d385c254b75814e335 ]

If the client should see an ENETDOWN when trying to connect to the data
server, it might still be able to talk to the metadata server through
another NIC. If so, report the error.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 1b88b78f40bea..3b4f93dcf3239 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1285,6 +1285,7 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		case -ECONNRESET:
 		case -EHOSTDOWN:
 		case -EHOSTUNREACH:
+		case -ENETDOWN:
 		case -ENETUNREACH:
 		case -EADDRINUSE:
 		case -ENOBUFS:
-- 
2.39.5



