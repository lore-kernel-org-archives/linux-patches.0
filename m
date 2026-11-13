Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590594;
	b=larIbIpAlYxa0a8h3NIwHKvODAoFXhZ9MiRtBMQNd/JbueETpf/zr1DeVSKRuZEgpTwz
	 lcWZLkGbI2jKCoK2ox23WWWK2p9glsCV5nONSRVGvIJIO11g0TU+agl5nk2paW7JE9ro0
	 2qJgSvFYSlxxJ4LxReQtMhXQ46LO0D8gfxqLYjbfbU8bxblr/1BQerhxEMlkTKAvoK4gs
	 SLz2SW2r6YMFmY33WvoT8B2vvT8eIsSoytDPpuUxo2MrIPK+H6eFPQ4d6PTSRSkao5AMj
	 qf+iPjpcjNQfFSdssv42+BeIKSbZ5ilwj2M9SoYHjkE+THyy5AbvlIbTQZ4QvuvHRtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yu+/7QT8+MaZWXZZVIB8P8CvxlJRJb/O9cVb+LQf0H8=;
	b=vcCQDuqmcb0vSyFFwNbiQe8EiIxV7Mdb6Jm5G++TkfkZ//+ZOxPufYX9KTvgIzkk2jya
	 5bxWT+iX380v8PJklkLR4jvoaL8n9MT7i40Ogm4Y/taSZcmfIiiu7rKc9EEoxAmOtayut
	 r/SNKiLaJn7FhJIzP/RoUzPJL/xqoyBFGlcpfvtZUB1m8XzbBOsA+ihPTIqDx0G+fO0we
	 WGZLv+wZgcgNRnUdaqL8s4VsPnuYkL8aUTcYQ0K3V3hP5zim0L+ZIQEaRfYQ8POGQjQin
	 3ygP4mhvU8+cPs9Eu71VUEoQwj/YiB0pIzjwKyA3Ae93r/zRwnRTOFsk8MZjTAJ1y4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g33IooBO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C467606A32E;
	Fri, 13 Nov 2026 17:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g33IooBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095231F000C7;
	Fri, 13 Nov 2026 17:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590594;
	bh=yu+/7QT8+MaZWXZZVIB8P8CvxlJRJb/O9cVb+LQf0H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g33IooBOHbwuVw4+CJvEqMxVV5eS7EXFyqZKY9Mk8G9Zwl11KQO4iemM4g7iNru+5
	 7geZbY6rQslQ9lG8RPUTniXicUyJbFxegmAFFHJlW0JQfeDhiL3YCIKi7QBeJT0i2N
	 4+v9EFpYSRU3C4FIWsHl7sr9fVOhNHx/W7fDUtPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 525/686] misc: fastrpc: fix double-free in fastrpc_map_attach() error path
Date: Fri, 13 Nov 2026 10:50:58 -0500
Message-ID: <20261113153838.923783189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Gao <gyf161023@gmail.com>

[ Upstream commit 09fa66ec1b4896ab841da085ca58b6433f28f07f ]

map->table is assigned right after dma_buf_map_attachment_unlocked()
succeeds. The two failure checks that follow, the len > map->size test
and, where subsystem VMIDs are configured, a failed qcom_scm_assign_mem(),
jump to map_err with map->table already set.

map_err manually calls dma_buf_detach() and dma_buf_put() and then falls
through to fastrpc_map_put(). Since that change the error path tail is
fastrpc_map_put() -> fastrpc_free_map(), and fastrpc_free_map() already
unmaps, detaches and puts the dma-buf whenever map->table is set.
The two operations therefore run twice: the second dma_buf_put() drops an
extra reference on map->buf, and dma_buf_unmap_attachment_unlocked()
dereferences the map->attach already freed by the manual dma_buf_detach().
kref_init() sets the refcount to 1 with no intervening get, so the final
fastrpc_map_put() frees the map synchronously and the redundant cleanup is
deterministic.

The len > map->size branch is reachable by an unprivileged process via
FASTRPC_IOCTL_MEM_MAP with an fd whose dma-buf is smaller than the
requested length, before any DSP invocation.

Route both map->table-is-set failure branches to get_err instead of
map_err, so fastrpc_free_map() is the single owner of the
unmap/detach/put sequence. map_err is retained for the
dma_buf_map_attachment_unlocked() failure, which is reached with
map->table still NULL and an attachment that fastrpc_free_map() will not
clean up, so its dma_buf_detach()/dma_buf_put() must still run manually.

Fixes: 334f1a1cbe03 ("misc: fastrpc: Use fastrpc_map_put in fastrpc_map_create on fail")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101220.1084101-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 891f28e933537..9d596f4fd4dcd 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -854,7 +854,7 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 		dev_dbg(sess->dev, "Bad size passed len 0x%llx map size 0x%llx\n",
 				len, map->size);
 		err = -EINVAL;
-		goto map_err;
+		goto get_err;
 	}
 	map->va = sg_virt(map->table->sgl);
 	map->len = len;
@@ -877,7 +877,7 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 			dev_err(sess->dev,
 				"Failed to assign memory with dma_addr %pad size 0x%llx err %d\n",
 				&map->dma_addr, map->len, err);
-			goto map_err;
+			goto get_err;
 		}
 	}
 	spin_lock(&fl->lock);
-- 
2.53.0



