Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B79F9D4;
	Tue, 14 May 2024 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687988; cv=none; b=hGpV7LNavWFKwP3DMCwms26rq9JAY2MD46ukIrx5d4wwEp5Ln0/hznUS/o0P3hu5sfx/liVZQsE3/JcGXSyu5CYYzSTXJe40eA5dGIwQN7Y09V8QFDNcfinDbsRyHsYvIxCmgYW7Y0FfHubGdcq9flLlGyxb7fpYfVRfpVZvdGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687988; c=relaxed/simple;
	bh=tkrRzYzQd3Ql2P95dYHzhssonUR1wIY2UahfcRQsHNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBlNSeQQ98KdFPa0gPw2oswcdzQjxOrDNfuFZ1cNSLWomM01izRJK85Lr3HFCbjxNW0k873g58/C39vwB4AKsJOR2BLjCNG+ZOLMALr0gxXmDr1hOGw1zM+aZ60utHFD3quP89K57o3fXugoXlGDPmNYlcRvXxebo+Eptb9Bwi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iIp5y6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iIp5y6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2173C2BD10;
	Tue, 14 May 2024 11:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687988;
	bh=tkrRzYzQd3Ql2P95dYHzhssonUR1wIY2UahfcRQsHNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iIp5y6ZHhdZ/7ast+pS6GshkCXt3a6enqO0JzCWZscochIY070jyN+gXH4ar3AHK
	 njo5TjHKFKPHffahufT9FUh9hlysvOWEWjbRn0LFlIWdHi+tgiXkpdM5CjCdCHoYjq
	 lLqAINK2rXPI9KvuRerYzydojKNwOffnKA3rswU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 150/168] btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()
Date: Tue, 14 May 2024 12:20:48 +0200
Message-ID: <20240514101012.423821437@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 9af503d91298c3f2945e73703f0e00995be08c30 upstream.

The previous patch that replaced BUG_ON by error handling forgot to
unlock the mutex in the error path.

Link: https://lore.kernel.org/all/Zh%2fHpAGFqa7YAFuM@duo.ucw.cz
Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 7411055db5ce ("btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()")
CC: stable@vger.kernel.org
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3374,6 +3374,7 @@ again:
 			 * alignment and size).
 			 */
 			ret = -EUCLEAN;
+			mutex_unlock(&fs_info->reclaim_bgs_lock);
 			goto error;
 		}
 


