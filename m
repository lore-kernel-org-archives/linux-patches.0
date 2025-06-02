Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0BE21CA1E;
	Mon,  2 Jun 2025 14:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874748; cv=none; b=iKiC9Nc+bNlPF1V82GOJaKQKGE4nOyDDBnR0IpWtRZPAT0ljVvJUOK+p3AK3Wh6W5IAMKC/3OrzzQo6c4fP9IQC+TVGbXthemvY1YwyztJ8Zi4Ie9Kjq05tGJV97Sa4exrGy3a9Xp/vibIJ7Zx4O66uHR7je3exyjOBS/1AwAd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874748; c=relaxed/simple;
	bh=6XVprKv/I3Og6Y+eNsr7uVHmpC5bMW2amgNZVFIOq0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wd71ypbFcjBrK6+tDj1vu7tORj+YZ8HkITbe87SgYolT6mzo3DGek+0MKhHcHNIZQ7vN2YtAgK5nC/JqUSRDo4Tm5SqzkxFHD33tZH+L15xar9mH33YuTAbwmoZtO4l72mB/sp51vWce9qEruTE4DHPoh2fU0NjdQB3bzh5Us+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0vhZihy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0vhZihy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF3BC4CEEB;
	Mon,  2 Jun 2025 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874747;
	bh=6XVprKv/I3Og6Y+eNsr7uVHmpC5bMW2amgNZVFIOq0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0vhZihyoh3u4qSLtC9sHuDYk6udPrY6WuF30/3JMslcvdWANsbxdMJR6tHq0AZfP
	 fq+cOcO1sCJAEsDyHmRJQ+NzqV3K2cBRuqGOf/M3qFl0IFy2F5h2XbLJmgsDtTEAlf
	 NyEW1O3Z9Y/FcMnghXFFTcJ9wrmxCPQy6ry5WnZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/204] net: pktgen: fix mpls maximum labels list parsing
Date: Mon,  2 Jun 2025 15:47:36 +0200
Message-ID: <20250602134300.481186009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5e9bd9d80b393..e7cde4f097908 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -805,6 +805,10 @@ static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
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
@@ -816,8 +820,6 @@ static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
 			return -EFAULT;
 		i++;
 		n++;
-		if (n >= MAX_MPLS_LABELS)
-			return -E2BIG;
 	} while (c == ',');
 
 	pkt_dev->nr_labels = n;
-- 
2.39.5



