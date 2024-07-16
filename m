Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B47B1DDCE;
	Tue, 16 Jul 2024 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145872; cv=none; b=Im2rHhUWgMDY0lchTDNzK30/WEQoCsfqv31oUMTZfCFCyP0yQQQ4AD3p7bbGqRHA68udyXZ11odhy1BvjHb4EY8LkpFRVLU1sq36MaXUKTqPig3FRHLK3rczlCyPQ74OQ+Kntndq3Rulo3J46oe7o26N+WmNHGeLewn11AO14HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145872; c=relaxed/simple;
	bh=kCVLbqWNVr4DUGdfXLYcHGU6zKX0MhwZQh7E2oUs7Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsPof1MGzIGRTkj0wfOyd60asQCEnTwy3MxO8aDoELsrEVs0L2Xqri6KEyZSAAO3SqdwnSyV5hawy+QUTZyOYQbQVz32LWQIjHA10Qnv/Hookj/BZhEfO7p+/A8+YXu23i6kl5SX3bpBj4op+ymoUQFCGgWx9pe8hdpXHoT23wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWlgIrA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWlgIrA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C33FC116B1;
	Tue, 16 Jul 2024 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145872;
	bh=kCVLbqWNVr4DUGdfXLYcHGU6zKX0MhwZQh7E2oUs7Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWlgIrA+UgN0w9GWWkYMw815ydnlMwE6sQb6qASI0NMSVhS2ioyKzo6cWw8BZEA3N
	 TdFswZxMizjqdzkvgoSmjd8pphX6KEgBndeAF5h+xkWFqFfC371qeWJRitfRwuAxZO
	 OpUZy5cKGYSDkEN9q0fHnKZeEo9p/awbOQ3CWI10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"sashal@kernel.org, tytso@mit.edu, jack@suse.cz, patches@lists.linux.dev, yi.zhang@huawei.com, yangerkun@huawei.com, libaokun@huaweicloud.com, Baokun Li" <libaokun1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>
Subject: [PATCH 6.6 107/121] ext4: avoid ptr null pointer dereference
Date: Tue, 16 Jul 2024 17:32:49 +0200
Message-ID: <20240716152755.447446895@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

When commit 13df4d44a3aa ("ext4: fix slab-out-of-bounds in
ext4_mb_find_good_group_avg_frag_lists()") was backported to stable, the
commit f536808adcc3 ("ext4: refactor out ext4_generic_attr_store()") that
uniformly determines if the ptr is null is not merged in, so it needs to
be judged whether ptr is null or not in each case of the switch, otherwise
null pointer dereferencing may occur.

Fixes: 677ff4589f15 ("ext4: fix slab-out-of-bounds in ext4_mb_find_good_group_avg_frag_lists()")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -473,6 +473,8 @@ static ssize_t ext4_attr_store(struct ko
 			*((unsigned int *) ptr) = t;
 		return len;
 	case attr_clusters_in_group:
+		if (!ptr)
+			return 0;
 		ret = kstrtouint(skip_spaces(buf), 0, &t);
 		if (ret)
 			return ret;


