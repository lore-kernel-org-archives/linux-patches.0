Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D0C1FBEB0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301937; cv=none; b=cgqyHuw8wFcl8RbHt7M7jo9whBOzJgx8MpZIk/65Bid6praGRIDp06WN3BsnfxjSg/Z6cFZ7YjT8+gZnjTAkbAxap2UK2R8hexURFLD8Wrp2LYHqo3ox0PBGu5M8iu2jfmcn+EeNK25gKw6oy82CTFilv60FWBg3fRWLUjmaX2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301937; c=relaxed/simple;
	bh=cIvM9cZQaVaOB3m0J80SmQTu4cZVnB3I0GrT4F4cUmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ0DYzc+Y3Rw+4BMR9Pd34BwIOkxu4K17jc9ZAIG82pkz60Scu6YAGrbmzvus1RbZU4A92ofJfVoFZCEHO6ZmOXzAGQk8ZbdD3LvbUZpJKcARVJB0UQ2IwT3vINxKV/aXI05bNVOHdGkfAPgiEUfKTu1oyqELAfzf2rWFWoicAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npYa3Nj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npYa3Nj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87750C116D0;
	Sat, 28 Feb 2026 18:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301937;
	bh=cIvM9cZQaVaOB3m0J80SmQTu4cZVnB3I0GrT4F4cUmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npYa3Nj3vy92Wy88L+ONQGIKSwjOMAYKVSlB6DslM1zx1SYMRnGfxztlVfJ2Gqi1N
	 bEZSgvpSGYI0ZCXHBC5t6MCu6VQri4woj4FFNWS7HyuBK4gr6vS0D7tAD2Q4f8oO03
	 f3wrqio0Z23DIDF2Z/PHR4E4KfWmQZImkytvHnILueJKb97o2sZ56AsM4R1hn13jbp
	 bZiyB+RCSAUroXgvMxPo1MCEHU4Ptpjs4Z+7Ur0TPJvB+itV8c64xRlgsjD1y5gQaf
	 NSG9zuEXuZtmcaxB2LV8t1TEXlWRAeQBtqI8a1WEBfUXgX9N34Q8tYWpkd4jkRoqYt
	 f5ZtLBPhRowrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Juergen Gross <jgross@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 373/385] xen-netback: reject zero-queue configuration from guest
Date: Sat, 28 Feb 2026 12:59:55 -0500
Message-ID: <20260228180011.1568201-373-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 6d1dc8014334c7fb25719999bca84d811e60a559 ]

A malicious or buggy Xen guest can write "0" to the xenbus key
"multi-queue-num-queues". The connect() function in the backend only
validates the upper bound (requested_num_queues > xenvif_max_queues)
but not zero, allowing requested_num_queues=0 to reach
vzalloc(array_size(0, sizeof(struct xenvif_queue))), which triggers
WARN_ON_ONCE(!size) in __vmalloc_node_range().

On systems with panic_on_warn=1, this allows a guest-to-host denial
of service.

The Xen network interface specification requires
the queue count to be "greater than zero".

Add a zero check to match the validation already present
in xen-blkback, which has included this
guard since its multi-queue support was added.

Fixes: 8d3d53b3e433 ("xen-netback: Add support for multiple queues")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260212224040.86674-1-n7l8m4@u.northwestern.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index a78a25b872409..61b547aab286a 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -735,10 +735,11 @@ static void connect(struct backend_info *be)
 	 */
 	requested_num_queues = xenbus_read_unsigned(dev->otherend,
 					"multi-queue-num-queues", 1);
-	if (requested_num_queues > xenvif_max_queues) {
+	if (requested_num_queues > xenvif_max_queues ||
+	    requested_num_queues == 0) {
 		/* buggy or malicious guest */
 		xenbus_dev_fatal(dev, -EINVAL,
-				 "guest requested %u queues, exceeding the maximum of %u.",
+				 "guest requested %u queues, but valid range is 1 - %u.",
 				 requested_num_queues, xenvif_max_queues);
 		return;
 	}
-- 
2.51.0

