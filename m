Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C90419CD07;
	Tue, 27 May 2025 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366990; cv=none; b=O6RjELiUpZnpPMp/NZw1VKrsH9of+Y2IJeRWWx/vWCHVuwGPMmPQ+3huNKIUqY5p/YXwqWEVEr+NY0i3oM6iFnjcQRg3u17f0g8sAjlazuGaAQW7XOjl2WVBoM9BmRSJaV3bLV4DsZMJByOUjvjRZq/SKHhDBWbdNMcp6Wjg9I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366990; c=relaxed/simple;
	bh=ccZq1US7TlAODulag60VfWd4fDgMeX5sQkTUPzSVkNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXBDv5q0tDx7RgHFhc/M+xeDYw8MHsXfRi1wyypm5pJUaxRR0HJpbR7yp7FfBABbrqjtMYdAfEfxGtSyu0gFiyYrEqKqaqKJgzaD6hQzV51nUC656cPvE6rmIMNPJdrZotklPfXo7ssApm6tUvf4B54BmqWXCISjolLX0LOCt38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdajuQOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdajuQOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8CAC4CEE9;
	Tue, 27 May 2025 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366990;
	bh=ccZq1US7TlAODulag60VfWd4fDgMeX5sQkTUPzSVkNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdajuQOnHwOuS1h/7XiZQSzTFcP6VYWONAlPE9Io1QlNVX6QEI2pHJl93TfOsmKLq
	 O4qebuizFE/lI9nN1U7iQMPIsUa/Uyjj6iRbL5pah0E22tx2QYokR6D9/kJrrNw4aV
	 1wI6LIaWQqBZZkucgqv2xl8+SlO/hqCMOhMHNZD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 242/783] fs/pipe: Limit the slots in pipe_resize_ring()
Date: Tue, 27 May 2025 18:20:39 +0200
Message-ID: <20250527162522.966049668@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit cf3d0c54b21c4a351d4f94cf188e9715dbd1ef5b ]

Limit the number of slots in pipe_resize_ring() to the maximum value
representable by pipe->{head,tail}. Values beyond the max limit can
lead to incorrect pipe occupancy related calculations where the pipe
will never appear full.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20250307052919.34542-2-kprateek.nayak@amd.com
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index 4d0799e4e7196..88e81f84e3eaf 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1271,6 +1271,10 @@ int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
 	struct pipe_buffer *bufs;
 	unsigned int head, tail, mask, n;
 
+	/* nr_slots larger than limits of pipe->{head,tail} */
+	if (unlikely(nr_slots > (pipe_index_t)-1u))
+		return -EINVAL;
+
 	bufs = kcalloc(nr_slots, sizeof(*bufs),
 		       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (unlikely(!bufs))
-- 
2.39.5



