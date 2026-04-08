Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619802DAFAA;
	Wed,  8 Apr 2026 18:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672419; cv=none; b=WPqM5w4iNjk6ctDaoDs25+mvBdcJQX3srKWpMMICW7vOJ+YUkkXspAKExvQBJebHKN9XZp6hcM7URgyi0oLifo+nPtBdSWoFmo0IzuY+R2i1bBykvMfS9WK+F5iWclE5hd4z4FQSbRWN2adtczAhhj9hHmuL5wpWJAQpryBMUPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672419; c=relaxed/simple;
	bh=YOQJzXraDIWw5tjqfGnuAriQgTXVlaq0aWWfaOzI+js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oitNMQmnZy50yOSLsM8zFOo5ZYWFMgGO+Gqv2LY6qzeIFmBIsTURw21K2/Db/HmYs9ekVBwpZ/70mDZzdrPwuffopsiLD309DFTe02pqbX/nw+DOqPN97Pbi18Zw+tjnjuvrQGT5luYVhPMLTyYsTAjADIjCB+E03Kv7hPlGeb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGbmpOpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGbmpOpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62EBC19421;
	Wed,  8 Apr 2026 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672419;
	bh=YOQJzXraDIWw5tjqfGnuAriQgTXVlaq0aWWfaOzI+js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGbmpOpyFBCvMUBKPHEYBFuMtiNogzX5LPLeM6YHibYOxhcNLNpLjzo4uga5JUD8u
	 ygrD3h6jQwVpIrac9swJfwg/5nwIEtk2FZdK+vEs0zaLT9oRO3rWhkhAtLW07aYKGk
	 nrQ2SFeIftJjTYpBNLniLmlJ6iEVRDzJNOl0kb1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Chao Yu <chao@kernel.org>,
	Alexey Panov <apanov@astralinux.ru>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 298/312] erofs: fix PSI memstall accounting
Date: Wed,  8 Apr 2026 20:03:35 +0200
Message-ID: <20260408175944.896580830@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 1a2180f6859c73c674809f9f82e36c94084682ba upstream.

Max Kellermann recently reported psi_group_cpu.tasks[NR_MEMSTALL] is
incorrect in the 6.11.9 kernel.

The root cause appears to be that, since the problematic commit, bio
can be NULL, causing psi_memstall_leave() to be skipped in
z_erofs_submit_queue().

Reported-by: Max Kellermann <max.kellermann@ionos.com>
Closes: https://lore.kernel.org/r/CAKPOu+8tvSowiJADW2RuKyofL_CSkm_SuyZA7ME5vMLWmL6pqw@mail.gmail.com
Fixes: 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted images properly")
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20241127085236.3538334-1-hsiangkao@linux.alibaba.com
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Link: https://lore.kernel.org/r/20250304110558.8315-3-apanov@astralinux.ru
Link: https://lore.kernel.org/r/20250304110558.8315-1-apanov@astralinux.ru
[ Gao Xiang: re-address the previous Alexey's backport. ]
CVE: CVE-2024-47736
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zdata.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1574,11 +1574,10 @@ drain_io:
 			move_to_bypass_jobqueue(pcl, qtail, owned_head);
 	} while (owned_head != Z_EROFS_PCLUSTER_TAIL);
 
-	if (bio) {
+	if (bio)
 		submit_bio(bio);
-		if (memstall)
-			psi_memstall_leave(&pflags);
-	}
+	if (memstall)
+		psi_memstall_leave(&pflags);
 
 	/*
 	 * although background is preferred, no one is pending for submission.


