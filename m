Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B018932ED3E;
	Wed,  3 Dec 2025 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777075; cv=none; b=hmiz+JA0frcGR3HwYGtKXcA7HEHBzFVtW734qcCh98Ri1cxhYNq4q/2QxU/qfj7uKqjSTwTb6Rf21F/cRQT2T1iFPaqBPmUEqL3G70p2+pBIrF3LBsjsbyruXeWFIDje+pkCkEV5XDCkoLof6K8jStxE+umDGfZGaxVwGrNgqGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777075; c=relaxed/simple;
	bh=B4hW8L2r0Go6X28jKDqJQbynGHxA1vdp9N/1rUtsT1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp7qIsCI/dSwR0Q7ydismzXPSLOBwlrS2BPy+pNsY2cq4ufTxmS6SiMTAB3yVn0zqLVrD6f8PKwwggRO6461ItR24vqmf28xqNqqu1xY44uKEYZtB1F26481beZM01wpJVxmVTxe8KhSsyMxXQalzoRj/XWujgpV5+AVh0Bt1QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z51IqZZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z51IqZZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12098C4CEF5;
	Wed,  3 Dec 2025 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777075;
	bh=B4hW8L2r0Go6X28jKDqJQbynGHxA1vdp9N/1rUtsT1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z51IqZZX6uobgPhyLNhXAfRO8VwzRfA5shQC3jurJt1Luz6MU6J5pwOSt4AKNfrsK
	 hWllD4M5PO6JXga/joGCYagIdHaT4DCgJUCRJNeyL7pWVkp23RbevEvXmHec3InzWe
	 X4IaPz6DZzLdaP4wRKVGsxUrius79cXEvYKUPiRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 041/146] fs/namespace: fix reference leak in grab_requested_mnt_ns
Date: Wed,  3 Dec 2025 16:26:59 +0100
Message-ID: <20251203152347.978252785@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

From: Andrei Vagin <avagin@google.com>

[ Upstream commit 7b6dcd9bfd869eee7693e45b1817dac8c56e5f86 ]

lookup_mnt_ns() already takes a reference on mnt_ns.
grab_requested_mnt_ns() doesn't need to take an extra reference.

Fixes: 78f0e33cd6c93 ("fs/namespace: correctly handle errors returned by grab_requested_mnt_ns")
Signed-off-by: Andrei Vagin <avagin@google.com>
Link: https://patch.msgid.link/20251122071953.3053755-1-avagin@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index fd988bc759bd3..e059c2c9867f0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5901,6 +5901,8 @@ static struct mnt_namespace *grab_requested_mnt_ns(const struct mnt_id_req *kreq
 
 	if (kreq->mnt_ns_id) {
 		mnt_ns = lookup_mnt_ns(kreq->mnt_ns_id);
+		if (!mnt_ns)
+			return ERR_PTR(-ENOENT);
 	} else if (kreq->mnt_ns_fd) {
 		struct ns_common *ns;
 
@@ -5916,13 +5918,12 @@ static struct mnt_namespace *grab_requested_mnt_ns(const struct mnt_id_req *kreq
 			return ERR_PTR(-EINVAL);
 
 		mnt_ns = to_mnt_ns(ns);
+		refcount_inc(&mnt_ns->passive);
 	} else {
 		mnt_ns = current->nsproxy->mnt_ns;
+		refcount_inc(&mnt_ns->passive);
 	}
-	if (!mnt_ns)
-		return ERR_PTR(-ENOENT);
 
-	refcount_inc(&mnt_ns->passive);
 	return mnt_ns;
 }
 
-- 
2.51.0



