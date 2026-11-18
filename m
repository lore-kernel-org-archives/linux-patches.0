Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019613;
	b=eBX1Fv4BMXktkJmJXbg9AvXQ+2xyImleeSyTHnvxUiJh34BJ8gwteeslzZHdEA3nihGv
	 H2BHdnIMK492KNnJ0DzJPDtepPgPb6AANOuYLc7fNmPtBoWZI2k0zCifux9tPH/8n177j
	 5sHkJ87VmTkmsQ4hWSBRYkcjxdcagJfRxbzIAyS3yJbUH4nkGIfZDe29lHpHHYpa4gW4R
	 SjS03AGDn+QX0PWh5BAMU4SgP569DYpQ40E27kYLLAs8rLRil9VdlQUpGSiJmvJC7aqon
	 j0cEHZXyNEru/3UWrDZK9rwOulC9IbpqX3Xa+JVFndYf63cxsOoFX8vJfbV2Z1Q7Pug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oUo6PdTxS54CRPrFhXWSB2r6sR7zTOT3Amo3e3nWKF4=;
	b=J2FE0cuuJSVJfZWqJkIYHs1wlCJdfwg6Cah4SU9fg2U1EjnHvylHzn+YN+wS7BTeW4w+
	 Wf90Rvrteo46KRRhnvqIWt3RDMXBpsyqdCnrLgDq4uZuSRG1X/ddoRuo3s1as6FssDkKS
	 XFw2jyXh06omjKzu9xB5EKKdJgzVgarfS8QDRPN27ZSp6cI0LbKm3wmEcGTxCN7N8+qAH
	 pUnaST7FYmSj98DkWnxw+m5ofYIeZ/+sznTxDZ/ZykE6vBmslzkxokC/SDDg8DSxuFLBH
	 GDNRCckkQIhyj8MffRuNYb1F3ptv3TCA6tQcLFkthXWz8BBmwCjIhYAoEePFdH3zjIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TGP1lijj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31959606A7C8;
	Wed, 18 Nov 2026 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TGP1lijj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828471F000C4;
	Wed, 18 Nov 2026 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019613;
	bh=oUo6PdTxS54CRPrFhXWSB2r6sR7zTOT3Amo3e3nWKF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGP1lijjDHWaq1r7TPtMgPpsh+oCLY8Y3jgb8NwanteFVFIM5HQCgP1AL6BMEZ/bQ
	 jgv5KAz9fQ5a4zr8qnxKOUO+piT/ZLpulUZ8RKk3DbocWI/I5FcdgQaa7/NdKrcBea
	 Bimur1H89LeLNG8AQsjiv+ovLyuG6Q4ST7dqj42c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1656/2651] btrfs: fix incomplete iteration over fs state when logging messages
Date: Wed, 18 Nov 2026 15:48:16 +0100
Message-ID: <20261118150347.373862663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 198d1747c80aa..6debf0d4acadf 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -42,9 +42,8 @@ static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
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



