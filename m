Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065186;
	b=InsBzlZw8Wedmuk48NUWzHAHgTAGQCLfH4JgEz0lSwFisUEisuVdiOUZLJXvSSMHF/DU
	 GSsb31R+Yn5zWgUA8+KXLjRInhuRcG99dxTkSVYtn6hQen+rkPSRnUfi+GoK3U60YfuVp
	 6jEkoS8XAjR4uSAELJsfmv6MjPVDUah+ZvEK6ll3qjFIlZsLxPBFiftSy01Cq/3vc3P8x
	 HO315PpsJvhnu2GsShqA/vulH0wU4c/isE+WioSNuPdosOr1FjaNTdFt7fob7JL3dEBdB
	 mdrFlVGBKKeLhiRwXK9+XU68PCVPn5wPzJxLeHShTeicb6ebj8UAekM6BqN8iMAHAqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0fx4JkHC0VRDAwC2khDA6VKisuuhzZcIhempEVjORf4=;
	b=WGOWh+JZwHxeOXznUSX51th9jNEwfRkw1cqP0qPx8Nb/ZUxTG0vPe1S8YJXqTQNZVHHK
	 JTfP3zTPYttAFhQZOqnVde07fV2ayuIR6tmhW6kBP+GXQJ4FcIARF4JEIr4UhHKlXMXxj
	 cdwB2/DMSEfFIk7alaiiipypNI3GQJNv4kk8OG/66/FY06PPyhYtB+PsqkVekWo/r5nbB
	 9lrqNKEXIej+xr7omQ04dCqLWLYcnmGP/swUOs61nX8EhLGv2xWooAlPtz6ypJphWFoND
	 7pByZdbSUOSP6pdWiB8RJ8FvYA4HjRc1uSa7iMpGbK68m5tbm8ZUcBDRFMX2MkJTsKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=meOALSbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA8A606A335;
	Sat,  7 Nov 2026 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=meOALSbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565E81F0089F;
	Sat,  7 Nov 2026 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065185;
	bh=0fx4JkHC0VRDAwC2khDA6VKisuuhzZcIhempEVjORf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=meOALSbGPWg9fI8AJgocOS0UMMsCUHSNmn/uE8p3P+ri08lMEemK0f/OG3AvEIK9k
	 7epL74SdCnKTi6E7T9UudIWJCRBWjj+/Kp1TM83y8wTmocWCnu8I1PXEU4KR4YSJDr
	 tXyWhnxKFjQV6cVA6K+b7oxKtrRR3gh8CBBVFfxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0989/1257] exfat: fix a large buffered write failing when the volume is nearly full
Date: Sat,  7 Nov 2026 08:54:45 -0500
Message-ID: <20261107135006.680330357@linuxfoundation.org>
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

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit 73cababf93cb371e2e9d06da5261ca6ddd2404b6 ]

Commit 82a81a7352bc ("exfat: add iomap buffered I/O support") made a
buffered write map the whole range of the write in one step, so the
clusters for all of it are allocated at once.

However, exfat_alloc_cluster() returns -ENOSPC when fewer clusters are
free than it is asked for. As of now, a write() that is larger than the
free space writes nothing and fails with ENOSPC, while it used to write
as much as fits and return a short count.

The issue can be reproduced with a 16M image made by mkfs.exfat that is
filled except for 256K:

    mount -o loop /img /mnt
    dd if=/dev/zero of=/mnt/hole bs=256k count=1
    dd if=/dev/zero of=/mnt/fill bs=4k
    rm /mnt/hole
    dd if=/dev/zero of=/mnt/f bs=1M count=1
    wc -c < /mnt/f

Before commit 82a81a7352bc ("exfat: add iomap buffered I/O support"),
the result is:

    262144

After that commit, the result is:

    0

This patch will map a single cluster when the clusters for the whole
range cannot be allocated, so that the write goes on until the volume is
full. Direct I/O is not changed, it still fails without writing as it
did before that commit.

Fixes: 82a81a7352bc ("exfat: add iomap buffered I/O support")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/iomap.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index bcb7a9214f92b..f734d13d3fce5 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -75,6 +75,17 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 
 	err = exfat_map_cluster(inode, exfat_bytes_to_cluster(sbi, offset),
 			&cluster, &num_clusters, may_alloc, &balloc);
+	if (err == -ENOSPC && !(flags & IOMAP_DIRECT)) {
+		/*
+		 * There are not enough free clusters for the whole range. A
+		 * buffered write can be short, so map what still fits.
+		 */
+		num_clusters = 1;
+		err = exfat_map_cluster(inode,
+					exfat_bytes_to_cluster(sbi, offset),
+					&cluster, &num_clusters, may_alloc,
+					&balloc);
+	}
 	if (err)
 		goto out;
 
-- 
2.53.0



