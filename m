Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8771EBA09;
	Tue, 15 Oct 2024 13:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998147; cv=none; b=du+bwSH1HEyYm3LYVuxQUOiINcCqwzSqshtBzAZvnjqI3Hwk7Mf8f0nroWlBD3IKE0S/wfwd6aj3PZxdcugcd0u+8DGwUZPYH9PheBEkJP2tgAPAUKECx7WotppB4FKKv1a3P95Mtxw2AW7L8JDMrgSS/MXxwwjcmDblUeUcvfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998147; c=relaxed/simple;
	bh=HXKs12MdI56htP1COnOES5Uj5ydMWp8rdjaKcGe0zpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTRj3O34Heq/AdaKiykBOx/Do1fDsl36RsGnyrtEBI6KJ6hcGrgkxf/+qoy8n1KMhdO+scjsXwEPFj+43LT21n2GXKA30lsv0irbrEynWfiWEYhcXPLNkBhK0YJBNX9G7rY0+4wIEnax1HKP0IbxMXbvKxBgPNP5RnnchAulquE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1pIVH7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1pIVH7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5255C4CECE;
	Tue, 15 Oct 2024 13:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998147;
	bh=HXKs12MdI56htP1COnOES5Uj5ydMWp8rdjaKcGe0zpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1pIVH7+e8ZnDZnyfQS9GTCzwCyJE9NcQ1sOY22JTCb/607t4UXTu7mno2tw3uEE/
	 Bz8mtbwJKoZq5QdmuOpXTXQZ/Uu2AZx9rVpVd9VxuGbA1Au8+IRd6/p1oj0yzuz3dK
	 rPLf0cLWyAqR+lg6zkkMW6I4vX8/kkcS1yJMGXiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 392/518] ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
Date: Tue, 15 Oct 2024 14:44:56 +0200
Message-ID: <20241015123932.104390451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

commit 33b525cef4cff49e216e4133cc48452e11c0391e upstream.

When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
bh is NULL.

Link: https://lkml.kernel.org/r/20240902023636.1843422-3-joseph.qi@linux.alibaba.com
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/buffer_head_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -390,7 +390,8 @@ read_failure:
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
 		 * completed. */
-		ocfs2_set_buffer_uptodate(ci, bh);
+		if (bh)
+			ocfs2_set_buffer_uptodate(ci, bh);
 	}
 	ocfs2_metadata_cache_io_unlock(ci);
 


