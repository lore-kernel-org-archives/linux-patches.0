Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576DE2CCC0;
	Tue, 27 May 2025 16:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365137; cv=none; b=JWayV2BPtnJo/8E/ZPDF3NNHfY788unZFQyYCxHoAscjzOEGVBN9KVgtXRrp+kThOY7RJBW7Cw9DOn8hkZBOL51NYVR0HU2vDStEYGhvM8VlAEP6WRLJEn6DNHQyM2CP6zdPvKiWY8JipPGq+P03/yKiv8cxOrluSugYGntF9iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365137; c=relaxed/simple;
	bh=Fmhm0hkxlM0wPHCjYXj7KeS88MybvWFnecKx+/Ep0Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToF1wpkOtohwnR8lcAg064LNkLW4/agksOKmcDdkdvwwc7/vu0zw8S7bnZfKgn9An3xJk5MDg1Nwk/qwb3NdN+fFDrbC4A6LaJF6IOYuNQcUvz4ZOjGs0K8yUkLcF6346i4dHLQA7QdWqp0ewALxTi2r6e2regiDnxCAuBAD1zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzZbK9Rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzZbK9Rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC997C4CEE9;
	Tue, 27 May 2025 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365137;
	bh=Fmhm0hkxlM0wPHCjYXj7KeS88MybvWFnecKx+/Ep0Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzZbK9Rqb99kwtykgt1er13nyF1NvI9n9YBde+TVh4LtQXHtHd80buKC8DxU4IvDd
	 Y66pGPwdWYUW0mKI3wt/6czzzLbjgkYuiSvlKDdUegLs3cBbpr8/f8gCYsg8ehTThF
	 leAf4WwWDBSn9PXZ0j3libRjKVwulLt4I881kMuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/626] net: pktgen: fix mpls maximum labels list parsing
Date: Tue, 27 May 2025 18:22:21 +0200
Message-ID: <20250527162455.091192883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6db4910359bb..4d87da56c56a0 100644
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



