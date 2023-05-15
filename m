Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C765FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F297EC433EF;
	Mon, 15 May 2023 16:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169120;
	bh=/QulOi7+fE1eoYHinXQW0+mbuiHyaqniPBcWHZ+EyI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GE0ymM+zdX0bp1nKVRN8JG1gPzOcld6N6qlJUs8/w0DUaNlXNkQSIcw1jAYOKjbWh
	 ZvnREa3Omi8EFWsWL57E+jqxvLLrb7SyWwDTeKLCGQri7BrWil5OjzySK1La411iwa
	 0h5uQKQlekRw3DbW++Ifza1npA3S445O3E6VJLtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zhengming <zhang.zhengming@h3c.com>,
	Zhao Lei <zhao_lei1@hoperun.com>,
	Zhou Kete <zhou.kete@h3c.com>,
	Pengcheng Yang <yangpc@wangsu.com>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/191] relayfs: fix out-of-bounds access in relay_file_read
Date: Mon, 15 May 2023 18:26:25 +0200
Message-Id: <20230515161712.802927764@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Zhengming <zhang.zhengming@h3c.com>

[ Upstream commit 43ec16f1450f4936025a9bdf1a273affdb9732c1 ]

There is a crash in relay_file_read, as the var from
point to the end of last subbuf.

The oops looks something like:
pc : __arch_copy_to_user+0x180/0x310
lr : relay_file_read+0x20c/0x2c8
Call trace:
 __arch_copy_to_user+0x180/0x310
 full_proxy_read+0x68/0x98
 vfs_read+0xb0/0x1d0
 ksys_read+0x6c/0xf0
 __arm64_sys_read+0x20/0x28
 el0_svc_common.constprop.3+0x84/0x108
 do_el0_svc+0x74/0x90
 el0_svc+0x1c/0x28
 el0_sync_handler+0x88/0xb0
 el0_sync+0x148/0x180

We get the condition by analyzing the vmcore:

1). The last produced byte and last consumed byte
    both at the end of the last subbuf

2). A softirq calls function(e.g __blk_add_trace)
    to write relay buffer occurs when an program is calling
    relay_file_read_avail().

        relay_file_read
                relay_file_read_avail
                        relay_file_read_consume(buf, 0, 0);
                        //interrupted by softirq who will write subbuf
                        ....
                        return 1;
                //read_start point to the end of the last subbuf
                read_start = relay_file_read_start_pos
                //avail is equal to subsize
                avail = relay_file_read_subbuf_avail
                //from  points to an invalid memory address
                from = buf->start + read_start
                //system is crashed
                copy_to_user(buffer, from, avail)

Link: https://lkml.kernel.org/r/20230419040203.37676-1-zhang.zhengming@h3c.com
Fixes: 8d62fdebdaf9 ("relay file read: start-pos fix")
Signed-off-by: Zhang Zhengming <zhang.zhengming@h3c.com>
Reviewed-by: Zhao Lei <zhao_lei1@hoperun.com>
Reviewed-by: Zhou Kete <zhou.kete@h3c.com>
Reviewed-by: Pengcheng Yang <yangpc@wangsu.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/relay.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 0f027e04b0094..e6f70f4c41a36 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1077,7 +1077,8 @@ static size_t relay_file_read_start_pos(struct rchan_buf *buf)
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t consumed = buf->subbufs_consumed % n_subbufs;
-	size_t read_pos = consumed * subbuf_size + buf->bytes_consumed;
+	size_t read_pos = (consumed * subbuf_size + buf->bytes_consumed)
+			% (n_subbufs * subbuf_size);
 
 	read_subbuf = read_pos / subbuf_size;
 	padding = buf->padding[read_subbuf];
-- 
2.39.2



