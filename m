Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF74C62;
	Wed, 21 Feb 2024 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525597; cv=none; b=u7Hqllpaayui4zZt9p03jgilsJQuERfdrDF8wd/0CrvKNbNLJJjuE5eJoxU8uMoApcQcPjZbw6V+8HmVwaxUmDokuq5O3O+KVGTu5P0qAoh0GdSYkFtL/AKp/xeCKP3q2KUEI0SdINJL2xnkbTH0HNuMse4V9XF6dryVqOv6oBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525597; c=relaxed/simple;
	bh=t+F7YqvhrYoNKLEYWA1N1lr9N2N6gEfrmMEEC+tq4vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRkJh0zgTkdE65ewmOFGnKnEEbSncgbsMQVx3qzIhskO2AvB1zO3ihR3AM7sIX2M23j1zXM9/gnsGm/AVchqlDQgiL3SnSpyRmKWRNB79saNpE6Ke9L5pScrSnII3BStgflTBL09350yX8i/e37gu7bNb9ABdFYNhtYiQgA9S/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3vCkvuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3vCkvuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE4DC433F1;
	Wed, 21 Feb 2024 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525597;
	bh=t+F7YqvhrYoNKLEYWA1N1lr9N2N6gEfrmMEEC+tq4vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3vCkvuCV6FDAIXnZZcqbjF7SLaNu9tdGonu1QgvMdIx+I97FvYQOhergcxvDko++
	 CFm7gAd3o3Dr30VoZOtR0oR/3+CzbAaM6uSjOYIIz5JLGtqRC670dfSwwBXZSJlKy9
	 IHi+qIOC2oYuAeGd74HGAkP5eBfieiJf5Mf0v5xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 204/267] btrfs: forbid creating subvol qgroups
Date: Wed, 21 Feb 2024 14:09:05 +0100
Message-ID: <20240221125946.573568574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4974,6 +4974,11 @@ static long btrfs_ioctl_qgroup_create(st
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


