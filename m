Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BE219D086;
	Thu, 25 Jul 2024 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918409; cv=none; b=Rh9NQjvd0RoetRZ8ev2THKEhNASBNxbphvE95ugsy5EWerBHhBsk7PTK91ooD1NesOG00TA0d+z7alUa051SaW3Bwhl950UaymQN5Zl/+VUf2qmZls6fFFmWJ8TzgM2XGT7Y5YRRxus9m0Q4QzQ3xXbmui6+Plw4gpntwCaPf7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918409; c=relaxed/simple;
	bh=HHiUoIi+lm0J6UI6pVAuxLAaV/lRPoStukUg4DnK2nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2qHsug86d3HEgMRfAH/jGv4A1Py5XiHTk961KmHNbsRCSL+UeMp6p232ANvhExYQMsiT5n9HSpaQTB16PMzzHZ/YL8syhrNmZqrW0XnpU7Skr5nFbuXWKE3nSZNPjujuzAeczLICGeOuIZrPbqSxAtU4fixqn5rnj7g1SrpLW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUT2uX31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUT2uX31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06CDC116B1;
	Thu, 25 Jul 2024 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918409;
	bh=HHiUoIi+lm0J6UI6pVAuxLAaV/lRPoStukUg4DnK2nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUT2uX319RpS4BhcvWHF/JGwUqh9HKEL0wauIBczvU2iMB5wq1ptLe9VTz7kd9QaY
	 mRPhc9qIAMehSrXdiH5l3qCsbIv8Se+fjJ6sLiz9Z1PVfMUGCBuxryWV2zVYW34IJL
	 KC6lWLJ7VjMizA7jSQxPTHC3Sf8E0eWAfQpzbv2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/33] fs/file: fix the check in find_next_fd()
Date: Thu, 25 Jul 2024 16:36:34 +0200
Message-ID: <20240725142728.949161620@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 928ba7b8df1e9..f5ba0e6f1a4c6 100644
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



