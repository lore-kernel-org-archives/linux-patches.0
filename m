Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB857239567;
	Mon,  2 Jun 2025 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873472; cv=none; b=Mrz8F2aaePKxlIOPT9XRDrUpZXmA+LV0jE013M4uo5+XO9s2iRgXNMzwraKwBpx184BlqhVXP0xiH61OBNOQihmdqGstpcXyfgZUcn2VosXEVXK+FsKDJKBtbFbd/SrCnvsaVMxY8+gMcInJ31jITaAgp5sRx5kSIXsSY+tXo1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873472; c=relaxed/simple;
	bh=MhM1MJw85gqixzk9gCuOd87L2l03EfqBWjLG4VF2zAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmKtbBWJxf13LXkir5LdrVOg1uA9ytiSLAFt4tEtGZwWpZ4eGUOn+Px+AwmMHVkPagLPQZ5FrcdzzR8Hq0TmSr4X+y4bPC7kTL3rAeOq8kPq3hy+WJ8cRGFWU/46xcx5ID6SUpBFNngGeuvXO/AVW7mainJWaQONQ9c7WK0NCvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fpw3K1Wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fpw3K1Wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C270C4CEEE;
	Mon,  2 Jun 2025 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873471;
	bh=MhM1MJw85gqixzk9gCuOd87L2l03EfqBWjLG4VF2zAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fpw3K1WpuqK7EpYEwlavXRdGDOthwh8n6EMGXQrdPmoNPZd5/nQ4rzvrR4HL3lnht
	 zC96uEjWh6dnKMZ0I9rUl4CQOhGraZwPzCzGsOjvIZaCu8sZSQtyyGl30nsj1eJoYL
	 wvmJ7QPmHTerCLrslUdmYi2Bl6Itb81BfLG62LJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/444] net: pktgen: fix mpls maximum labels list parsing
Date: Mon,  2 Jun 2025 15:43:36 +0200
Message-ID: <20250602134347.079392900@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 359e24c3f22ca..1decd6300f34c 100644
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



