Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211994FD7A2;
	Tue, 13 Oct 2026 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893614; cv=none; b=Cel0mLviDs51zRzlCdb/MQ9958hw1pmWAj8lcInXnB7cjZMugxWyvgZ+feXLBNBV+ta1Ni99jpPc9ZBmD4/d25aMHBV7OYwnScS++1hK1wH3z04ZNzZDrItn7X/qflmuZf/4Z6CxcnZ6iMMzbcsLxYvRmKukU5Zxo5CNk+dBko0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893614; c=relaxed/simple;
	bh=8Qt+1mxwb9evV0s1P3srQUqbRRBtiPav1F9Sy72Ikjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe743G30B9dMKJEoCMHx+ia3+U1u9thphOF6NUMJA9aPfeIaFLzTuEHwor0dbvRjW7KqoxpEjg8mmH1oYzr/FYKcGMrv20O0AZXXKVGWQwXhFGAb3pgRH6zJq+DBIc7l95TMkT1FGwzv5cqPaFVp/pkLQV8kHFZ4S3nnZRFrmTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/Eipz1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/Eipz1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DC41F000FF;
	Tue, 13 Oct 2026 12:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893613;
	bh=qyj1+zUccCIKGiDcxK/RL2Ai8a/3nMjMKc9rodYe0GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/Eipz1en53+dEjWTPK9lyg+5S04aMXBdFtirgx7KTJzLDuo4tzLyrWBuqqaSCNl1
	 5Ovx7ylJ/OwIlUdQW2iGolZ8r5gEhIeZCuGqClvJBnC62ewMXdnZp/WORK2i7qwjns
	 wtUKEnnDGIe+YUsaDBXC6AxDLdSN+URwgcipP6L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 283/621] iomap: release pages on atomic dio size mismatch
Date: Tue, 13 Oct 2026 13:34:38 +0200
Message-ID: <20261013112927.575563924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fengnan Chang <changfengnan@bytedance.com>

[ Upstream commit 681e452683b69a8e1a571cba0f238f8ceacf55d2 ]

If bio_iov_iter_get_pages() or the bounce helper succeeds but builds a
short bio, the REQ_ATOMIC size check rejects it before submission.  The
old error path only dropped the bio reference, leaving any pages already
attached to the bio unreleased.

Release or unbounce the pages before falling through to out_put_bio on
this error path.

This bug was reported by sashiko:
https://sashiko.dev/#/patchset/20260608073134.95964-1-changfengnan%40bytedance.com

Fixes: 9e0933c21c12 ("fs: iomap: Atomic write support")
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Link: https://patch.msgid.link/20260612044041.10677-1-changfengnan@bytedance.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 92f32e02f77f4..bb276321c9521 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -470,6 +470,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 			 * bio_iov_iter_get_pages() returns an error, above.
 			 */
 			ret = -EINVAL;
+			bio_release_pages(bio, false);
 			bio_put(bio);
 			goto zero_tail;
 		}
-- 
2.53.0



