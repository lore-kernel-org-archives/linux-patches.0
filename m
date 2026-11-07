Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062599;
	b=1hBrVEHFwE4TzwKXSGKrxt9fh1XiJv3iC4ThZuJ81Nua6qryCwRi5jPEwOppb2wVVjWa
	 TidsqQJCk9VFTK+0Of/vpD0dv/l9iylKHiPfxmWftAeQMrjr0/r9HkFZK2bKc1kr+nxlW
	 1CntPTc0lLMfSVuiaNNZFoFF2TDHUdPTg2slethRQHiMCYnkRKD4S1KNJEr12Wz/Y6Hvm
	 kfdVDo+MVTOycYwNwctEhY07geXZE+vk8NZfW5hcvQQwNmiSsUWupdkp/1mF0z4U4gx9V
	 tGzYowa9vAzlWcY8P70oQGac8aUHxzJo6wgO5f8KeNK1s/9Q5MA2LPsWmpv7/tew1NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rEKs8w42PNHfu7UvQILpp6w9ygUzYjzBvNTikpUjbkM=;
	b=hFz4+qVjrR+W1XCWzY3FGhGdoAVMtNgngy9goYu5unWiLI4RQY12/PQVISunLKgXuD6w
	 OWijtHMKgnMTEnXduw6u6O/c1OmfseG4Ei1B/Yp9OyW7gfjLZh9MAO8qyCv3dB0N+eDYG
	 z/QLufJQV7pe0LNh8ghBZ3jxTVl3PRI96rABKsdFCJjQAXe3TgAeC2qFpaWHwd/5zhun6
	 foVETKWBt/2m8jLyDRnBPcHHGN7HmTtdY42sJjYekuw258BsrJH2rXnr8hg3ELPQW1gdV
	 HNSFHKNFnY7RlA85ftQHLHbJJtRLkxDW5wM0k6jRAtfS1LCw57UTiaZxoaHySgWW+QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3G9bceR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF6D606D81A;
	Sat,  7 Nov 2026 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3G9bceR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0901F0089F;
	Sat,  7 Nov 2026 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062598;
	bh=rEKs8w42PNHfu7UvQILpp6w9ygUzYjzBvNTikpUjbkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3G9bceRmKegk7lnXt1NXs5tsvOh+4+JA1WMzUNM6mj62u4mJm2p1gk4LXbDB8fxq
	 ckBan1XziVs3lI7/PNxWQU3fYa5j+0hR9VqpubBRWiWSc/oRhnjrUf6JAaHPPeWufZ
	 9kI2ex8yOzW1yNp0lhw8xSN5l86xEFXg5QicZQY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1473/1536] ceph: fix uninitialized err in ceph_netfs_issue_read()
Date: Sat,  7 Nov 2026 08:58:09 -0500
Message-ID: <20261107135039.219445185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 611019005f147..aa551d94be1c6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -352,7 +352,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
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



