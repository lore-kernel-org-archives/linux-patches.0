Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F2B283686;
	Wed, 23 Apr 2025 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420551; cv=none; b=KjgnfkzGZJXj1tnwkTrjctgZeWeeM/Epb6IU626AV4DNN52WaDdkrSWeOoqydxIADQbaiNEjImEsuQT/qEDxJ9CE0kNhEZ2a5eE/4lmRM2ZGrvkf9IWX1bXIfBPz7yQ9I2VXaefmrScMEZWZ2ZUqdze6DrCUZnI2/nsbxpEsnYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420551; c=relaxed/simple;
	bh=O9M2672Txs6vOhk9gBfcm1a6rQjmgsXd6BBQDRAT6+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAh+rHjFxEfmux/s6hlo4IIjMhqU1pZyOceMc6v+N1phH2Lw7+zZDUKWnqGyTE4YzBSWw9B77ftYRW4riPZXcLhPx1EBjWL7Zgx5v6IOAiLEdIMonOu0bXI0QKQPVyHHJSZmhqO9iB3D0jKE5cOLLXJ3hDfrsjIizakhOGULT7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFKu3xKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFKu3xKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694AFC4CEE8;
	Wed, 23 Apr 2025 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420550;
	bh=O9M2672Txs6vOhk9gBfcm1a6rQjmgsXd6BBQDRAT6+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFKu3xKRExgtaGuxi4nDj0LLXrtI+6v0/VcjWEVSAVIMYv8OpJgl9sCDqxA3PeVSs
	 Swb1AFdTucQxnMVIlMwwfspE+xsZK1RJ5fDxxhPLyXEWu25+YyOSJm8WwQKc1Vdf5E
	 cn5+HXJd1TYUvAW7WktwjkGO88h+fZsWh8wjxpKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 102/241] writeback: fix false warning in inode_to_wb()
Date: Wed, 23 Apr 2025 16:42:46 +0200
Message-ID: <20250423142624.740592403@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 9e888998ea4d22257b07ce911576509486fa0667 upstream.

inode_to_wb() is used also for filesystems that don't support cgroup
writeback.  For these filesystems inode->i_wb is stable during the
lifetime of the inode (it points to bdi->wb) and there's no need to hold
locks protecting the inode->i_wb dereference.  Improve the warning in
inode_to_wb() to not trigger for these filesystems.

Link: https://lkml.kernel.org/r/20250412163914.3773459-3-agruenba@redhat.com
Fixes: aaa2cacf8184 ("writeback: add lockdep annotation to inode_to_wb()")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/backing-dev.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -249,6 +249,7 @@ static inline struct bdi_writeback *inod
 {
 #ifdef CONFIG_LOCKDEP
 	WARN_ON_ONCE(debug_locks &&
+		     (inode->i_sb->s_iflags & SB_I_CGROUPWB) &&
 		     (!lockdep_is_held(&inode->i_lock) &&
 		      !lockdep_is_held(&inode->i_mapping->i_pages.xa_lock) &&
 		      !lockdep_is_held(&inode->i_wb->list_lock)));


