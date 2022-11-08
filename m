Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFB615CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F71C433C1;
	Tue,  8 Nov 2022 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915496;
	bh=L6RSxyS58v6yYt6HfXv4poqGg9tYqqREq/83YoUmBEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWiehHFTIBFuRv7rnvXCK46CjKkTVzrFNhopzGrEwCdjxrUncqLUmMc+VPOvmit9T
	 ZGNpumuKmmBcpAI1CgFoVVnNvzXVN3M0Sp3VU+ZZdO1Tbfz8R30+lP7S1MPwZ1Lpu7
	 b8M79a3/W1VbAOe8y139MaaSBr2A9FUzfcsXl5ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuhong Yuan <hslester96@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 42/74] xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()
Date: Tue,  8 Nov 2022 14:39:10 +0100
Message-Id: <20221108133335.453606651@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuhong Yuan <hslester96@gmail.com>

commit 8cc0072469723459dc6bd7beff81b2b3149f4cf4 upstream.

xfs_ifree_cluster() calls xfs_perag_get() at the beginning, but forgets to
call xfs_perag_put() in one failed path.
Add the missed function call to fix it.

Fixes: ce92464c180b ("xfs: make xfs_trans_get_buf return an error code")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2592,8 +2592,10 @@ xfs_ifree_cluster(
 					mp->m_bsize * igeo->blocks_per_cluster,
 					XBF_UNMAPPED);
 
-		if (!bp)
+		if (!bp) {
+			xfs_perag_put(pag);
 			return -ENOMEM;
+		}
 
 		/*
 		 * This buffer may not have been correctly initialised as we


