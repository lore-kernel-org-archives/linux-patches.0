Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843941BD9D3;
	Thu, 30 Jan 2025 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247364; cv=none; b=qalcD3Ozhour7yvx17elCNfs15+QTa2qD6UiqUvin9EwnAwkTouwSns2SGBV0E9uqbuy772CmdgqNbSiXzBJDUKVrO3kD+KYyR9XfNveOFpsY+/BsCi6YTgy08R5J0SkLSG2pOxioy3AdYbPjfAnmfKUs5Y1eKGN/XHyqh6W0Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247364; c=relaxed/simple;
	bh=1aUFo5KsWr4u4qm1UY2IrfzgfgfV/FzjeymemkBIInY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciq6EiuHNaVuPlq1NyWMm3buKzUmM4kGn8/QvdMKwHkIrWApvzsA2mldfpbhLz5DvYJ5C5Mlqa5faRyR/MAuGagjg0zqhjs6JamNsiauo6gYN0g3FH/4++vnRbBB6QtnOBgNl4CgWd0ZzzbcsC76nCiq08fk8xEYbwe2Nz4UW9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldB3qLxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldB3qLxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FD1C4CED2;
	Thu, 30 Jan 2025 14:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247364;
	bh=1aUFo5KsWr4u4qm1UY2IrfzgfgfV/FzjeymemkBIInY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldB3qLxAn9w1m3Uq43mhbx+Xdo9WNK8Egex+bbS3uecgs9mq4l815sMQrVLhefkXZ
	 JcSj+6MXYDswQqH2AliBk0UQ2evYOVyFZQcfU3vSHm5K/gJjvM1s5ZJLv1ITyAhq+R
	 /65Veu4u9fx1G9O3rIJ+OUXBGyUFUl/dqx7bNL/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 14/49] xfs: prevent rt growfs when quota is enabled
Date: Thu, 30 Jan 2025 15:01:50 +0100
Message-ID: <20250130140134.405811183@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b73494fa9a304ab95b59f07845e8d7d36e4d23e0 ]

Quotas aren't (yet) supported with realtime, so we shouldn't allow
userspace to set up a realtime section when quotas are enabled, even if
they attached one via mount options.  IOWS, you shouldn't be able to do:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt -o rtdev=/dev/sdb,usrquota
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -954,7 +954,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;


