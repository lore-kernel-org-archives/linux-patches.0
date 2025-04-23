Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF32269826;
	Wed, 23 Apr 2025 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420000; cv=none; b=WcAkwUXT+yJ1af1LMgyFJyJdDD8Z1BaEbN3fkuxSLU3WdyUEf1FlmtQW14myZRTDm/ceW5YinGCxbaZHRf9d56tfP4k/KBkApl/3gxGJbB6HIUW07uoxqzh0cx8GLhiy9RBMf28nJQP9OdoVS3XsYIp3RkS4yrzcu/ZCc98kohM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420000; c=relaxed/simple;
	bh=3CpTZWLtT2RMXozdcOGaMzlPbkNQcredwoNl+0zf3Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dzov8JqvIfsx5ZvKlEXYtS+1P2xPUA3WnSrpHsAdKueyobqWBtZVOWSihg+8RCfpsJQuIRpMG2NhSTCu5p/ZvKkcwvnvXZ46p+FivoXc2qhg1XGGFtwspe9rTmR1pxfMTL6FAdHaCUQ++aZCUVVtU50JO/gIz8MnJygZd7nIejA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5Jof5TR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5Jof5TR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C2CC4CEE2;
	Wed, 23 Apr 2025 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420000;
	bh=3CpTZWLtT2RMXozdcOGaMzlPbkNQcredwoNl+0zf3Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5Jof5TRKRrKgsZfabc+Uys/MRcKOAlIPfd2dS06QqZDgx9gvDT6bo85DDkX0Ia1K
	 WbVjoSZfxxxjvtuzLpBngTBX7jGg0dNJPycYdfY+y5sM3oMj4gs9FQ6NTla4+LAcJ/
	 otOt01SBE6llOGEMDpTSwvZbTnYOnP5MQ3Ik7Hcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 087/223] writeback: fix false warning in inode_to_wb()
Date: Wed, 23 Apr 2025 16:42:39 +0200
Message-ID: <20250423142620.667197376@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


