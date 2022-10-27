Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51532AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA706C433C1;
	Thu, 27 Oct 2022 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890524;
	bh=vqT7MTTkao9qOIfSQCsu23yA3AEFuZZ6EBE+rRNjT7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nU6bGXDOQVdWPTWrtoisrGMLzh5kjPs6wc8p08IYGw5AOY4XUl0VhJe0r2LFrEV/a
	 SIrwI/zeYZ1/rcETwN8JVZfiKEmq1yQzFzfrNW+PlEbv4/vlCdzfe9ht2CiO3wiOON
	 6vNfgq0pUbBICuzh8YJltxD4eG8cxg/FoNXoYvLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 09/53] xfs: Use scnprintf() for avoiding potential buffer overflow
Date: Thu, 27 Oct 2022 18:55:57 +0200
Message-Id: <20221027165050.174466188@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit 17bb60b74124e9491d593e2601e3afe14daa2f57 upstream.

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_stats.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -57,13 +57,13 @@ int xfs_stats_format(struct xfsstats __p
 	/* Loop over all stats groups */
 
 	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
-		len += snprintf(buf + len, PATH_MAX - len, "%s",
+		len += scnprintf(buf + len, PATH_MAX - len, "%s",
 				xstats[i].desc);
 		/* inner loop does each group */
 		for (; j < xstats[i].endpoint; j++)
-			len += snprintf(buf + len, PATH_MAX - len, " %u",
+			len += scnprintf(buf + len, PATH_MAX - len, " %u",
 					counter_val(stats, j));
-		len += snprintf(buf + len, PATH_MAX - len, "\n");
+		len += scnprintf(buf + len, PATH_MAX - len, "\n");
 	}
 	/* extra precision counters */
 	for_each_possible_cpu(i) {
@@ -72,9 +72,9 @@ int xfs_stats_format(struct xfsstats __p
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
 	}
 
-	len += snprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
-	len += snprintf(buf + len, PATH_MAX-len, "debug %u\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
 #else


