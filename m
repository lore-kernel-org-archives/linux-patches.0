Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155E7151CC3;
	Tue, 20 Feb 2024 20:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462710; cv=none; b=T2okCp+IzytVhZYSUfqBqEXriDQ2Nq2Rz0UFlnyoGsjo/CAm21tf+rYS7/gcsLBeuHNqVTHU72D424v94huB3ASl8NnSU+nhQIvV7JFYJiXYJSGaD/g8VzNtvBJ7KEWw12rn4VmzOYy/wesPA+G9im+DwwBbgJ4O2uhAbkLwoNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462710; c=relaxed/simple;
	bh=6QJR2ZLSKKRVWHU5N66CL64J5jpla0ze8bFgDiuZyRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZEBgEUhJ72nTsyujEjLDknazLeZftbDll87LkGsN62VeiQzaIQdREbpyk0b40wOqnjoFjNxjM2FKWVG/YK0lPMdDv7A0Gp4LEEuRd6o7Bezd4kIkH8ozw+ZndCjP7KcHgXlRmFED9Pb5H8YueYpXxZnbYG2lt6IQcSEsJnogRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVs25XJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVs25XJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C210C433C7;
	Tue, 20 Feb 2024 20:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462709;
	bh=6QJR2ZLSKKRVWHU5N66CL64J5jpla0ze8bFgDiuZyRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVs25XJ4v38FuW39Gnqxx5v2wS1OhPxzZo2yBomSGiVrbpvr5HOH2wOgRlx7HaRCg
	 HpgtnDnTwDs1QhmirQpwP9E8lrC/TdMquKsaiEtEsWeuCLuns1/wVknNWNriA/kvNZ
	 F4AZLaydMnz3aawXd/OjLRXzYwhBkoGzqNniNY2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 005/197] btrfs: forbid creating subvol qgroups
Date: Tue, 20 Feb 2024 21:49:24 +0100
Message-ID: <20240220204841.238619794@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4695,6 +4695,11 @@ static long btrfs_ioctl_qgroup_create(st
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


