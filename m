Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2853017A93F;
	Tue, 16 Jul 2024 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145209; cv=none; b=nF6DA6pn1IovSaEAFSgTYd/YWz/AY4uSbV05z65aOhqm8caAU9rC0qhrluw7u3e+5znAiF34DM3OMXO6go+N8vPcadVBCdjDqQyTi9oogW73d1/03DhFQeiFVHwkLV6oZHpVlAWJVogiG/YL0kxIqea2jmJf4V8Ionk+pWGAPVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145209; c=relaxed/simple;
	bh=+VhqDU8Ycv9I63f+rl4TxSh13c//1FVx1rJ/HcaJ2zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGYqtTW1EAGHKf+u5VJVPdcYcM2mcOecP3Gez67SmvsEzd/GMmV3/vGdG2HU6IjLB7XST66wLQVV2yLBdXkKnjGCzFCGB+olQlkI+BFeNdka3/3XfcvVVfCxJr+dzcsFyVqy7un2ICx4KYaqzT1mXQ8wiwnmPIUchCT9LPz5DcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epPhfuke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epPhfuke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A322EC116B1;
	Tue, 16 Jul 2024 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145209;
	bh=+VhqDU8Ycv9I63f+rl4TxSh13c//1FVx1rJ/HcaJ2zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epPhfukeBW/UTjGnPydzNgqiNIcYoabmdc50ee/OGE6KvEjgb7K7u0kEh2EkuHQ2E
	 0GqgMbH9DTU9+ApAexWdgpJjJiVIN0bii50DENYbIrXEdzYHrHCUSdtARLpt8KI90q
	 YGFsl30C7gS4trbFf5n25L/bXDuxUqCqbaqjW6uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"sashal@kernel.org, tytso@mit.edu, jack@suse.cz, patches@lists.linux.dev, yi.zhang@huawei.com, yangerkun@huawei.com, libaokun@huaweicloud.com, Baokun Li" <libaokun1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>
Subject: [PATCH 6.9 134/143] ext4: avoid ptr null pointer dereference
Date: Tue, 16 Jul 2024 17:32:10 +0200
Message-ID: <20240716152801.150173479@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

When commit 13df4d44a3aa ("ext4: fix slab-out-of-bounds in
ext4_mb_find_good_group_avg_frag_lists()") was backported to stable, the
commit f536808adcc3 ("ext4: refactor out ext4_generic_attr_store()") that
uniformly determines if the ptr is null is not merged in, so it needs to
be judged whether ptr is null or not in each case of the switch, otherwise
null pointer dereferencing may occur.

Fixes: b829687ae122 ("ext4: fix slab-out-of-bounds in ext4_mb_find_good_group_avg_frag_lists()")
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


