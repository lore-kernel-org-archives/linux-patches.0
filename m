Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CDA3D1CCA;
	Tue, 21 Jul 2026 17:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653714; cv=none; b=nxNCsIX6GPejkknOnQp9R6OUDDbXnpFjIyiWhFsFAQSbs8M8dF3u3s8PmsFwr+TPnxEklxq3W30SpsVQQebT6bqcLpQ4+5g2oj4WrvKEK82M8qRYvO6bBkiYBJGBOxJxgmuXj+H/gquN6Mm9qgF9jnKjUdHlPOe+PvI4djWHPbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653714; c=relaxed/simple;
	bh=kY+zNbGPO3tHaPsyvjy2WUYHMIiZnOEzct7fm0Fusvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r634uj797Ph6PNDE7VuQaT/lspuG3up5ibefjTqQKWMEO5SjpfHxRxPFusmDiQY+Oc1Gg+rKjqnpL576tqVXfcgkTobB2xEx773hqXOViDC2oM91OutTSxgur3G79bYq3DWGPsNPFyoS21bMpuhfmcWSOXC80DtoLtzhfxv1uKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQUwu8Xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQUwu8Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6621F00A3A;
	Tue, 21 Jul 2026 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653713;
	bh=TBvXiANtybHFZdijn0SGOrgMraA6rjxFYNII3AbPXus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQUwu8XuETFsQu+tUitqtUoRtNe0+P3NhZe8rp3Zkbmoum+tuSkhdiakBTacunG5d
	 UoVS7ktMxfAgePYjvpD2+eIdDlIA6raqwRpNCfakix+zj1KVCpcWIBogUhAO1zR6QN
	 p1nuTq85sojIGdkYbH3yxXayBmUVUwZo4kavLzmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1388/2077] iomap: release pages on atomic dio size mismatch
Date: Tue, 21 Jul 2026 17:17:41 +0200
Message-ID: <20260721152625.553493707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/iomap/direct-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b36ee619cdcdda..9fedf367c3ebe6 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -369,7 +369,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	 */
 	if ((op & REQ_ATOMIC) && WARN_ON_ONCE(ret != iomap_length(iter))) {
 		ret = -EINVAL;
-		goto out_put_bio;
+		goto out_bio_release_pages;
 	}
 
 	if (iter->iomap.flags & IOMAP_F_INTEGRITY) {
@@ -393,6 +393,11 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	iomap_dio_submit_bio(iter, dio, bio, pos);
 	return ret;
 
+out_bio_release_pages:
+	if (dio->flags & IOMAP_DIO_BOUNCE)
+		bio_iov_iter_unbounce(bio, true, false);
+	else
+		bio_release_pages(bio, false);
 out_put_bio:
 	bio_put(bio);
 	return ret;
-- 
2.53.0



