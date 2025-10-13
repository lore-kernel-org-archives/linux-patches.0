Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C705D2A1BA;
	Mon, 13 Oct 2025 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368764; cv=none; b=WfBJWUaJ06ZD2HWrvuL3Uaihv/plIAh2UpOldpQ0JRShXZ0MYxbsBpXzkew/cGHN9eR8j/6a3a3sn15+cY59OBGPiljaBkXk6ZcjfO5/Z/h5I78ERAZ8KngTEFuJoi3vJlBH7gZjP0Jj/hTLxNlmO7DdIZ96C4EGsqu7CmE1eGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368764; c=relaxed/simple;
	bh=JZIBN726jPzXlV0o/y3JGxCLEWpE3ZojN0gnu/+Oyqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLMb8DZ+axfvlJK830k0RhHLn8ws4bwFQiNlW8SyV0SY09cjdZADtPkTLFJLg9paNkR4ln4W+qMR78fXsm4Gk1KbGt08l6c4P33nS5aysU4LXlWRmhME01wVuZoudh7c+VQx4oQzRXd6qUcnVvkXMba59F7dVNX10ECYWopw3aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNJccMHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNJccMHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51424C116C6;
	Mon, 13 Oct 2025 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368764;
	bh=JZIBN726jPzXlV0o/y3JGxCLEWpE3ZojN0gnu/+Oyqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNJccMHohq3V/Yw2c8hRBLyv1A1dukB+LG83+8wiQlGEj/UJONGwcFUTeVg1OzMqa
	 AWckP7kj8GgGlYO8pkcTEgfqz2wK7Bajxua6CuOl5hZIBJzFlEVxH7sVtxPAide4c9
	 b9/afzlOiKX3IVKZYzb8AFouIBULIwiwJ19SimQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 012/563] gfs2: Fix GLF_INVALIDATE_IN_PROGRESS flag clearing in do_xmote
Date: Mon, 13 Oct 2025 16:37:53 +0200
Message-ID: <20251013144411.736821487@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 061df28b82af6b22fb5fa529a8f2ef00474ee004 ]

Commit 865cc3e9cc0b ("gfs2: fix a deadlock on withdraw-during-mount")
added a statement to do_xmote() to clear the GLF_INVALIDATE_IN_PROGRESS
flag a second time after it has already been cleared.  Fix that.

Fixes: 865cc3e9cc0b ("gfs2: fix a deadlock on withdraw-during-mount")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index b6fd1cb17de7b..edb105f9da059 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -805,8 +805,6 @@ __acquires(&gl->gl_lockref.lock)
 			clear_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 			gfs2_glock_queue_work(gl, GL_GLOCK_DFT_HOLD);
 			return;
-		} else {
-			clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
 		}
 	}
 
-- 
2.51.0



