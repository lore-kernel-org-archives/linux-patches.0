Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41D61DE8B4;
	Wed,  6 Nov 2024 12:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895397; cv=none; b=fByNXk29XmoTxiaAzT/bkh1ISPJdd4VPaHkGOSzX/856gjRtAX3HdP86fsPP+LC38lKWRpOClntozYkG9KYglfTw+Fs28UvmHNUeVWCaXwE4VJabDrQLxX6giI4zLAFNY2hWHeB3poBMDJl61rEyVJxgL4Lm0lX3nl7hU7Yt158=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895397; c=relaxed/simple;
	bh=tKUNg8hjOcXR4UAQEw9XLMQBWi/cF/GqjHB7VgAq+AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9NhTgIoySrZTb1vwm36EOvKsLRsKlc8VIX5PtujOOEK3d+QhZapbP6X/dPX10nZVXj0+6GDISuHixplVTHB/8xBA8294OUlSMQLFwafACjpTJDwJDW7OOecwxuHn7A3X3cecb9pD9+g6RP5VBsPbLuI+HCb5Sh+OedtS03SkQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0ot1Rt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0ot1Rt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A940C4CECD;
	Wed,  6 Nov 2024 12:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895397;
	bh=tKUNg8hjOcXR4UAQEw9XLMQBWi/cF/GqjHB7VgAq+AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0ot1Rt5lCKylVFW9PHBhoQ51hJHCbrtvT7jpnzhHT2JX/crZ6BHYhGpXmbTgw93A
	 RxQHWKZ/6F97YBhdjMiSRJysh2GDYtFsahhfBgI7x3UpBWJ2jvSWf0Pm3kbyDe2YA2
	 ooMUSrF7ZziAAowdVkIVyaT3rs/i1yqiSz3GjOEQ=
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
Subject: [PATCH 4.19 203/350] ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
Date: Wed,  6 Nov 2024 13:02:11 +0100
Message-ID: <20241106120325.994240166@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -404,7 +404,8 @@ read_failure:
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
 		 * completed. */
-		ocfs2_set_buffer_uptodate(ci, bh);
+		if (bh)
+			ocfs2_set_buffer_uptodate(ci, bh);
 	}
 	ocfs2_metadata_cache_io_unlock(ci);
 


