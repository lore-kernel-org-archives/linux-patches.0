Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5CE69953;
	Wed, 21 Feb 2024 13:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521635; cv=none; b=XIwgF1bEP45QSq8ojmxJaG6d6oRuoicWDS5W18X++/G/bXUZQXrlAblJo3KKTnqYYVGH08Hnwknyxxmw2Z/fEDh1GE2xyUe6RPCpu0yUIv7TEKBbH++SARjlFQf19LmCxdX/KovLVsa2HaYlLc+k8Wg0ogt9yswbAEnrSQIYwd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521635; c=relaxed/simple;
	bh=lXwza2IAWTW4FbeJkr0TOOUkLDDBVZHtDhwxntVOrHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiJrdtK76rd9IgHpY3dMLauhIj+FP3qBEAeHj+tJXIMp7Tmvyx2lrEmfHR99oAT36NCFgoIAwTn4JKNtpR8mPwamwrkzUj+Hxy5KH6vJcNoC/4z4ADW4tDm21gpCPy7lusKtV/tKM81/SKxzcheERtRp3DcgqDtYOJEq9S8PxeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFDFC/ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFDFC/ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09365C433C7;
	Wed, 21 Feb 2024 13:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521635;
	bh=lXwza2IAWTW4FbeJkr0TOOUkLDDBVZHtDhwxntVOrHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFDFC/otzJW7mgy7eMMrC8WvhYoDZpl7CTrLvcDMKTHFXppGTuEy8J6v1H5A4lB+7
	 c16EnqLqD6jd3M6o6ynFeC0/VGIzyhRkCIsUu6VpRHtjQrFfjYX5BCvLJJSt6JtRJk
	 OwF0HT7x9oQ2RAj9mBNymMopXPNR6JKc9U59K8Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 165/202] btrfs: forbid creating subvol qgroups
Date: Wed, 21 Feb 2024 14:07:46 +0100
Message-ID: <20240221125937.072522533@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 0c309d66dacddf8ce939b891d9ead4a8e21ad6f0 upstream.

Creating a qgroup 0/subvolid leads to various races and it isn't
helpful, because you can't specify a subvol id when creating a subvol,
so you can't be sure it will be the right one. Any requirements on the
automatic subvol can be gratified by using a higher level qgroup and the
inheritance parameters of subvol creation.

Fixes: cecbb533b5fc ("btrfs: record simple quota deltas in delayed refs")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5343,6 +5343,11 @@ static long btrfs_ioctl_qgroup_create(st
 		goto out;
 	}
 
+	if (sa->create && is_fstree(sa->qgroupid)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);


