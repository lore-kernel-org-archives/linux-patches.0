Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041264;
	b=T9Z1aA25DciJ8ntGne843jOxJ21kYX+KxsRdcMPUNp5AaCgjWmSYS3kEb08bELRToU8P
	 l10LK78aCssZL9avXT+81/fGBXnWQ+a5pNvR2E/BV8xrtiM7jzG2ZArmS+rJDBSmDI0Sd
	 dUJuQCoy07e4Qf0K7WJbwMDd/Ov6eLSmT9GXPQUhBya7+qKyd09Y679gJ9sDRu/cfNzRw
	 KXSq15r6E7O6bRKRaH/j5H+LllrCIRMZnv/Myhg+m2cvSd+l3gyUojpL6VoPZAtDewKYY
	 n26rWo5JtYYRDBWiNkDF8SuqA/YLF3GnpUYykcchAe7i34TLBLVWsZ7zAjVFkJ87RhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R3oqjYBIJD55O/hh8I195gyfDNoX0cZLpAtmeaa49KY=;
	b=NSErzvU+WYnD1GvQotOTxPShcOgLCoRfvuTymMPZyVXG4tiTi1APhAU0nokAY7fr9AbE
	 3KyYV4f4LjsRYtYiDnYvo7Uep8SGE8hlk4zWepclAOU/JaAnoszvG7Q4qpusPvIeuc+95
	 x31znRiJdWwuNgiMyn4xEAUsSDlTLeenWlIUl6GeDgLCbpuK5slL7kfIkcfDi0QOAzfgF
	 qEWqEcakXoFemo3altQH2AZbQrg0SHYskD5CULh9endNUg9jR+7vPzZ5X38WwoBoztky3
	 IQdTUN8YcfQXhgkvF/f/RDwPUwzdYw9MLTOZQblgRJWubMlzB/PpNXhzcwkyHqbdaGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9iz2+Be;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE8D606A32A;
	Wed, 18 Nov 2026 22:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9iz2+Be
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801331F000C4;
	Wed, 18 Nov 2026 22:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041264;
	bh=R3oqjYBIJD55O/hh8I195gyfDNoX0cZLpAtmeaa49KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9iz2+Be3guu6FxHaECz4Y3OwIS74WEKDAke2LpyoOf4aa22SKMe8UcrONm0Vh5JM
	 2cSJQqMc6jBq4cttIevpLtXUeF7U0dPrMpQkv3TH59YU64NcUrJ/0HGnWbzp9tzgWt
	 mKku+rtqwZ/iaIAa/vg5xAz2j5heo/HCBP+OScRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2750/3318] btrfs: fix incomplete iteration over fs state when logging messages
Date: Wed, 18 Nov 2026 15:56:12 +0100
Message-ID: <20261118150443.260721344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7695decc72433..6be7025b71365 100644
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



