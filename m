Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5310A1F37D4;
	Fri, 31 Oct 2025 14:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919517; cv=none; b=TZTSqP9MP0CdVAbYk4qg6YKTY2Nwni3rik0g+AN1P3oBZF1fV3oACSQhxnOaM3E0sYLF+E8HaCyoXoxfEp6eTplWFvndDpkz3Dc7xBgD0feMfKiawuiQ8nfZ1hMt/aa6BQq8gMjyie3J1MVWJ2UTXGX45F6hn+ekaRlTqxW+lXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919517; c=relaxed/simple;
	bh=ac6erIoX/ZqJVHOaf2MmiMfWWMypdJDt+TdJwTSXuwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivoRr+YTU0Q/QTtUzPe3uqw4mki2M3lQZjSLAvh/aF5asIu4zHo4BTMndHfb8FM0nO40BrngrJTgpZtLQH9Tf5G26RzV3JwHcJdq9ZTtr0GQl0XlGR3yac/96Skq8Zvyo+dd+hNFz6GWZByBUnKqo91AijNHAw2yLqTc490mTKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+8JmTtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+8JmTtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CF8C4CEE7;
	Fri, 31 Oct 2025 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919517;
	bh=ac6erIoX/ZqJVHOaf2MmiMfWWMypdJDt+TdJwTSXuwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+8JmTtG8FlkPh5WbhXXRFfStYp9k8o0oK+YWKkgmJvYtdFHPC8d2CWxLF5M+m7hG
	 rs6GOQ4VJwC+OSwMVl3hMHD+UxqlSu9EyvabOLl/rdHb+myIEF/OWgmqgC3U1oc3ld
	 v3g/iHHI2uyHP7c+gIRTZr8/lPO9IyWdUyxPnJCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 16/40] btrfs: scrub: replace max_t()/min_t() with clamp() in scrub_throttle_dev_io()
Date: Fri, 31 Oct 2025 15:01:09 +0100
Message-ID: <20251031140044.407132428@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3fcc7c092c5ec..9a6e0b047d3b6 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1270,8 +1270,7 @@ static void scrub_throttle_dev_io(struct scrub_ctx *sctx, struct btrfs_device *d
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



