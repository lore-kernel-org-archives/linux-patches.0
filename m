Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06719224B02;
	Mon,  2 Jun 2025 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876114; cv=none; b=ZgT4LBg/aPLKnQxDXnULDHc15lmwPsMyYeUYEZ/GoLDV3LhxMeWas2pI9HJOpmLnQUBJRLU6qlXX8lbO0+WFXTaLtAvGE/tCbHjFyhVsmCqrPbp8wuTZlZIA/AvtPbkdl3zquctsLVjlS/xXw+Pypz9EMfHjh4JrC7zJRcJSvV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876114; c=relaxed/simple;
	bh=ljlhK/dONrIATNrllhL+grGgYUhWm2Dm5y31957GYLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0QEdRGWQzpbAAzIzZ3B+31xMzN4ZKVw3MJjiu1AonZzSEiW/We+dWzJomMhdD3TRhiORaEvO0ZxQAbt296beqeZ3NK71CkiiR1q5pJGi0iGb5PV3lKNB4JOGmb2Vxb/+jXVwow9vfWipNnv7z9jZ/BYgayqZIcuJX3IxHBrzLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bh8FQqjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bh8FQqjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82904C4CEEB;
	Mon,  2 Jun 2025 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876113;
	bh=ljlhK/dONrIATNrllhL+grGgYUhWm2Dm5y31957GYLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bh8FQqjsTUeWwIUU0wE9Rmwe8fkOXxLR/AsxyBaUpvgeauw9JVe24PMP/mdZqm21J
	 LhbsGhmvxlnuvOE7AU1WGDlIwQDN+94PDmScPq3xbyPrK6Ul1rrcqFZhJjItLhKpNe
	 A1RlEqMFygc1wKejsfk5Bm0d6QRYSWc97uw/lyMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/207] net: pktgen: fix mpls maximum labels list parsing
Date: Mon,  2 Jun 2025 15:47:27 +0200
Message-ID: <20250602134301.675443485@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5d5f03471eb0c..28417fe2a7a2a 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -896,6 +896,10 @@ static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
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
@@ -907,8 +911,6 @@ static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
 			return -EFAULT;
 		i++;
 		n++;
-		if (n >= MAX_MPLS_LABELS)
-			return -E2BIG;
 	} while (c == ',');
 
 	pkt_dev->nr_labels = n;
-- 
2.39.5



