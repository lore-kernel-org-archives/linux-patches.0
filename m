Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8394218EFC8;
	Mon, 28 Oct 2024 06:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098285; cv=none; b=GkRPOH2O8zNfgF6veCOuFxrhWScKMVAKlb/giIN/Ua2Ydw4rcAb4bYMCQWh32lmRwYhtfZD7+Uwb0rBj7r7xdZsZg/PBR6Ho630srq3wjuz9yIXMVq/9WrSOePuawI26A4Isz6K36bK0E6PVYvHn/5/dw8l8jVuNLKZBgxSyJAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098285; c=relaxed/simple;
	bh=4/NMH5kA+KHeoTHDepAV8t5EUr+irxp73EoJnUbRzqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLWODseqtVUaLqDpzmWkYSYRmJfluXYMW7cBgF3Y62jQLuBi9cgiF3FDplrQOuBvNcUHt3hpab/joVvidSeXlDA2a17ZZ3tolHA/KHpB3M6yWO1xsFkhhTSnXVAfRgDjPhd+6l0hCj2DwFtAFNWrxNwa9YxLBDdKobhQwCZ7n+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6kTwqLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6kTwqLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248A1C4CEC3;
	Mon, 28 Oct 2024 06:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098285;
	bh=4/NMH5kA+KHeoTHDepAV8t5EUr+irxp73EoJnUbRzqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6kTwqLB1fFcOPgagcK1gaBoWhlpCHFp0q5pztDiOCXOZEsNukWvq+QqxQNSzcqvR
	 fD69BBu+kevdTF3xIGndnU+NbY5OG6f70PkeqFLFnz5g6bGSZGgDXkPP7SL4z/GHEE
	 yyimRZnn2fxqI+vIPTGSSPANxTla+ZgKehgm83bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Colin King (gmail)" <colin.i.king@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 159/261] virtio_net: fix integer overflow in stats
Date: Mon, 28 Oct 2024 07:25:01 +0100
Message-ID: <20241028062315.996590513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit d95d9a31aceb2021084bc9b94647bc5b175e05e7 ]

Static analysis on linux-next has detected the following issue
in function virtnet_stats_ctx_init, in drivers/net/virtio_net.c :

        if (vi->device_stats_cap & VIRTIO_NET_STATS_TYPE_CVQ) {
                queue_type = VIRTNET_Q_TYPE_CQ;
                ctx->bitmap[queue_type]   |= VIRTIO_NET_STATS_TYPE_CVQ;
                ctx->desc_num[queue_type] += ARRAY_SIZE(virtnet_stats_cvq_desc);
                ctx->size[queue_type]     += sizeof(struct virtio_net_stats_cvq);
        }

ctx->bitmap is declared as a u32 however it is being bit-wise or'd with
VIRTIO_NET_STATS_TYPE_CVQ and this is defined as 1 << 32:

include/uapi/linux/virtio_net.h:#define VIRTIO_NET_STATS_TYPE_CVQ (1ULL << 32)

..and hence the bit-wise or operation won't set any bits in ctx->bitmap
because 1ULL < 32 is too wide for a u32.

In fact, the field is read into a u64:

       u64 offset, bitmap;
....
       bitmap = ctx->bitmap[queue_type];

so to fix, it is enough to make bitmap an array of u64.

Fixes: 941168f8b40e5 ("virtio_net: support device stats")
Reported-by: "Colin King (gmail)" <colin.i.king@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/53e2bd6728136d5916e384a7840e5dc7eebff832.1729099611.git.mst@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f8131f92a3928..792e9eadbfc3d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -4155,7 +4155,7 @@ struct virtnet_stats_ctx {
 	u32 desc_num[3];
 
 	/* The actual supported stat types. */
-	u32 bitmap[3];
+	u64 bitmap[3];
 
 	/* Used to calculate the reply buffer size. */
 	u32 size[3];
-- 
2.43.0



