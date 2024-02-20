Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6205414AD12;
	Tue, 20 Feb 2024 21:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463373; cv=none; b=IPscHqGQXn6diEG1/tMQ1iJTqHTwwSKfBRmvnawXXKL/bYL7cj2H8/1BYm3erGTJmJba/I/sumTJhLIa1bLVtdILIvvYaJ4EZ91C5qNu7vOAbMMTvu+lX1oiO/bsLlvCMRV0ry68/i7nb7oSskI7zWlN8q2vt+N7pYy4dS7QE+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463373; c=relaxed/simple;
	bh=WcCyiV3I0lLzHbFDI0GGrfmgzKRV0yRGoWVwnzRFCJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN+QhcEhhvMha0cTWySTtibBfnANTwwHMJii/sU21nd1FiyAaVbYTK8tQUU9ywT3JVB6KDtE30/jTsUvbebix6ISg5lvUjJCEE91KqFQOei+WrMaqj+ZINyarNIiyGMxbK8Maw3sXu6z/4HBpa9z20VQuWmpx+q25p4BSXC/MQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkiFCPmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkiFCPmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9522C433F1;
	Tue, 20 Feb 2024 21:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463373;
	bh=WcCyiV3I0lLzHbFDI0GGrfmgzKRV0yRGoWVwnzRFCJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkiFCPmHRtJTekp8zhjZF399RtECqytJHmMQqoDJ4JWopSHJYnZxETa1NQ6Ygc3rI
	 biryEOef2Azy3Y9nP4UT0/+J93pWaJs4IoZh3cpda6Dq+NS+dEYEUcR8GqqRTzN4DG
	 MEYbsc9VfWJlcwy1sBZJKpmZ23WiLOiT6sIyOPkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 005/331] btrfs: forbid creating subvol qgroups
Date: Tue, 20 Feb 2024 21:52:01 +0100
Message-ID: <20240220205637.751281247@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
@@ -3810,6 +3810,11 @@ static long btrfs_ioctl_qgroup_create(st
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


