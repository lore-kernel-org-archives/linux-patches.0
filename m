Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607DA268FF0;
	Tue,  8 Apr 2025 12:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115997; cv=none; b=W2j48PlxKBsJtygeHE6pRdjnhSPWM6zYH+Ohz16OqU0uBo9FfeN/V92yiN+XnOo85OP7AxcjbHb0IPO6DxyHKzkrV3BC1uBduL7XBb+D3E1OklgdZqihxm4CX0wsul5txl2G6mRzLUSL55ODAyRqf+RI+FYlmkG9qeO14hG6ZzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115997; c=relaxed/simple;
	bh=1gumGZy/TABWmDuhRfsLQ4Gv6RXGL7zc2Xkx4ck6z70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcE8/akRsmkQygLSVQ90dgHE/i0C2hGPz8/rdmhoIzDYOQgdF1bKS9Nov5Zq7YmL2LPrNxw5Fn35iVYynSAvqP+cfnVXJIHDlCMObAappCHv+IiR/O+r/9U62M1H261b/7sJSC2dF8Hy1auXQov2H6Lfy2FTdxopOixc9IkpaTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RikvaKyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RikvaKyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30DBC4CEE5;
	Tue,  8 Apr 2025 12:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115997;
	bh=1gumGZy/TABWmDuhRfsLQ4Gv6RXGL7zc2Xkx4ck6z70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RikvaKyXJx6hK/VCoJz38zNqWby3crj6GoRyQOZCTfVrcBcH74uqHRA2oo0qjvvJm
	 9N5AnyyvXasucmNUr3YXDfmVAvKIjfo1JSFi11Hep1s2An7tJK/ru/a/liR1aw/BGf
	 iWlQccdOS4M8fs3vVAWGqH0fjN+HUtz3/0ZHil+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 182/204] btrfs: handle errors from btrfs_dec_ref() properly
Date: Tue,  8 Apr 2025 12:51:52 +0200
Message-ID: <20250408104825.659122094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 5eb178f373b4f16f3b42d55ff88fc94dd95b93b1 upstream.

In walk_up_proc() we BUG_ON(ret) from btrfs_dec_ref().  This is
incorrect, we have proper error handling here, return the error.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5575,7 +5575,10 @@ static noinline int walk_up_proc(struct
 				ret = btrfs_dec_ref(trans, root, eb, 1);
 			else
 				ret = btrfs_dec_ref(trans, root, eb, 0);
-			BUG_ON(ret); /* -ENOMEM */
+			if (ret) {
+				btrfs_abort_transaction(trans, ret);
+				return ret;
+			}
 			if (is_fstree(root->root_key.objectid)) {
 				ret = btrfs_qgroup_trace_leaf_items(trans, eb);
 				if (ret) {


