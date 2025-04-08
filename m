Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9E4268FEB;
	Tue,  8 Apr 2025 12:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113751; cv=none; b=W4oqxbAEJdcUTmLWtGRbBHawJzUT51Z8RnTeNDHubJCZb580YrR22wQ71kj6oeO8JMeey91CUSi/4ZuUDBBMBsTeI5aHRER95j5Kmbn+3FA9FHMUvy7874Q9xQcX/ZEMynDgvF0jCGnyIWhOwTf1h94UOLlXlscZOa5Q3CnE0VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113751; c=relaxed/simple;
	bh=tVfxY+VgjURUkNRsR4ORK00xgPVRV5I2whwqn8IYSvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPF74HAQLyumRw+46xqK1vsztVuiAa/fDFQVOohZaOqxw9froM41yyOGDaEQGZowtb8BG2AGARU6y2QBSy+6W508E+EOQ4anoCBGM3DlQZpJ9g9hGiKa00C97vWWobFBdAOgUuutxMtcTMGk93B1ICbsvlUbnxOhajEy56c8YAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4H/qQNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4H/qQNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C949C4CEE5;
	Tue,  8 Apr 2025 12:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113750;
	bh=tVfxY+VgjURUkNRsR4ORK00xgPVRV5I2whwqn8IYSvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4H/qQNsyeoC3fZMjXccQXFTvNisz+IPi+cC5YuhOjpNbQhLC5U3E082OdbfdyIiR
	 mo/W1NhCXbkp2M5ACLNxMXB8wXNR91pFmICv81IiMAECzBsoezxf7RXy5jsLHDwx0p
	 VVQJkhrI26DkoiFDHhwBH1bwcjoWkBxjCUphopzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 243/268] btrfs: handle errors from btrfs_dec_ref() properly
Date: Tue,  8 Apr 2025 12:50:54 +0200
Message-ID: <20250408104835.141681561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5540,7 +5540,10 @@ static noinline int walk_up_proc(struct
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


