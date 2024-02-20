Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9EA1509AC;
	Tue, 20 Feb 2024 21:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464458; cv=none; b=HotbEqFxgZpQdzMvUtZM+ntdiCOm3p717ZBEhKcXXWF+SNbhTnSwjONMlVPlRlxrqi/MeQ7I8m5cqzTekAAJ//0HNMB0OhUiRnZRYPeYvdZrNvb0f5aemPZM76cN4aw9tojO7thjt1GRaKqzyzQO6QKluX8OIw2M6aXd5yciI3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464458; c=relaxed/simple;
	bh=GN+P+ZoM8JgAnXVSqvNuv8xZeB/3sxINnFbg2FTNzPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJpq7cMFmk0SKFwOisTCkpTwJveLd+01LogIJgpdfrtlY28J7tt1fSoKpmvcuL7jYyFs3HUNxH3MGmx2ciEcNzhfhixGSdi38w82dsHg20l6vjedpRW5c433wUd+gAFAncC167i18+tE32aUtAeZb7t3gNa7UOiux/PN7GLs8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWLnQcUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWLnQcUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA167C433F1;
	Tue, 20 Feb 2024 21:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464458;
	bh=GN+P+ZoM8JgAnXVSqvNuv8xZeB/3sxINnFbg2FTNzPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWLnQcUgl/Gf0AiFXq+D8gcC6iYQbXwGs/Us7MFmFj1V+X69qvsqPJby2cWA9V9SA
	 X0Z6t1hysqVCA1rEZuoIy94rwW90cuBJEEyvXBQ6LFqdvzLmS2jiR5qEAVvCCRsfq1
	 wTylrz64c3GlnYLO6QZGTAwHsHnWyYcyAGPD4vcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 009/309] btrfs: forbid creating subvol qgroups
Date: Tue, 20 Feb 2024 21:52:48 +0100
Message-ID: <20240220205633.426539729@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3815,6 +3815,11 @@ static long btrfs_ioctl_qgroup_create(st
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


