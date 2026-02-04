Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BB440FDAE;
	Wed,  4 Feb 2026 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216723; cv=none; b=elxZtURvD8FvaX5+IRmSXlNf7nVUZvnzSIswDcXNnDJzSjyBKdIIl8JpY8rLg8WauN9tPkkwdJjq85FiaoZttafCZeM3hA2GcKKMigh0PtRlKekL3+nALkQRkKX60OtJEP0vEAAvoxhhSgM50QWQ9o7k29fvTVUEy08mzIcxzTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216723; c=relaxed/simple;
	bh=RObSv1kbm24+W/+NSLXk4gr8NgmYK52HsHr3sDB3PEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abxnl6lFU5wjmFwuPJMxXpoFn+E+QUDalqF8sP9kp7R2PQutVI9DTu4ZGZ6jHZmHVXCyoNMiQbwz5fKRyagt9FsUX5wG1T00fF9J4q/jjc7zrMuUOW+pSMEx9vgqds/xvKYWfQwTLDWtCtc0c4RxwYOSzhKz67aXUMMImgb0aw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxUO/s8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxUO/s8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88501C116C6;
	Wed,  4 Feb 2026 14:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216723;
	bh=RObSv1kbm24+W/+NSLXk4gr8NgmYK52HsHr3sDB3PEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxUO/s8iGuvK1HvlmNtGvdeWVLn+IUfjzwmYuVDONPjSHzUWMW+6gJ/maoOYhiy9z
	 VOr8fWKIGMz7LRhebN/ZwnZTFZh2owPyjrCfou4BbcVbM7jTHkL414T+OqWYL5pOti
	 rSLONCNTmgFXXC6vL7z6hAsFB/AOFPPaLkbIht7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nimrod Oren <noren@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/206] selftests: drv-net: fix RPS mask handling for high CPU numbers
Date: Wed,  4 Feb 2026 15:37:23 +0100
Message-ID: <20260204143858.647192480@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit cf055f8c000445aa688c53a706ef4f580818eedb ]

The RPS bitmask bounds check uses ~(RPS_MAX_CPUS - 1) which equals ~15 =
0xfff0, only allowing CPUs 0-3.

Change the mask to ~((1UL << RPS_MAX_CPUS) - 1) = ~0xffff to allow CPUs
0-15.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260112173715.384843-3-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/toeplitz.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index 8ce96028341d5..09771d61ea344 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -471,8 +471,8 @@ static void parse_rps_bitmap(const char *arg)
 
 	bitmap = strtoul(arg, NULL, 0);
 
-	if (bitmap & ~(RPS_MAX_CPUS - 1))
-		error(1, 0, "rps bitmap 0x%lx out of bounds 0..%lu",
+	if (bitmap & ~((1UL << RPS_MAX_CPUS) - 1))
+		error(1, 0, "rps bitmap 0x%lx out of bounds, max cpu %lu",
 		      bitmap, RPS_MAX_CPUS - 1);
 
 	for (i = 0; i < RPS_MAX_CPUS; i++)
-- 
2.51.0



