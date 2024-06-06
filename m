Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD34619DF69;
	Thu,  6 Jun 2024 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683496; cv=none; b=dSVSwqkmUzlCS3zuCZfPgsc/KLdBMB0KjzfK52y0p5QyKYsPK0VV9VrtIvS7cBZ+a5ZKRmUU2s8WkmCikdOunXd/lbhVOFFA0pg73DQAsiFVRfRB3N7v4dO0UKm0MudFe79JMSSAg3QQ/bQvuSDiZx6wAJ0JeR8CUMeZealvU0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683496; c=relaxed/simple;
	bh=E0MQZEi3m0BrJlAkg8PpK0p2VdjUmd8CqBccF1GYeGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0yi30qFgE1vs0Xa1aF13opqm62dyVIX78xogCHrxg76wrPMNchCqe9hF9nJZQlOHDrNHMTu3v2W8q6P+6gWo82V97Wr9OJXDiYELGCEgXgcBByeRP9p9O7Dws1Qxq+fcAzqWFiDSDVnUsiK+46o88bJQPjIAb/r5McvZVq7d40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azz6Z3BM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azz6Z3BM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D90EC2BD10;
	Thu,  6 Jun 2024 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683496;
	bh=E0MQZEi3m0BrJlAkg8PpK0p2VdjUmd8CqBccF1GYeGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azz6Z3BMmrdvuOeqKu04Gs0/CPCW6a5VkdAP34M7GD/fVPgXclPVYyQKEU9u1L4XX
	 IbvQJjQBBC44BUuXUTgZvf85cDwymLNOiKIT3dVe2W6yKKxSsWt40bISkMMdal0O4C
	 GaLU8zNc5oVkzf1FpkCCGBVTjukiW/aQWTLThj7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 439/744] splice: remove permission hook from iter_file_splice_write()
Date: Thu,  6 Jun 2024 16:01:51 +0200
Message-ID: <20240606131746.563882173@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit d53471ba6f7ae97a4e223539029528108b705af1 ]

All the callers of ->splice_write(), (e.g. do_splice_direct() and
do_splice()) already check rw_verify_area() for the entire range
and perform all the other checks that are in vfs_write_iter().

Instead of creating another tiny helper for special caller, just
open-code it.

This is needed for fanotify "pre content" events.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20231122122715.2561213-6-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7c98f7cb8fda ("remove call_{read,write}_iter() functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index d983d375ff113..a8f97c5e8cf0e 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -673,10 +673,13 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		.u.file = out,
 	};
 	int nbufs = pipe->max_usage;
-	struct bio_vec *array = kcalloc(nbufs, sizeof(struct bio_vec),
-					GFP_KERNEL);
+	struct bio_vec *array;
 	ssize_t ret;
 
+	if (!out->f_op->write_iter)
+		return -EINVAL;
+
+	array = kcalloc(nbufs, sizeof(struct bio_vec), GFP_KERNEL);
 	if (unlikely(!array))
 		return -ENOMEM;
 
@@ -684,6 +687,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 	splice_from_pipe_begin(&sd);
 	while (sd.total_len) {
+		struct kiocb kiocb;
 		struct iov_iter from;
 		unsigned int head, tail, mask;
 		size_t left;
@@ -733,7 +737,10 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		}
 
 		iov_iter_bvec(&from, ITER_SOURCE, array, n, sd.total_len - left);
-		ret = vfs_iter_write(out, &from, &sd.pos, 0);
+		init_sync_kiocb(&kiocb, out);
+		kiocb.ki_pos = sd.pos;
+		ret = call_write_iter(out, &kiocb, &from);
+		sd.pos = kiocb.ki_pos;
 		if (ret <= 0)
 			break;
 
-- 
2.43.0



