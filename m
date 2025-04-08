Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24962676DE;
	Tue,  8 Apr 2025 11:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112958; cv=none; b=FN/z/FfwWV8emGAPUgDiS2sPY/bKaPJzIX89FV+sjL/rs20yDmYOdqCSyBSRWsUaPJjw2/jzCt6zXtAvn3tuMn8wIDUvKOhLW0wDE9acnGG3NJHaV41zRVKXvDspJApQWxY0qy/XwY9ttiQGk+eV8dptqjIVR7z8eXypdnSw0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112958; c=relaxed/simple;
	bh=uizRlo33MIM1CiliC+xHX+WO1UM5P3ZobZmviZVPRB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f21EuObMzsSN7xU80PL+W2bfmu+mYQdTVGQCaqnRu3bbEAbPghjOweXbSr8APc/0Yys8A0j9G2RU3IpXcikUnPWuwWvqv7zkq08Lugi5IdO0OIu0tfviZZTk7MPpWWpDdUX4s2gde/fGm8B5/JFYdEa7Z4w8nZehUvOnQXtW2M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRgS1V4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRgS1V4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6399CC4CEE5;
	Tue,  8 Apr 2025 11:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112958;
	bh=uizRlo33MIM1CiliC+xHX+WO1UM5P3ZobZmviZVPRB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRgS1V4ZCBheKkdcbFocm2Yi99b8SV3p9zjBGKntE9H3uOUZuBbz2VdDwtE+s75AA
	 lHRd/jubOCNLb9OSTx89l8XkSDRd59qQrBAHqPbnvJouvpCK61uO4jQxEcAp48cTo6
	 VjZA+HDg2j9cY+6mlM0gkp5CDpVUjfA2YcqNbFI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 262/279] btrfs: handle errors from btrfs_dec_ref() properly
Date: Tue,  8 Apr 2025 12:50:45 +0200
Message-ID: <20250408104833.455189858@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5461,7 +5461,10 @@ static noinline int walk_up_proc(struct
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


