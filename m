Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F40F15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7063C433C1;
	Mon,  5 Dec 2022 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268205;
	bh=pqjXRLDeDU42CC6W+w4CM5n80Y/ZLSl8ZW5c/RyXzPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sd1FyklmKQdAcJidAcp5kGbhxZAuSSGmDDoJI7pDRcKwSJjApjMlLIdFs9ZP1Lxna
	 c8t8Z4UQPJ6+oFXTeWbD407DC+A4+ZF7guzjvmLbunMQfwlCDbxjCS5kIXdmJ/6Xgs
	 gwAYZNvt4z6R4Lu+w1prYq1hndWwHevI9VF2m+YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 019/124] libbpf: Handle size overflow for ringbuf mmap
Date: Mon,  5 Dec 2022 20:08:45 +0100
Message-Id: <20221205190808.998804607@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 927cbb478adf917e0a142b94baa37f06279cc466 ]

The maximum size of ringbuf is 2GB on x86-64 host, so 2 * max_entries
will overflow u32 when mapping producer page and data pages. Only
casting max_entries to size_t is not enough, because for 32-bits
application on 64-bits kernel the size of read-only mmap region
also could overflow size_t.

So fixing it by casting the size of read-only mmap region into a __u64
and checking whether or not there will be overflow during mmap.

Fixes: bf99c936f947 ("libbpf: Add BPF ring buffer support")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221116072351.1168938-3-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/ringbuf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 8bc117bcc7bc..c42ba9358d8c 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -59,6 +59,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	__u32 len = sizeof(info);
 	struct epoll_event *e;
 	struct ring *r;
+	__u64 mmap_sz;
 	void *tmp;
 	int err;
 
@@ -97,8 +98,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	r->mask = info.max_entries - 1;
 
 	/* Map writable consumer page */
-	tmp = mmap(NULL, rb->page_size, PROT_READ | PROT_WRITE, MAP_SHARED,
-		   map_fd, 0);
+	tmp = mmap(NULL, rb->page_size, PROT_READ | PROT_WRITE, MAP_SHARED, map_fd, 0);
 	if (tmp == MAP_FAILED) {
 		err = -errno;
 		pr_warn("ringbuf: failed to mmap consumer page for map fd=%d: %d\n",
@@ -111,8 +111,12 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	 * data size to allow simple reading of samples that wrap around the
 	 * end of a ring buffer. See kernel implementation for details.
 	 * */
-	tmp = mmap(NULL, rb->page_size + 2 * info.max_entries, PROT_READ,
-		   MAP_SHARED, map_fd, rb->page_size);
+	mmap_sz = rb->page_size + 2 * (__u64)info.max_entries;
+	if (mmap_sz != (__u64)(size_t)mmap_sz) {
+		pr_warn("ringbuf: ring buffer size (%u) is too big\n", info.max_entries);
+		return libbpf_err(-E2BIG);
+	}
+	tmp = mmap(NULL, (size_t)mmap_sz, PROT_READ, MAP_SHARED, map_fd, rb->page_size);
 	if (tmp == MAP_FAILED) {
 		err = -errno;
 		ringbuf_unmap_ring(rb, r);
-- 
2.35.1



