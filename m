Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B312327A133;
	Tue, 27 May 2025 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367169; cv=none; b=Cm4ckcfB2BWYRwGZyHqCDjawkp7fLQ3AJwbHCLQvWVFwrLCSqfYKkpqEubfJ9rZ5QJgQu0io18vIIHPOgpFyFsKY9CmMoW312beuKfkoHJOkiB7/Lpqa2mWwlAQbXeP5Z4KfgDd4XW7F16TVxspmADQMae8vc1YqyHdz0g4YU5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367169; c=relaxed/simple;
	bh=TWvnfMGuarBlJuIfGrYhyFbFzbqWFua2uTwOHvCsbjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON4wWtbMy46zIcfSb1znM9EBYsZR02Dp/Vi5me17fqlQoh6H8NMt6KC/W4XSLyA9tEWQYjjoKrDMmosh/PHi6hOC3LTupDYc900kooXO8UOgSYBDmGJyPn2bCKpdV0xGQpnjz3wC4g8ULalcLxtVg2NO5mvDVDx5nyhwYuDWZpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UybeatX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UybeatX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BEFC4CEE9;
	Tue, 27 May 2025 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367169;
	bh=TWvnfMGuarBlJuIfGrYhyFbFzbqWFua2uTwOHvCsbjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UybeatX1L687kIipTYQqN2RvD5/TasGW5iSE2yeuzPukVLifDIqIzi+3MHdk191xM
	 V9CGmgMGyxN0n9D6tbe5xzpk/x+sEfHOdjCXN7JTW8g1sv11N/sH/zWchTfV8TFfp3
	 PlKTLsDw/6bMo8LoJZ2aaR4bGllvzk3NqHUCLaA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 300/783] net: pktgen: fix mpls maximum labels list parsing
Date: Tue, 27 May 2025 18:21:37 +0200
Message-ID: <20250527162525.291259073@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Seiderer <ps.report@gmx.net>

[ Upstream commit 2b15a0693f70d1e8119743ee89edbfb1271b3ea8 ]

Fix mpls maximum labels list parsing up to MAX_MPLS_LABELS entries (instead
of up to MAX_MPLS_LABELS - 1).

Addresses the following:

	$ echo "mpls 00000f00,00000f01,00000f02,00000f03,00000f04,00000f05,00000f06,00000f07,00000f08,00000f09,00000f0a,00000f0b,00000f0c,00000f0d,00000f0e,00000f0f" > /proc/net/pktgen/lo\@0
	-bash: echo: write error: Argument list too long

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 82b6a2c3c141f..6ea34c95179f4 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -898,6 +898,10 @@ static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
 	pkt_dev->nr_labels = 0;
 	do {
 		__u32 tmp;
+
+		if (n >= MAX_MPLS_LABELS)
+			return -E2BIG;
+
 		len = hex32_arg(&buffer[i], 8, &tmp);
 		if (len <= 0)
 			return len;
@@ -909,8 +913,6 @@ static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
 			return -EFAULT;
 		i++;
 		n++;
-		if (n >= MAX_MPLS_LABELS)
-			return -E2BIG;
 	} while (c == ',');
 
 	pkt_dev->nr_labels = n;
-- 
2.39.5



