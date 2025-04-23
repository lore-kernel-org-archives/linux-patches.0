Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B5F284B4B;
	Wed, 23 Apr 2025 15:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421262; cv=none; b=DyMhCuQh5Fo3BogfEtkK7ZFVs9W0ZC10JmOXhwZdf67AP6W9t/jR5QPeL/w16VAbu6BluYxNAMnRxHyo/zAlTXewuoJUWF9cd2dIcvLP069EGc3i/9iHtJAMCq+pBQUczO7o7RqNL8MBkU7dys9BQyuMrE88SjGgpxD87vgHpl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421262; c=relaxed/simple;
	bh=8GvKXlMUgk7BpS8XnY/npCuURP2p4PwwuxyIleBAYh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMOnuBSSNAxVvKHIjzjCOuSyu9gyrd0MsWGvHd9sVhTlo93RKqbkK0z4seU3ADuCSLgyGFbjUwBoOnLjCC2xEomAdkhqxCGwsDHYFegDXrIKr9Hb/P6oQ4Ef5HclWtYFJ/OGKsbWpGoy+ZgSuZRn4+O0hZzGDLwJJ56bj3mJKxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WwYeGu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WwYeGu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F27C4CEE2;
	Wed, 23 Apr 2025 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421262;
	bh=8GvKXlMUgk7BpS8XnY/npCuURP2p4PwwuxyIleBAYh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WwYeGu6SQv4LAyQ2Z4FIA8vDFauWRBWiP/Dl2Ug/gQZGaRYfZk+2p5EMD044SiCs
	 Yp7sLdcy4r5/zJt1eKGjulHqFLXlNiJAhshfAqewwa3LBgKHzrLJpLw28HziqQ2fsP
	 3YYNWU7oPXjYawWLt6F1h1BQ0BmyjMwnyhNQsGi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 163/393] udf: Fix inode_getblk() return value
Date: Wed, 23 Apr 2025 16:40:59 +0200
Message-ID: <20250423142650.106335384@linuxfoundation.org>
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
@@ -814,6 +814,7 @@ static int inode_getblk(struct inode *in
 		}
 		map->oflags = UDF_BLK_MAPPED;
 		map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc, offset);
+		ret = 0;
 		goto out_free;
 	}
 


