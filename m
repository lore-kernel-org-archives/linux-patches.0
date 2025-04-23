Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818DC28CF6E;
	Wed, 23 Apr 2025 15:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421918; cv=none; b=DYTGkYDgOmMTxtq8itXcbR0PcWvUGEC/BOzrWbCTtZpS2RUyBqK9p/wZXKykDlFxwWnrho3CyCz2qc0vcECAUPbo9WHAel/1//3nn7S/qxRHupCcQrOjskhQArsME5gdJso2KMSEWi95lRzDE792cM2hzucdYNJvty0uO+46We8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421918; c=relaxed/simple;
	bh=weZPZHcBcoIA11xlt2PlavBE+r2uUtltuYipPSF6WIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDq6N91tdM5sWMQhpA3qzESuSzUnnG42omIJPgauZAj4Wsb4dCotgBrklRm3Ki2gVvAgaTRwpJ7hpK3W9PJPeT6LpQPdEDoK6gfasbx/zpiKH5mBSS0C6kFaeCj/zyeRFVbcYbh6vU1a4jgHtNimgj71zLWUQ3LnNk00RQMvwSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqQ6k3rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqQ6k3rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACC8C4CEE2;
	Wed, 23 Apr 2025 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421916;
	bh=weZPZHcBcoIA11xlt2PlavBE+r2uUtltuYipPSF6WIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqQ6k3rkAAuCAmDcoWg++uhLQztTQfXEtfgtAw/O7QqzG4kSNjE3tj8VRaRCtkF4f
	 a5DCMSfqliPa5y3WI8BGucRbIrUBqsfHfpUtUCGR7WMDED1cieYF/DTjXKaNa1/NDP
	 4fU08B37xslT59ibEsKfhK678XCwNsOtLhmhz/I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 198/291] writeback: fix false warning in inode_to_wb()
Date: Wed, 23 Apr 2025 16:43:07 +0200
Message-ID: <20250423142632.472445505@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -241,6 +241,7 @@ static inline struct bdi_writeback *inod
 {
 #ifdef CONFIG_LOCKDEP
 	WARN_ON_ONCE(debug_locks &&
+		     (inode->i_sb->s_iflags & SB_I_CGROUPWB) &&
 		     (!lockdep_is_held(&inode->i_lock) &&
 		      !lockdep_is_held(&inode->i_mapping->i_pages.xa_lock) &&
 		      !lockdep_is_held(&inode->i_wb->list_lock)));


