Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9710234B432;
	Fri, 31 Oct 2025 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919588; cv=none; b=pt+BIT1vF6p2TVsZ0nGuiaCOpqmi00Cm1K7vqyms7UEZF8vxZI7UxKlTUtgT2cUWw5MFqGoGNw8EaLnnT9NEkm+Uncv3btXtNXYBPQZXQRrjLTHoD+vjOBAXcVWcpZXPtvLvANFpZ+ExU4iDcw8ll9pEj9hRPWTiOVZgq+FIi8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919588; c=relaxed/simple;
	bh=J2qz8mQDJ99uST/efg7kNYXpKpd7MApw3zCKbn416W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClPZeLX/m9HChTU78zjXSLb2CGWSulgtAIegr+/4Nt+9WNOm/vpw9z0N4WAacRfeVj5YhNZoP4BBCwmYG8woJpCtDRvZnPRBPI6OeQihsZst7g+7eQ0UDWwPA/ei8+wF8ctN+HXKAW17lvPWnrS/f0TDHrnDNAk1+JPJpobofRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bahYHHxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bahYHHxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D7BC4CEE7;
	Fri, 31 Oct 2025 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919588;
	bh=J2qz8mQDJ99uST/efg7kNYXpKpd7MApw3zCKbn416W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bahYHHxXdM1E4/qP87aoUXXXOdQ7wqVTnQeeL/ic5u7LkCybjyYy/VOB2jXv4rREZ
	 bHTTeb585K3VzC2ZOhWDJJo3FFM1TdN7Tdl3ZVahdxx1dye5mWafSs8fzv7/vJVaFZ
	 bGw+GwZuPKciFMGQO2O87eAB6Vnf3xh2xzUrIvqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 28/35] btrfs: scrub: replace max_t()/min_t() with clamp() in scrub_throttle_dev_io()
Date: Fri, 31 Oct 2025 15:01:36 +0100
Message-ID: <20251031140044.319624262@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit a7f3dfb8293c4cee99743132d69863a92e8f4875 ]

Replace max_t() followed by min_t() with a single clamp().

As was pointed by David Laight in
https://lore.kernel.org/linux-btrfs/20250906122458.75dfc8f0@pumpkin/
the calculation may overflow u32 when the input value is too large, so
clamp_t() is not used.  In practice the expected values are in range of
megabytes to gigabytes (throughput limit) so the bug would not happen.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: David Sterba <dsterba@suse.com>
[ Use clamp() and add explanation. ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6776e6ab8d108..fd4c1ca34b5e4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1369,8 +1369,7 @@ static void scrub_throttle_dev_io(struct scrub_ctx *sctx, struct btrfs_device *d
 	 * Slice is divided into intervals when the IO is submitted, adjust by
 	 * bwlimit and maximum of 64 intervals.
 	 */
-	div = max_t(u32, 1, (u32)(bwlimit / (16 * 1024 * 1024)));
-	div = min_t(u32, 64, div);
+	div = clamp(bwlimit / (16 * 1024 * 1024), 1, 64);
 
 	/* Start new epoch, set deadline */
 	now = ktime_get();
-- 
2.51.0



