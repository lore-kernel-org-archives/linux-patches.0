Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC1D199E9F;
	Thu, 25 Jul 2024 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918618; cv=none; b=kw795uAm7qG3sXwwyLlZcXQuH+wbGg/zWCLd1A7JpYY+a14Huk0O1I5Rs8Ga+4S+970uyhan86tvIG8iMSAqWVR4vJ3wDLOLDdGRa/xi35nSTPswwh7ZawH8MjyoiQTTIFdU/5UHQ2fMjLPqHWdbP47vVC8Ma+bJ4m/LF2xjYxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918618; c=relaxed/simple;
	bh=m4J2SlaXEMB32o/Z9GA+bzVDcRx261GVdHLYjAOM14k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqWDfB3kvlB6CgLp8DrE4rOTItwlxin1uvsj0uvt9AYt4/2gewtDk+zyQZvGXbAQAorldus9OhD8H+6KX0LqvRECZanFVG0D0sCygWvsHpJx1prw8zI4qBrA1SGQKaG3u15tlu1SOW5OnREpBJu6kfk2BJtHYLI+dGf2gLXyI2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OI/9TWuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OI/9TWuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD9AC116B1;
	Thu, 25 Jul 2024 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918618;
	bh=m4J2SlaXEMB32o/Z9GA+bzVDcRx261GVdHLYjAOM14k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OI/9TWuImT3LVjrSsfwooQ80kBMk4IcM1c1/JOVcQg/t6udbibmuqxAG5d2j3SIRp
	 13CKxqa61gawV1rZ183n1Vfqi683y5ApmVbWMZBqSR38ymibFV8tdO64g4sNJktv5M
	 3RuJhQXBp96AkIqqn0CCWaDytWKjWlQuay7MOwvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/43] fs/file: fix the check in find_next_fd()
Date: Thu, 25 Jul 2024 16:36:35 +0200
Message-ID: <20240725142730.938979986@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e56059fa1b309..64892b7444191 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -462,12 +462,12 @@ struct files_struct init_files = {
 
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



