Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4993314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301229; cv=none; b=rXjY8oVjJNO4+a7gY64hRfx/v8KnuzPhX570GNSqi1JkO7qKjEtxFprdFJKbb0t7EEC4V7yfuKiN4Xwv6slikN8/OJjJ+K98vzpaMNNaxwEJnuHzlqQGhlHXFg+jcpqHKJMx9tHqlJ18ycB0xcyzofCIkq1DUhpLzJAyX/8hj7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301229; c=relaxed/simple;
	bh=8SK6cn4UIAO0V1Yt0CPJedWBxWCigaILwoBEhj6avFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4SZm4FiEXy21od/XwB9q5bOxAxZIB5XozR6S1qSbTKCUlYX+9NXF3Yctsj6UrMGj3JWJRy3oe8tVoCwoBJLDo/cLBis84xWiPUr7X9N+1nwgk8lGQMX06yuntZCr3ot+qkcn6mH1mmIiQv5SAwRP47rKUQdB3+sWE/u9/wDfQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YV3S+h5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YV3S+h5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD76C19423;
	Sat, 28 Feb 2026 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301229;
	bh=8SK6cn4UIAO0V1Yt0CPJedWBxWCigaILwoBEhj6avFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YV3S+h5hUXLIi+Dk4ue8I4remRARecDH7XGsfaES7b75X7MtZCiq6CstPsmJSstER
	 HKQSADuV+7rkRvsYqp/jRanRNVlld22hixrsCp2uqI8Ye1WupRzKADdxcWfhWXgAQV
	 8EL7zoa0EOVNXx38C7vkXtB9R8ljoO4iblrBzLK7JzAtmEY5alyknhyR+r0YC1IArK
	 Z7H8PC8X93gypek7iSL/2a84n50BxbqiOeXgW5011f/20/yQoF0sZ+SANTLlRDLzhn
	 0XGBiKqAhApDw4FmSwY4DUZODUCqh3PjJNeHHZ+VhoMgJjvjIsHg+hKC7fkNZiTG8y
	 vZDRhtyvPqwJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ethan Tidmore <ethantidmore06@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 407/752] proc: Fix pointer error dereference
Date: Sat, 28 Feb 2026 12:41:58 -0500
Message-ID: <20260228174750.1542406-407-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit f6a495484a27150fb85f943e1a7464da88c2a797 ]

The function try_lookup_noperm() can return an error pointer. Add check
for error pointer.

Detected by Smatch:
fs/proc/base.c:2148 proc_fill_cache() error:
'child' dereferencing possible ERR_PTR()

Fixes: 1df98b8bbcca ("proc_fill_cache(): clean up, get rid of pointless find_inode_number() use")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260219221001.1117135-1-ethantidmore06@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6299878e3d97e..a314fd9af17c0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2128,6 +2128,9 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
 	ino_t ino = 1;
 
 	child = try_lookup_noperm(&qname, dir);
+	if (IS_ERR(child))
+		goto end_instantiate;
+
 	if (!child) {
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 		child = d_alloc_parallel(dir, &qname, &wq);
-- 
2.51.0

