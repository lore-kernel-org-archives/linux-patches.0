Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AB5188006;
	Mon, 23 Dec 2024 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970252; cv=none; b=hSfoToiRseb/WE6mKDh5iqgtfawBndD9x54wXnxueIuClM9PFyV4LVWJgUDzahr0iritl1Q2SyTbuWH8gqxiRyvbWVPg0CaAwaWu5mtXVE6ScPuLDy6GS2r6em+LVJnUw9mc0U6+xRUIl7QoDGRqRrF7k24YMsqq9ESnCRrMFH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970252; c=relaxed/simple;
	bh=uCrU8X7z7E37nEpBeRsPWgl2QihJFFHf4ACsP2mYZII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRSr+8pU+cfCqxq56ebrksXqvLZ0yJtx97+tNiqQxsJ1BwqhC0gCSM4sSm5rsiSRDxhXwYbVoswbY20BrEYaHIVAiHM8HtDOeqF/yf7z6B9CBst+PtKFds/+kUdfDun+w1WmvV9ij8DNgpquxJ7rFNRO3RN14eLrNoQZNNxBK0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2i6L0qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2i6L0qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB26DC4CED3;
	Mon, 23 Dec 2024 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970252;
	bh=uCrU8X7z7E37nEpBeRsPWgl2QihJFFHf4ACsP2mYZII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2i6L0qiY7AFokDByWh1SBDbwH8MD2PLG7hiIYZaVjULxE7PScm8d0fXRVTGWySD4
	 vUbChEX4C03ZM5XmsUURuANWT+gBHj/LeXuHuds4ywXLMsNgn0lWGOujfh5LQhbuVd
	 Z637Q7GRoVUB2xmYV1/TRmO3GcR3zEgLjeTXCt+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/116] xfs: fix file_path handling in tracepoints
Date: Mon, 23 Dec 2024 16:58:18 +0100
Message-ID: <20241223155400.663705296@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Darrick J. Wong <djwong@kernel.org>

commit 19ebc8f84ea12e18dd6c8d3ecaf87bcf4666eee1 upstream.

[backport: only apply fix for 3934e8ebb7cc6]

Since file_path() takes the output buffer as one of its arguments, we
might as well have it format directly into the tracepoint's char array
instead of wasting stack space.

Fixes: 3934e8ebb7cc6 ("xfs: create a big array data structure")
Fixes: 5076a6040ca16 ("xfs: support in-memory buffer cache targets")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403290419.HPcyvqZu-lkp@intel.com/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/trace.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 6d86f4d56353..b1e6879a0731 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -784,18 +784,16 @@ TRACE_EVENT(xfile_create,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long, ino)
-		__array(char, pathname, 256)
+		__array(char, pathname, MAXNAMELEN)
 	),
 	TP_fast_assign(
-		char		pathname[257];
 		char		*path;
 
 		__entry->ino = file_inode(xf->file)->i_ino;
-		memset(pathname, 0, sizeof(pathname));
-		path = file_path(xf->file, pathname, sizeof(pathname) - 1);
+		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
 		if (IS_ERR(path))
-			path = "(unknown)";
-		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
+			strncpy(__entry->pathname, "(unknown)",
+					sizeof(__entry->pathname));
 	),
 	TP_printk("xfino 0x%lx path '%s'",
 		  __entry->ino,
-- 
2.39.5



