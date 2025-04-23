Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DEA26A08C;
	Wed, 23 Apr 2025 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422225; cv=none; b=WkLhwdpkUAix8OdmfHdIqZEGC3HcWtx2ZazzgjNrTBfNS9WVRVK7EkIs2zG9tfIwH+gGcUr/yjf23cmLcJBAoMW29bsHOqLbJkL4UPt2nR1vtvOTu/RnW7FjH8BT6tgHxD8wEQ9MjQg7oD/7vqA/BHR3TgGUwbD60nWcgvNdOT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422225; c=relaxed/simple;
	bh=yJV96ou52T7t2FdpsOBOocReJkF7ZvLRfa6mDwRQP4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOb5tV7qARUmpJ/L7iMR07JC+ZK/TlYPd35hltCTO5pkdqwh22Joi6hfNcHU3KlZV1JgunshueW6tTcWwrFALcMoNdOw03MoiXwdVcznv85NGSyry28YEuPKpzj5ORFbH/R9UIHP0V4bg8ioQ4EJzuVJSjdbYbGZRjAiOpMJyxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hp+/leKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hp+/leKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D29C4CEE2;
	Wed, 23 Apr 2025 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422225;
	bh=yJV96ou52T7t2FdpsOBOocReJkF7ZvLRfa6mDwRQP4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hp+/leKtmRCDIb1HJHpvYwpiLDaOI5fCHp/NG3k6t8L5crKn6pSw9NfMoajvSswct
	 AEyLM+FKGttxZ/A3eowQGlePjiB9sKLszv08129uZjcxIRFGjj6h8ZAcO2nnutdjve
	 Asxdrjl5KGiclpOmKFsoAG6vgFuUwdfP3ynmcVfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 300/393] writeback: fix false warning in inode_to_wb()
Date: Wed, 23 Apr 2025 16:43:16 +0200
Message-ID: <20250423142655.728663935@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -250,6 +250,7 @@ static inline struct bdi_writeback *inod
 {
 #ifdef CONFIG_LOCKDEP
 	WARN_ON_ONCE(debug_locks &&
+		     (inode->i_sb->s_iflags & SB_I_CGROUPWB) &&
 		     (!lockdep_is_held(&inode->i_lock) &&
 		      !lockdep_is_held(&inode->i_mapping->i_pages.xa_lock) &&
 		      !lockdep_is_held(&inode->i_wb->list_lock)));


