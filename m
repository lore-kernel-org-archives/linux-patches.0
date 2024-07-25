Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D380C13DDB8;
	Thu, 25 Jul 2024 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919115; cv=none; b=p/k8EGmShRGCh0Lln2Gn5YjjKERKEeE/S9X/HU6+uhs02FY1lUxDCn8Mm7GuKOe05wAWMOkZdsAlA/rmMV/s/Unix2HNQccWro50pSVptXQBkED2BZrhJMDYP4iwU2WpNIlX2iDTVHKZfn8KP+Iy3ffmDt2v+QLl3Qd8QxRkIHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919115; c=relaxed/simple;
	bh=rA1cYnL9FUKSHJR9d93QXW8mvmDnP8gZauR0xNlbdIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECSGD1+D1QCz/Lm8r9uuyg88AI29uuFXnFLGKXThTHxgK7SFjjnWnhbP21vusIpqZmYvQZyV4Yo8wb8QOnvCEon8AvJXLErCNVSFIcRGW1eLfIIbx35bB76YfS4fEeFTX2Ju5cTMo/a4mM8MWmK+JM9IB4AY6cMboLfHqfQ55P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJnXJgzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJnXJgzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56614C116B1;
	Thu, 25 Jul 2024 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919115;
	bh=rA1cYnL9FUKSHJR9d93QXW8mvmDnP8gZauR0xNlbdIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJnXJgzhsMyw9L6c34dJFR79qujgqqNs0oOza90aVS8L73rWgwICtYJqC8qS+bJFH
	 l6r4c93Pbfh2E4t0QvvyYE8TwpeuLDEcSL86wVFhXHkAaDt0e8m3/Q+oT5N8erMf1o
	 ObNtWxj6kXNpGfVGNVpuHdfNOTOhCst4bS/+tiGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/87] fs/file: fix the check in find_next_fd()
Date: Thu, 25 Jul 2024 16:37:01 +0200
Message-ID: <20240725142739.498300448@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 69a51d37b66d9..b46a4a725a0ef 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -481,12 +481,12 @@ struct files_struct init_files = {
 
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



