Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031461;
	b=O2si8bWTTtobuNqehzk4PzRCxIXGgxX6mERireP/kLRpquSsa781s70GwW/+TGnw7D+F
	 FcpkSFi1SLZ5Z6aDSdzyJKkMl0WeVz8vRlOyF/bosF5+mikkGQ945NHUhgtcN5wF3HydD
	 jn9zhOQPlDZKYbSlKp8CSJmLJ+jXnH5rdmLwAGz9EhCR/RKBdz0TNJzFa0D9Ke2AOV2QR
	 zAow9yw+bDABDnPZBQkjaEN98ZrK+Hxis9xVEI2EjCMlV7Z6nHM/efIbPFBZRlrJqUEj7
	 DEVpmleMcbt1cOb8k6QagJwtcQWzm1vw4khk1uN4NjBL7O7nAPl7W+WMGCYZKHm1opg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jq2za8hKFbV0IZu4GipcqHkZBXOiWJlKH7qOgGp9Rbk=;
	b=Q+Eerdc039FBM/P9qPwHCx/Hnip7DfquLLmFhPlA7yzIZkSB5AE4esp2bQWehcYnY4e+
	 k5Mg+ywui6gH89NKGhM9yox1tsi30aLzLTtmia8kSDBylM5dp4LvQEZrBUST3bKKTVND4
	 5tiIwry2PGSndTjll4AnXNknFydLCGSsnTDXeew64p5DIu8pf9pAGCSDb/6pPtHZCOUWb
	 2HcDOimGnGemC5aT2b1jJNsBvPuT/geTX+AIHFz6z9e8DneZW3D47/iJ0p8gPakUDhsQQ
	 NywTqrN39z7A3qhbUC7OC0XhK3+T3Tj3N7zwL29E0/Vx5h8P8xonnJ1lS1UNY3I/Hew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CMUUFowe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B06D606A320;
	Wed, 18 Nov 2026 19:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CMUUFowe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DCC1F000C4;
	Wed, 18 Nov 2026 19:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031461;
	bh=jq2za8hKFbV0IZu4GipcqHkZBXOiWJlKH7qOgGp9Rbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMUUFowe5eRdXNgfJkXqNKrMUUMzEozmWLIGsFLfPDYwjMGzj4Zidw+OWVqzz1+2+
	 Ss1cdG98NLHjYmRw4EMCo4M9zQ3g0HpzThOXnRRqoZCveHr2oQhf4tG5Bf/9XurRIh
	 oE5TSw7VyG651AhGf2sWUQQ2jXxZ8dHj0p8QGsrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1068/1756] btrfs: fix incomplete iteration over fs state when logging messages
Date: Wed, 18 Nov 2026 15:53:15 +0100
Message-ID: <20261118150052.773703955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 363fd28c02688..62ab46cb692f5 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -40,9 +40,8 @@ static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
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



