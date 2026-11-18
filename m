Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026224;
	b=tpbiyg6OH2qT8yeH0SrO2u5XG805yRvrdryP6mi3Xd6uiHhnDsVILm2bYRxSeRsam24S
	 Z+7+4+yOTeuvQqLo/9Bn8cvRKqRBBiFB9WQAnCbnxtCdNdPIY+DGfq+/r17XHzGBQ45cx
	 Czo5Db1gEoNqlCopfkr5elwHvl5hpLwCileAOfEBgUnfLL6wu9OBI7QdTreae4AaxcdH1
	 IDRnGuy7LC7kLNL4Kgn6xj8qokAd4msfWmxXvspXXUShtUytGAkIzh7/VOxtZNKlx0jOq
	 J69oy5wyypIe3XXFvPpLp1PQY0kdv2v1vYL+ahXQs8hi7rvQ8QJSevs7ItM9OM9tHng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBM7B5J5CC/z0ite4aDxxQoDHOsP4xO/f/XY7BYkT1Y=;
	b=ZeRIJ8WUMbDH01dVQ2VC6Xi1Ya2tJPq3PP7dz1qwh88ZOLC0iypEPmxJy9tLiSRua826
	 vdFUaU+mSrGcfjOUdsdCfAuSBdjTCPJoQHiudSh9nGUdScj5LybrzRMJ0JZQHKGMMJttV
	 nk0KBjmhED3Sn0I2DPTChjPD7AbH0YAOouqddNobSZo6wYFsM1yObIIgHwpcgZod9Vhm3
	 Di7/RS74Ua03z18aof4NBW2YrWWzgx0n+/ADymvaVdFmXVQ0iu1cDP8SeLWccs+9IY1TS
	 2jhlyYeKoNqy+FECXcynRXc6Rws/iTxD4H6OQeT2mBTLjftIQ0/7p527HM/9uA/Pntw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8l3bnXy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BB7606A332;
	Wed, 18 Nov 2026 18:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8l3bnXy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49E41F000C4;
	Wed, 18 Nov 2026 18:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026224;
	bh=ZBM7B5J5CC/z0ite4aDxxQoDHOsP4xO/f/XY7BYkT1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8l3bnXyZ3PPUHfsaTqC4QgElwXJ0HCOQk0LW3yIGGzHfiTvxp3+NCsZct5pqcWEw
	 F3BLPfpkyUo9C4xCy4Ac4JVOFvihf+SgVpQcHqrLKUTakV5LKoiNKv2jwOHZXUqk4q
	 On0x+e3cRby3qxZe+RttnwBP1Gmv3EvCgvbSSPjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1359/2151] btrfs: fix incomplete iteration over fs state when logging messages
Date: Wed, 18 Nov 2026 15:51:34 +0100
Message-ID: <20261118150211.533181580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit d1d74665ab9a8971d42177ca865cfbe2897c1fc7 ]

In btrfs_state_to_string() we iterate over all the bits set in
fs_info->fs_state using for_each_set_bit(), which requires its third
argument to match the number of bits, but we pass it the number of bytes
of the type used by fs_info->fs_state, an unsigned long, which is 8 on
64 bits platforms and 4 on 32 bits platforms. This means we are not
iterating over bits in the ranges [8, 63] or [4, 31].

Fix this by passing BTRFS_FS_STATE_COUNT instead of sizeof(fs_state).
Note that we could pass BITS_PER_TYPE(fs_state), but since
BTRFS_FS_STATE_COUNT is 11 and we have no bits beyond that, it would
cause pointless iterations over fs_state.

This also makes pointless the checks for the bit being inside the limit
of BTRFS_FS_STATE_COUNT inside the loop.

Fixes: c067da878156 ("btrfs: add filesystems state details to error messages")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/messages.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index a0cf8effe008e..c218b2ea8566c 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -41,9 +41,8 @@ static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
 		states_printed = true;
 	}
 
-	for_each_set_bit(bit, &fs_state, sizeof(fs_state)) {
-		WARN_ON_ONCE(bit >= BTRFS_FS_STATE_COUNT);
-		if ((bit < BTRFS_FS_STATE_COUNT) && fs_state_chars[bit]) {
+	for_each_set_bit(bit, &fs_state, BTRFS_FS_STATE_COUNT) {
+		if (fs_state_chars[bit]) {
 			*curr++ = fs_state_chars[bit];
 			states_printed = true;
 		}
-- 
2.53.0



