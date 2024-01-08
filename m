Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C8F47791;
	Mon,  8 Jan 2024 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAef6ZSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C30EC43142;
	Mon,  8 Jan 2024 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726744;
	bh=l8xBAzkR/eJ14XA7+yKe1qZeRy6QHTchxEgSYBpGx6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAef6ZSJ/d2JxvAZCjXgtBHhcSACEf4wUCuQefipIBM5hggovd40PTtxcMvVIljJ2
	 Qjdb4jNnIgcOLkxDFglmZU6Xz1DdwqgTupUxJIHMgqCq4EmpGYkBM/qfgcVCs/xPt5
	 RgPlfXluP63BBWNSqN3fipxUyga3xcKMYFm97u5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/124] xsk: add multi-buffer support for sockets sharing umem
Date: Mon,  8 Jan 2024 16:08:11 +0100
Message-ID: <20240108150605.959461379@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

[ Upstream commit d609f3d228a8efe991f44f11f24146e2a5209755 ]

Userspace applications indicate their multi-buffer capability to xsk
using XSK_USE_SG socket bind flag. For sockets using shared umem the
bind flag may contain XSK_USE_SG only for the first socket. For any
subsequent socket the only option supported is XDP_SHARED_UMEM.

Add option XDP_UMEM_SG_FLAG in umem config flags to store the
multi-buffer handling capability when indicated by XSK_USE_SG option in
bing flag by the first socket. Use this to derive multi-buffer capability
for subsequent sockets in xsk core.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Fixes: 81470b5c3c66 ("xsk: introduce XSK_USE_SG bind flag for xsk socket")
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20230907035032.2627879-1-tirthendu.sarkar@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock.h  | 2 ++
 net/xdp/xsk.c           | 2 +-
 net/xdp/xsk_buff_pool.c | 3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 1617af3801620..69b472604b86f 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -14,6 +14,8 @@
 #include <linux/mm.h>
 #include <net/sock.h>
 
+#define XDP_UMEM_SG_FLAG (1 << 1)
+
 struct net_device;
 struct xsk_queue;
 struct xdp_buff;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3515e19852d88..774a6d1916e40 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1227,7 +1227,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 
 	xs->dev = dev;
 	xs->zc = xs->umem->zc;
-	xs->sg = !!(flags & XDP_USE_SG);
+	xs->sg = !!(xs->umem->flags & XDP_UMEM_SG_FLAG);
 	xs->queue_id = qid;
 	xp_add_xsk(xs->pool, xs);
 
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index b3f7b310811ed..49cb9f9a09bee 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -170,6 +170,9 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err)
 		return err;
 
+	if (flags & XDP_USE_SG)
+		pool->umem->flags |= XDP_UMEM_SG_FLAG;
+
 	if (flags & XDP_USE_NEED_WAKEUP)
 		pool->uses_need_wakeup = true;
 	/* Tx needs to be explicitly woken up the first time.  Also
-- 
2.43.0



