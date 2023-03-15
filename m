Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C47A4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6008C433D2;
	Wed, 15 Mar 2023 12:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883303;
	bh=NXxbwTpjuQMERiimQw2G3MZdNPvAfBS+X3dkK9Iyyq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po6RsgAh9qZq+8c6apE3wUR+du8YNGPGdPrw5viV4DvtbyrsbLgqbQLB9nUC4ZuyK
	 IYbidFh6vwW65en2bAkjW9j8vjVtJrYHYYpLyGQITGX8vzPo/ONuPgp1jLV0BKTk4v
	 52A1tDggN8nuUUyjsu3zb9iWNQa9av7qZSsdKxxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/145] watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths
Date: Wed, 15 Mar 2023 13:12:38 +0100
Message-Id: <20230315115742.005167370@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 03e1d60e177eedbd302b77af4ea5e21b5a7ade31 ]

The watch_queue_set_size() allocation error paths return the ret value
set via the prior pipe_resize_ring() call, which will always be zero.

As a result, IOC_WATCH_QUEUE_SET_SIZE callers such as "keyctl watch"
fail to detect kernel wqueue->notes allocation failures and proceed to
KEYCTL_WATCH_KEY, with any notifications subsequently lost.

Fixes: c73be61cede58 ("pipe: Add general notification queue support")
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watch_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 1059ef6c3711a..54cbaa9711398 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -274,6 +274,7 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 	if (ret < 0)
 		goto error;
 
+	ret = -ENOMEM;
 	pages = kcalloc(sizeof(struct page *), nr_pages, GFP_KERNEL);
 	if (!pages)
 		goto error;
-- 
2.39.2



