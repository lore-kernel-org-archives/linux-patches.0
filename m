Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30891C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BECC433D2;
	Mon, 20 Mar 2023 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325008;
	bh=Mz6bGC4ZNvI9XpQAN6UiioEOAv0yyJhVmXWhQxp97tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OH0I4642gFvtWDCDK7eWy/XuGywwsmMi5LFWUEOgBlhRZ8dnqtU5UgmrXMlJxO/u/
	 FtU3HmKjVHPSciKYm0FvgauX0UQEuzh36HmtcnmK8F1AddcMhi1XfpPRbi3SGdS6yy
	 Gf995AShMTtBNM4lT+9ROSGD0gygijsLfjf2Qngw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 83/99] xfs: dont assert fail on perag references on teardown
Date: Mon, 20 Mar 2023 15:55:01 +0100
Message-Id: <20230320145446.903286352@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

commit 5b55cbc2d72632e874e50d2e36bce608e55aaaea upstream.

[backport for 5.10.y, prior to perag refactoring in v5.14]

Not fatal, the assert is there to catch developer attention. I'm
seeing this occasionally during recoveryloop testing after a
shutdown, and I don't want this to stop an overnight recoveryloop
run as it is currently doing.

Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
corruption report into the log and cause a test failure that way,
but it won't stop the machine dead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -126,7 +126,6 @@ __xfs_free_perag(
 {
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
 
@@ -145,7 +144,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);


