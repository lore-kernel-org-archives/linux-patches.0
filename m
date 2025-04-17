Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46236258CC2;
	Thu, 17 Apr 2025 18:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915858; cv=none; b=ZV4IVzf+5dSNracWAoR9eXLzhwlAYfO+D8FYVVz4H3mBjrpeDO7IB2kStM7olmqFjzg1OMnG6OQFRxb5/TVQsou2ZzmgdbVaNvu/5jY3Yikl20UlesdShe4HgwpAQs8Lvmsji+36orCu3yTXdECxmUBZcg7ouX+pbl8u4eftmEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915858; c=relaxed/simple;
	bh=mT1A4+fCA15O2MUkqD2cSm1MQuwbS5SAkkjUKjRsjAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3nOMffwgV6NZ30HW7etLslL0LrLHsIGxvOtNiQgWvpxaXj/HWoDx7Rhe3pcIlxi56mPHBFPNGCgeXOocYrBSJ8RcTf3OQ6zTjhUpHxbBtCMAfXA4Gxa/DbTXDMfMYRS6dA+GnF58wgR/XtU9mcCT1//QAj1pkLGgWh+x0jazj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yg1uAFPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yg1uAFPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94BAC4CEE4;
	Thu, 17 Apr 2025 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915858;
	bh=mT1A4+fCA15O2MUkqD2cSm1MQuwbS5SAkkjUKjRsjAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yg1uAFPSlX7HMiZ+b5kXZwwZ+T43wGSWfllvfvJBrrOm5LyDHm6b+SPJNUZAluc/0
	 aYzH9JFQaVH+cy4cOYr+z3IK7rlTBW9FZWGaxpGj7JhdUVjk0DdOIzgN/pfmKoYca6
	 AWoSVnwNLzFN6nU/lOm0HmwR0ma4a4DRVaXB6cYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 263/393] udf: Fix inode_getblk() return value
Date: Thu, 17 Apr 2025 19:51:12 +0200
Message-ID: <20250417175118.182865300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 6afdc60ec30b0a9390d11b7cebed79c857ce82aa upstream.

Smatch noticed that inode_getblk() can return 1 on successful mapping of
a block instead of expected 0 after commit b405c1e58b73 ("udf: refactor
udf_next_aext() to handle error"). This could confuse some of the
callers and lead to strange failures (although the one reported by
Smatch in udf_mkdir() is impossible to trigger in practice). Fix the
return value of inode_getblk().

Link: https://lore.kernel.org/all/cb514af7-bbe0-435b-934f-dd1d7a16d2cd@stanley.mountain
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Fixes: b405c1e58b73 ("udf: refactor udf_next_aext() to handle error")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -810,6 +810,7 @@ static int inode_getblk(struct inode *in
 		}
 		map->oflags = UDF_BLK_MAPPED;
 		map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc, offset);
+		ret = 0;
 		goto out_free;
 	}
 


