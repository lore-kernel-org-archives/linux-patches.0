Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D484428506C;
	Tue, 17 Jun 2025 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176670; cv=none; b=CKLIrrsyXLcx/wwN9oW0iAi0SnmfZFqo9awF2yaTAEM5/U+oLvsDCDZHdRakW9n6FOXgoqnz1WvqEuh+yP08GoPr3Pon8CB2eNMNTm4cfVngVqP/GMpqsVVI7pifzVoCsYMacjjm3IRJqNe6OyvH1b+qzs8RzvxMU3tBFh6bpgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176670; c=relaxed/simple;
	bh=PxuLXIfvoOq73Xagp6jiy64umoqU9SlFtUEfgaEA56Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtxIzZjK0XA34ALYCzvOvGVUAzCdjhojT++FsTu5Z4LnK8y33aYmy3+ewRuOvH0MROuthypfkN3+EX24uyGb9EW8iQ1NXQyrsqyQ9YRZXZEHtht/+C8LelBgoEI3Ryjz6oi0L470LJI2p+6Z87Dfr6XvI1q9ULK1HEeXwNKw1v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pX3gqwXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pX3gqwXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349F3C4CEE3;
	Tue, 17 Jun 2025 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176670;
	bh=PxuLXIfvoOq73Xagp6jiy64umoqU9SlFtUEfgaEA56Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pX3gqwXvSvhddLCrYfWA+UxIf1wMmTUec1BJxVbH/9Adk9M6NV2m8E0riLMo6ogq7
	 Ih+6P4lajecnd58vn6dS85SsTARTjyoIz27wy+HVouWOaf+Cf31xIXLl05Bh+BehC/
	 O04Hvsx+p0fm/G/HuT7qGztKSirw0038FGLaKfAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Jan Kara <jack@suse.cz>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/512] ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery
Date: Tue, 17 Jun 2025 17:23:38 +0200
Message-ID: <20250617152429.814779214@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit cdc3ed3035d0fe934aa1d9b78ce256752fd3bb7d ]

If ocfs2_finish_quota_recovery() exits due to an error before passing all
rc_list elements to ocfs2_recover_local_quota_file() then it can lead to a
memory leak as rc_list may still contain elements that have to be freed.

Release all memory allocated by ocfs2_add_recovery_chunk() using
ocfs2_free_quota_recovery() instead of kfree().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Link: https://lkml.kernel.org/r/20250402065628.706359-2-m.masimov@mt-integration.ru
Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index e272429da3db3..de7f12858729a 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -674,7 +674,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			break;
 	}
 out:
-	kfree(rec);
+	ocfs2_free_quota_recovery(rec);
 	return status;
 }
 
-- 
2.39.5



