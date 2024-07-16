Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81B757888;
	Tue, 16 Jul 2024 13:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721135738; cv=none; b=I0U0LHxp7kUMMG8OQXxisQDwQ9oFmWhEHkoulaTlin27cf7F6d3Ox6ov8LU8Ny/4MPGlK1icoa8L8jqqooqPxynNvljh/uAT7yxk7MkieVdJ4WMzih/y9ZND1damSW4SAmtmmc4IQ21h1qVmn5wGA21eeEcXgFk4gsRikA6zQ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721135738; c=relaxed/simple;
	bh=7XZqaSz4MRdYjhNpeJp/4EcPW7rd5Qbqi7lfouyo2IY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=jwwSsFZ1rG7HRlpsQ75xpEF1ifvCz9qF2zll4B7YB1XSLYi4MdC/iyHGS47FERotfLNaAoqly/W3RobCdgGPTi1Yimczj86B7iWsPVx8ZCsA/5+C6kQU4CRATpdbrorMUHulCfhuFOywQNw7k48XN/4hD2af0kwI6iIdwDyMI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vp7exJDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vp7exJDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C023DC116B1;
	Tue, 16 Jul 2024 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721135737;
	bh=7XZqaSz4MRdYjhNpeJp/4EcPW7rd5Qbqi7lfouyo2IY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=vp7exJDWnWYO4aQe+DSbJ7xuIpnupqkxnAuaLTrgAvqm9GEX3X/uWApBoHrtG2RWn
	 LOZULC+8figQ2Fs592NNfEpGJIk1+XzIPssk3IFpQLoF3aNLp7Cz3bQPSDUGi8+eo6
	 9P3ySahPBUXSbNyZIpIRJTW8hw8vQ/LZKOeEBK3Y=
Subject: Patch "ext4: avoid ptr null pointer dereference" has been added to the 6.9-stable tree
To: gregkh@linuxfoundation.org,jack@suse.cz,libaokun1@huawei.com,libaokun@huaweicloud.com,patches@lists.linux.dev,sashal@kernel.org,tytso@mit.edu,yangerkun@huawei.com,yi.zhang@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 16 Jul 2024 15:15:34 +0200
In-Reply-To: <20240716092929.864207-1-libaokun@huaweicloud.com>
Message-ID: <2024071633-verse-doctrine-a562@gregkh>
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

to the 6.9-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ext4-avoid-ptr-null-pointer-dereference.patch
and it can be found in the queue-6.9 subdirectory.

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


Patches currently in stable-queue which might be from libaokun@huaweicloud.com are

queue-6.9/cachefiles-propagate-errors-from-vfs_getxattr-to-avo.patch
queue-6.9/cachefiles-cancel-all-requests-for-the-object-that-i.patch
queue-6.9/cachefiles-add-missing-lock-protection-when-polling.patch
queue-6.9/cachefiles-cyclic-allocation-of-msg_id-to-avoid-reus.patch
queue-6.9/cachefiles-stop-sending-new-request-when-dropping-ob.patch
queue-6.9/ext4-avoid-ptr-null-pointer-dereference.patch
queue-6.9/cachefiles-wait-for-ondemand_object_worker-to-finish.patch
