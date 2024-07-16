Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120AB19AD91;
	Tue, 16 Jul 2024 13:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721136662; cv=none; b=FAwCfKY21XLENj3UUlzi9eYKUC3xpy+WCFKVTJMP5pQ8esKrear2pCFfAA62TSl+falWXqXclcUHKwSWNHUA8HujzolfUIfDeZPjrnOg6X2ypPCdzfqMfD7HEf+swRRJJ+VWN0scxjokCxWXoMYkHHGMZ/I5KUDde88YmtgpVVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721136662; c=relaxed/simple;
	bh=jxMLLsvZvs+zGRMbSM8orLqBBdj2uU/7aDxUYGo0VuI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=IzxRODR8C3MkbJ1OoMMFUMK5Wn9XXb2LLTbrYUdak3cLmQ+cNoOhCsHFyRQwo6rBUtkiY5ltSfMWd8Z5GwgSHQkb3JYTsRxn1paEnaccWx7g8p4KRptvcu9nuJrH/9Alt8ZoY0CBc12K2pKOAlQsedhe0xeHkuvcqTUBj6xHiA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bolaiR3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bolaiR3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECF7C4AF0D;
	Tue, 16 Jul 2024 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721136661;
	bh=jxMLLsvZvs+zGRMbSM8orLqBBdj2uU/7aDxUYGo0VuI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=bolaiR3/l/Bn5E6xDjNgdLE8dQEE5fOQ7qPrwIEvl1IzqXjJzdLXgRdOmygn0HebA
	 DGImXmlnGuyPNWZyDcSr0m3YJZuK79gNDnDI8AHrH9NWEEpBluJIcihvCwvTqmr9Ww
	 LiHIWiO72kt1GADNitKvZdfOcuMOGKCu2Wf0KSEY=
Subject: Patch "ext4: avoid ptr null pointer dereference" has been added to the 6.6-stable tree
To: gregkh@linuxfoundation.org,jack@suse.cz,libaokun1@huawei.com,libaokun@huaweicloud.com,patches@lists.linux.dev,sashal@kernel.org,tytso@mit.edu,yangerkun@huawei.com,yi.zhang@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 16 Jul 2024 15:30:58 +0200
In-Reply-To: <20240716092929.864207-1-libaokun@huaweicloud.com>
Message-ID: <2024071658-retrace-ascension-b374@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ext4: avoid ptr null pointer dereference

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ext4-avoid-ptr-null-pointer-dereference.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From libaokun@huaweicloud.com  Tue Jul 16 15:13:28 2024
From: libaokun@huaweicloud.com
Date: Tue, 16 Jul 2024 17:29:29 +0800
Subject: ext4: avoid ptr null pointer dereference
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: sashal@kernel.org, tytso@mit.edu, jack@suse.cz, patches@lists.linux.dev, yi.zhang@huawei.com, yangerkun@huawei.com, libaokun@huaweicloud.com, Baokun Li <libaokun1@huawei.com>
Message-ID: <20240716092929.864207-1-libaokun@huaweicloud.com>

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


Patches currently in stable-queue which might be from libaokun@huaweicloud.com are

queue-6.6/cachefiles-propagate-errors-from-vfs_getxattr-to-avo.patch
queue-6.6/cachefiles-cancel-all-requests-for-the-object-that-i.patch
queue-6.6/cachefiles-add-missing-lock-protection-when-polling.patch
queue-6.6/cachefiles-cyclic-allocation-of-msg_id-to-avoid-reus.patch
queue-6.6/cachefiles-stop-sending-new-request-when-dropping-ob.patch
queue-6.6/ext4-avoid-ptr-null-pointer-dereference.patch
queue-6.6/cachefiles-wait-for-ondemand_object_worker-to-finish.patch
