Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FFD3D9027;
	Tue, 21 Jul 2026 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653572; cv=none; b=ii/l18flvVrUmL+KwfnquTcRBB41HYVrE0OsYQJdeXi5a0LUlHZjkTHsmKXU27k1uYbx7iXY9xMSbXj4BTLQgHyaWquD+d2a4fd+JB0FCMLIgTMF9xwZmv2UyjcMKyFaOvcNUnbqoHUi8zrAhVi7nKO4ROhxcn3tN51Hk7xepx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653572; c=relaxed/simple;
	bh=KzIZtEE/8IW3QO4ZFEo9EDqehG7Pd0JZq9WUyYy+Wz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlGHZhx4iZetBaVmBUqSZxgiKMBeQuS/IDAAoCvLONGvU2BBPCNGplSC0J5tMQsDr/IAxFPo5TlMD1Vve5L7ybHDuxGeN8vEXz7rs5lE5JIWzq4KeD8Mo8bmgLBOHLHtuzd9rr/cwx4UYagBvWBnFZ40JA+Ygaun1/6dO3Ww0GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2COcWIG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2COcWIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6C21F000E9;
	Tue, 21 Jul 2026 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653570;
	bh=Gma68P96Gz671ld4cClHMB8pSe1xqGnbVu6i2ykuJVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2COcWIGoet0LKRTl/ix3C5PsRDSWTeoVpoxK0Lu345ravczwAdCoDVEQafHMMZTV
	 5BWKVpQsdqe1dTQz5sK4pfJnpmXKtrxNenAw9/7gAb8Q03eqt40GHIVdLeFNeOx5Rx
	 268R7Fv9aNBhFoWdGn48E5QDmES68wkgn48b7GPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	David Howells <dhowells@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1375/2077] afs: Remove erroneous seq |= 1 in volume lookup loop
Date: Tue, 21 Jul 2026 17:17:28 +0200
Message-ID: <20260721152625.247783910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit a58edda50a3ec08e6adac1d04dc3e488494e412d ]

The `seq |= 1` operation in the volume lookup loop is incorrect because:
seq is already incremented at start, making it odd in next iteration
which triggers lock, but The `|= 1` operation causes seq to be even
and unintended lockless operation

Remove this erroneous operation to maintain proper lock sequencing.

Fixes: 32222f09782f ("afs: Apply server breaks to mmap'd files in the call processor")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-9-dhowells@redhat.com
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 894d2bad6b6cec..833ac3178ddc75 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -140,7 +140,6 @@ static struct afs_volume *afs_lookup_volume_rcu(struct afs_cell *cell,
 			break;
 		if (!need_seqretry(&cell->volume_lock, seq))
 			break;
-		seq |= 1; /* Want a lock next time */
 	}
 
 	done_seqretry(&cell->volume_lock, seq);
-- 
2.53.0



