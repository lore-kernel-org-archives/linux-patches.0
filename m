Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228D02512DD;
	Tue, 29 Apr 2025 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946948; cv=none; b=k8jyrJV/9LOhAzYa7reqCQtPr6xhKMQeBkFyzTWL9LckJmStCqbsUwgGCaDxo3WtxnL6nDRQdClQ6DbwUR9LW/0u4JA1ijRCqa52T2moSn9NEc8IFT865mNJ5dA7YG0nXNJlhLal24S/UaccitLYvLIaStOMWF6WxkxbvOZKUpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946948; c=relaxed/simple;
	bh=T4xewdkv7K4U32NalGeV3DYpL0AmvdgZmz1MHrktlAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRMkoqozqVOUHbTpaG6qo2uSdI+ap8aHyzWVwYgMYVT0AIEBErXaHB3urmKb4Ri3O0VBFfNkU0FP8At1KsmHPP9ePck/KcRcMfSLbqi2F6J1H6f8bu6jWh2G6uQlFOOJFEEps0XBCcVlppGo1hX95qshUIFFA4uHDe8ZKohTKQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qsvh4wMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qsvh4wMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0021C4CEE3;
	Tue, 29 Apr 2025 17:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946948;
	bh=T4xewdkv7K4U32NalGeV3DYpL0AmvdgZmz1MHrktlAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qsvh4wMGablSwFG/hsUwRDb5Ieet/jY3vKGu3tKWnGAmoW2nudlNDhmLpw9Yx7v3c
	 c4Kina/RkYNP86ti/Bj5Y1RKmveDCfv2+BfCrcPWdwz7w8iICTX9QY5G1SF5JJ6XR2
	 f0mqClQLE4BPq+g/R60z4a3OuNdV/qsayN1+yRys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 121/286] writeback: fix false warning in inode_to_wb()
Date: Tue, 29 Apr 2025 18:40:25 +0200
Message-ID: <20250429161112.833971754@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -281,6 +281,7 @@ static inline struct bdi_writeback *inod
 {
 #ifdef CONFIG_LOCKDEP
 	WARN_ON_ONCE(debug_locks &&
+		     (inode->i_sb->s_iflags & SB_I_CGROUPWB) &&
 		     (!lockdep_is_held(&inode->i_lock) &&
 		      !lockdep_is_held(&inode->i_mapping->i_pages.xa_lock) &&
 		      !lockdep_is_held(&inode->i_wb->list_lock)));


