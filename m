Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FAA221739;
	Mon,  2 Jun 2025 15:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877003; cv=none; b=lNCKEGxtpob5ClccrqjjvZHPV7/IBTb/KrAFKP5hnMhP2qZZKOTsgwD8FOIn7fiQaPR1RIKPalDkiT+3HZiun6j8UQQoZbc3tB0b4CA4EOWHAFO0JdbKYQgPcjWQLUwkLopOGiHwhMCzmROlQKcpEeiUjNXomHXVwMGLGH66C1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877003; c=relaxed/simple;
	bh=uLMtF0JTyU6AbmWkQ1Xu46IUXv29XEdN5ySME+kDHI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZWfLpHYK8MgLKpZwKjRzfw4p6PF2ALOiwrHWyiPboDHUpHj4bCnrRzgZIAcLqpKDlnKwFxJ8/6A71uFpbNv3MFB9ULqC7BFXOwpR0QXoaoRZnSAM2ZtRnwuu4RpbNcs+SsjM3GRTw4UyVZqU1y+Y6CDrGwm6V83zk/MEY3T3YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOCjzoD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOCjzoD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DAFC4CEEB;
	Mon,  2 Jun 2025 15:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877003;
	bh=uLMtF0JTyU6AbmWkQ1Xu46IUXv29XEdN5ySME+kDHI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOCjzoD0rX5duuMadcEmGqBNRrfVhVbRsB5FFFhXdl78ZAdRUrmW57KPMUJCo88Wf
	 CXR8yMKdBz+SmuZ0eb45tuIqQGVkhahyZxthqhUoGuyTbnwv46mORMVh8rRJIbccep
	 e8ht2na27VSn+qKgeDg7IoZUa4nzHM71olhPa8Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/325] net: pktgen: fix mpls maximum labels list parsing
Date: Mon,  2 Jun 2025 15:46:27 +0200
Message-ID: <20250602134324.295280791@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a2fb951996b85..5917820f92c3d 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -897,6 +897,10 @@ static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
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
@@ -908,8 +912,6 @@ static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
 			return -EFAULT;
 		i++;
 		n++;
-		if (n >= MAX_MPLS_LABELS)
-			return -E2BIG;
 	} while (c == ',');
 
 	pkt_dev->nr_labels = n;
-- 
2.39.5



