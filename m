Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382BFF519;
	Thu, 25 Jul 2024 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918876; cv=none; b=Out7xXwG7RAyORYNOshhc0mnqH/emz+gpQdRY/pMwpRh52JusrDSWo7/sVAW0yZGzZ5pq+GD87nJ1FAKEvKYBWxOE9CJKmFU+haoEbyDyUdJr8pfHFF+O/7sR6m0pUel3VNIumJdks0ngrMiRW3VfFj0xIJyeE30B4o6R12g3ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918876; c=relaxed/simple;
	bh=2cDdGB8bwx555mFFPogBu8RvHpv+6eZivKIblJSYkMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaCsu/oJaF/O3JVw35Ibs1x6GI80RvwMa7KnZhJVLgXvUCghpwYpViNJxVVN9yBPJnyVq1GboR6lCUCpvLSeyHsQOLmecOZguBRkrgXoQphUWcqmOUbkMLB+fuF6zMOhbxvtY++jyw4UDSDuY1L79du5w8vct9K0cON9wYBueN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ytkv8qv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ytkv8qv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BFBC116B1;
	Thu, 25 Jul 2024 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918876;
	bh=2cDdGB8bwx555mFFPogBu8RvHpv+6eZivKIblJSYkMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ytkv8qv0izINRXQ0Uzim9TYqSC8axiPbL276ey1L5XI36+HBVpllL4LMd7Gv6MuV8
	 RS1zfkonWOW8Et9sWEU5HWATGFY70ceZJGEBpl/U0ceJa21Hxu15mUtOP9nqZag6PW
	 A56QjqqMFEicTUFHFJHTIxEjUg9zCItgqbJOET18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/59] fs/file: fix the check in find_next_fd()
Date: Thu, 25 Jul 2024 16:37:06 +0200
Message-ID: <20240725142733.879506227@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Wang <yuntao.wang@linux.dev>

[ Upstream commit ed8c7fbdfe117abbef81f65428ba263118ef298a ]

The maximum possible return value of find_next_zero_bit(fdt->full_fds_bits,
maxbit, bitbit) is maxbit. This return value, multiplied by BITS_PER_LONG,
gives the value of bitbit, which can never be greater than maxfd, it can
only be equal to maxfd at most, so the following check 'if (bitbit > maxfd)'
will never be true.

Moreover, when bitbit equals maxfd, it indicates that there are no unused
fds, and the function can directly return.

Fix this check.

Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Link: https://lore.kernel.org/r/20240529160656.209352-1-yuntao.wang@linux.dev
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index fdb84a64724b7..913f7d897d2fc 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -494,12 +494,12 @@ struct files_struct init_files = {
 
 static unsigned int find_next_fd(struct fdtable *fdt, unsigned int start)
 {
-	unsigned int maxfd = fdt->max_fds;
+	unsigned int maxfd = fdt->max_fds; /* always multiple of BITS_PER_LONG */
 	unsigned int maxbit = maxfd / BITS_PER_LONG;
 	unsigned int bitbit = start / BITS_PER_LONG;
 
 	bitbit = find_next_zero_bit(fdt->full_fds_bits, maxbit, bitbit) * BITS_PER_LONG;
-	if (bitbit > maxfd)
+	if (bitbit >= maxfd)
 		return maxfd;
 	if (bitbit > start)
 		start = bitbit;
-- 
2.43.0



