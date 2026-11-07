Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065423;
	b=NN5V1Wnwq9urSxvlKgwzUBntvq8QJnqv4WnzFkZ5E6SmLdO2DNiwFv/6KLTHTGU6hYhc
	 sHlKUNuaAXqOJwl7CZARFeysdMUltr5Ths9eZd5P3PSgOFFovOBVHc4s15e6Ka/4TUO6g
	 bef87NNfd4sU/COQx+Q+u7NFea4xlX2Qkor/0b3OM3N+jTizugNQcRt227+3sz/0n9Tfm
	 iYjyx2zWp9zwUpfNQM7NyXZUm8BBGXvIGhBG2qf5+0s9MieM4Q5i32t+tsM1ryRgcSPz6
	 jfm1dchgBQFsTSx1I1ERzcV/qWZjFiFkhzuIpKSbKUjqJew+wZlDKolz7Xe8bFGeQbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FAGU3x7AkEwkaRzNAEI6oHAcLFnoWbDKwoDA5G6kuI0=;
	b=ZJfNol6+QkjOFsBqzMR1v/vno0qHstqGmfIBR+FOT6VjQZWhSGUMsEdDb7zMWOFMQovp
	 utWR3+TierFyaGD2qPIOPsfpKF+Y9vVSNBZkRbXWXuWfC29rZfBsfRnUKsESnNpsAe6mI
	 Z3auoYcK1by5cH3PiumDd1v9NZpJZ84KuRegFXwZJdS2pJLp0DWC9HDfxFhtzhncUhdrr
	 C3Oz2w+2qFpKJt2uisG3uw7MaKYii1KNudVmh8AF3pqfJH8+PruoHcvbWEqwVkgy6rlXK
	 f+25wQoLQzsVf/SCxOIpfb9E9B9lp6PmoQ3hb/Dr9OQ1MjNhLP2tNlISRf1KLshn0iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y96QsSLX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32471606A33B;
	Sat,  7 Nov 2026 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y96QsSLX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECA91F0089F;
	Sat,  7 Nov 2026 15:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065423;
	bh=FAGU3x7AkEwkaRzNAEI6oHAcLFnoWbDKwoDA5G6kuI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y96QsSLX7Fcw/vouZz7ZjeCyGF6RvNWMNR6DK6NQ7u2AjUbwVxWFWzVsc+Ty4q4KL
	 P5I2ZIb4/ZhumDWLoKukJkalZk6PoUC+lngtU7d+GqWz2nefE6iSESXoXau5ujQ2ZS
	 OO2T03w1HaU6v0SEzTdrDVdHS2SIiULm6Bv38T7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1136/1257] ceph: fix uninitialized err in ceph_netfs_issue_read()
Date: Sat,  7 Nov 2026 08:57:12 -0500
Message-ID: <20261107135010.601848433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Markuze <amarkuze@redhat.com>

[ Upstream commit 823d21c78453fcdf58dbd8ecefbb41f4f3eb6540 ]

ceph_netfs_issue_read() declares err without an initializer. On the
unencrypted, non-sparse success path nothing assigns it, then the
out: label does if (err) netfs_read_subreq_terminated(subreq).

With CONFIG_INIT_STACK_ALL_PATTERN, err is 0xaaaaaaaa (nonzero), so
the subrequest is terminated while the OSD READ is still in flight.
netfs then frees the rolling buffer that the OSD iterator still
points at, causing a KASAN UAF / oops, and finish_netfs_read()
terminates the same subrequest a second time. CONFIG_INIT_STACK_ALL_ZERO
hides it because err happens to be 0.

Restore the err = 0 initializer so a successful submit leaves
completion to finish_netfs_read() only.

Cc: stable@vger.kernel.org
Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ec14a5606886f..e07a7b1d3663c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -370,7 +370,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct ceph_client *cl = fsc->client;
 	struct ceph_osd_request *req = NULL;
 	struct ceph_vino vino = ceph_vino(inode);
-	int err;
+	int err = 0;
 	u64 len;
 	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
 	u64 off = subreq->start;
-- 
2.53.0



