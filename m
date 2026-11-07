Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064637;
	b=jOZP2X9rnc1tuhsDzbbQYvwwjL0GzpTlSOV6mg+yy3uM6E04q1vtqt5mRSX5uO6DaQl0
	 vM4YuzgbysQeNqno31kn3FUJkbpgZP+aITyyvO14LwqvN5VOBVMqOkko+N0ideXi6Fjwx
	 fmLAuD+JXELskCZc4+MRwsPeFvoFUvejKbHjda0sCK/7cdfVeXf3p3beh2E0TRvko3Jun
	 +lANyDGVGXF6PeNWc6NhT+QVRx0O7RfW/6grEv8eFf1L2fkts4r9/Y7Y12mUpxB0Xkh11
	 E9/bEx/fM1r2NLIqRMLkloAI+vvtlw0g/82wJt+IXoepsYqyV28PMzTQ75Wi/cHvfPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wUp5JZtVo9gpBOqDg6owLvad450dP4IxxhLEz/Hx15A=;
	b=K/OAh3oDShLwyzfw5zVGB+fFv9/cQdjzN39ioo5C6ESV9qzt39jtkDhgTYvDT9J+5vVM
	 6wBKljuMG/c+ywVpz6n6S6rfgPTgCysFYpsc/3gpJBcuypteH7B41o4FHQS+ShERjEBGP
	 M7TFGjrjStuz/pQg3tM8H1vNXH8Ev3y7vQXMwbv+DwvcPsYWOxYEbXgUB+xGxN6ZDs6hB
	 f3HeQuUXn7Fkdv9L4MU9esRN+xt+v8G0FA+d8wqW8/hLuha9uRXLV/N9CB71AlRcGGPX+
	 W213IwPMJFIn/kyedktWGHAprTUCjklPrBydaXQiIGWBVpm1r94v+ZmQFw+diE4/9dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwj3TcxF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA011606A33D;
	Sat,  7 Nov 2026 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwj3TcxF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579371F0089F;
	Sat,  7 Nov 2026 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064636;
	bh=wUp5JZtVo9gpBOqDg6owLvad450dP4IxxhLEz/Hx15A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwj3TcxF4SadVfiRoLqc3A1ts18WL1e60HY5MbOexPBAPIs1zC6xunH1Qk24gKoT/
	 NtR/gbhW4KIwrNYC0RQGPJVNiT0ptFCSswEYDZixHqbaFNrhBFBE030fFMG0Eqr8Oe
	 VB24AZB2AajV8K8IIeZOan9uj7M20qKTgp5no7AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0643/1257] btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()
Date: Sat,  7 Nov 2026 08:48:59 -0500
Message-ID: <20261107134957.034242364@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 886f1aa6e6b30a02901aa7f140149d466e10a873 ]

btrfs_repair_one_zone() hands the block group reference taken by
btrfs_lookup_block_group() over to relocating_repair_kthread(), which
drops it.  However the return value of kthread_run() is not checked, so
when the kernel thread fails to spawn, nothing executes the put and the
block group reference is leaked.

Check kthread_run() and drop the reference if the thread failed to
start.

Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO failure in zoned filesystems")
CC: stable@vger.kernel.org
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 85ea9c5d4536c..e7d3cd66a98d1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8971,6 +8971,7 @@ static int relocating_repair_kthread(void *data)
 bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 {
 	struct btrfs_block_group *cache;
+	struct task_struct *task;
 
 	if (!btrfs_is_zoned(fs_info))
 		return false;
@@ -8988,8 +8989,9 @@ bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 		return true;
 	}
 
-	kthread_run(relocating_repair_kthread, cache,
-		    "btrfs-relocating-repair");
+	task = kthread_run(relocating_repair_kthread, cache, "btrfs-relocating-repair");
+	if (IS_ERR(task))
+		btrfs_put_block_group(cache);
 
 	return true;
 }
-- 
2.53.0



