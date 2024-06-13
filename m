Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6430D143899;
	Thu, 13 Jun 2024 11:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279643; cv=none; b=mf1huqwGBWjArIcOcOg4bmNYEs0DQqbQDWBSjLZ4Sse3p87xEBqSxQKsstAHspC2M6oZhJQSxdJytBQbr22TmcPqFQ6YtQlllSwhspYaq28ofwb+m3+ZmHAcQkz+htuvZvUo/MCmjIaPNl0CIeYMmP7/7eXVAmJCenpMHWeZo7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279643; c=relaxed/simple;
	bh=G1sZy2UBbtnU/MsKgSXk1RhK6OOFpOp9eMUoZ14A8Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4N/5ZMnyLkSsfUiINDsvmwUzJE1LYUrSQLRvPQPNkeOTvDI1kTUumktVeq8r/MnOGHtDOe9wOonGwfGcrC+va1pD6fN+fah0MnvwbM0VLXaeGK6H4HExzFejyPIHmM9EQfnbb+/t7vr6vzjgF8eMRQqsO7Y+GjYjLkWG3mMn0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ynetu+Ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ynetu+Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9004C32786;
	Thu, 13 Jun 2024 11:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279643;
	bh=G1sZy2UBbtnU/MsKgSXk1RhK6OOFpOp9eMUoZ14A8Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ynetu+Nihr+TgJh4zGzTnSfEeESOaCEraB3sxnQ89VebzKQ54b5Kxw8BNsLzsz5xE
	 dVZ+9QM44Ii5xRGgieSzJ8Uw16nehn6JTClht+gIJgMYp432xRdQlr32NlBQxxmAYR
	 4RWgbaBSc3gLhhx4oQuHbrRYQ8cKafvNRee6YsIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.9 145/157] btrfs: qgroup: update rescan message levels and error codes
Date: Thu, 13 Jun 2024 13:34:30 +0200
Message-ID: <20240613113233.012394533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

commit 1fa7603d569b9e738e9581937ba8725cd7d39b48 upstream.

On filesystems without enabled quotas there's still a warning message in
the logs when rescan is called. In that case it's not a problem that
should be reported, rescan can be called unconditionally.  Change the
error code to ENOTCONN which is used for 'quotas not enabled' elsewhere.

Remove message (also a warning) when rescan is called during an ongoing
rescan, this brings no useful information and the error code is
sufficient.

Change message levels to debug for now, they can be removed eventually.

CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3826,14 +3826,14 @@ qgroup_rescan_init(struct btrfs_fs_info
 		/* we're resuming qgroup rescan at mount time */
 		if (!(fs_info->qgroup_flags &
 		      BTRFS_QGROUP_STATUS_FLAG_RESCAN)) {
-			btrfs_warn(fs_info,
+			btrfs_debug(fs_info,
 			"qgroup rescan init failed, qgroup rescan is not queued");
 			ret = -EINVAL;
 		} else if (!(fs_info->qgroup_flags &
 			     BTRFS_QGROUP_STATUS_FLAG_ON)) {
-			btrfs_warn(fs_info,
+			btrfs_debug(fs_info,
 			"qgroup rescan init failed, qgroup is not enabled");
-			ret = -EINVAL;
+			ret = -ENOTCONN;
 		}
 
 		if (ret)
@@ -3844,14 +3844,12 @@ qgroup_rescan_init(struct btrfs_fs_info
 
 	if (init_flags) {
 		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
-			btrfs_warn(fs_info,
-				   "qgroup rescan is already in progress");
 			ret = -EINPROGRESS;
 		} else if (!(fs_info->qgroup_flags &
 			     BTRFS_QGROUP_STATUS_FLAG_ON)) {
-			btrfs_warn(fs_info,
+			btrfs_debug(fs_info,
 			"qgroup rescan init failed, qgroup is not enabled");
-			ret = -EINVAL;
+			ret = -ENOTCONN;
 		} else if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_DISABLED) {
 			/* Quota disable is in progress */
 			ret = -EBUSY;


