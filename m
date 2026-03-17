Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C563F23DD;
	Tue, 17 Mar 2026 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766371; cv=none; b=ZsgWevfm27IMXTafsuqmmXG+8/2ec2mHQ2xNGDOcU6UhVYS6D6ONW8r3udq4eU1ADN/bS1DE+pcn8++EFF+GtJaIFnVpSiFPCyCITMno4PGSeqBn1GCaFWod/UTe25Ox7x/qfson8QChXazhNZ3A4mIsLkLu/kOVhU6uPJniajo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766371; c=relaxed/simple;
	bh=ivthcyBx1UX4mfPBhFnkuLT6yIG/mOO3O1TJCLB9rq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuSZDlT2ZGjtUBaTaoYhpzTSNC73HxiQP1+3whjbt+RLsh07DA8b3SY/j8iBeGJJviaMpgzCfi10G1asw8EP/DuYs7RBue6WdRNwRjFVvN9DX5ZPYVJMjeEYlIQp6XEyXFxcYhTkKXRa6qy4mCn7gA4JF7MPlZel2LafFmep0/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQgnqYsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQgnqYsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4A6C4CEF7;
	Tue, 17 Mar 2026 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766371;
	bh=ivthcyBx1UX4mfPBhFnkuLT6yIG/mOO3O1TJCLB9rq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQgnqYsUrWimRWI+ZrSVCQl42PMnLxawRt/RtnoKP+lUMVZTHJouiQrH7Ixr5pc4y
	 CXiD7kmGcE6yrF0L8x4fdWiTibLijsYlz5OliWqPa2Dj4aeHjjc+uvLcjpg4K/NAcM
	 Z/bgKZQscOmfPFcA+bKPgFPNYjZzh4ps1RLgWYaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.19 230/378] drm/xe/sync: Fix user fence leak on alloc failure
Date: Tue, 17 Mar 2026 17:33:07 +0100
Message-ID: <20260317163015.472404626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

commit 0879c3f04f67e2a1677c25dcc24669ce21eb6a6c upstream.

When dma_fence_chain_alloc() fails, properly release the user fence
reference to prevent a memory leak.

Fixes: 0995c2fc39b0 ("drm/xe: Enforce correct user fence signaling order using")
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260219233516.2938172-6-shuicheng.lin@intel.com
(cherry picked from commit a5d5634cde48a9fcd68c8504aa07f89f175074a0)
Cc: stable@vger.kernel.org
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_sync.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -200,8 +200,10 @@ int xe_sync_entry_parse(struct xe_device
 			if (XE_IOCTL_DBG(xe, IS_ERR(sync->ufence)))
 				return PTR_ERR(sync->ufence);
 			sync->ufence_chain_fence = dma_fence_chain_alloc();
-			if (!sync->ufence_chain_fence)
-				return -ENOMEM;
+			if (!sync->ufence_chain_fence) {
+				err = -ENOMEM;
+				goto free_sync;
+			}
 			sync->ufence_syncobj = ufence_syncobj;
 		}
 


