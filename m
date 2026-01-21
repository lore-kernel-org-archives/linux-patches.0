Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A022E330678;
	Wed, 21 Jan 2026 18:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019536; cv=none; b=a6ekJflGrSJfROngW3bJWnzy8QjlLnPqnH4s6ZuCZcPPj9w6aGZMzyNMDJXxkRmiDxpI1q0q+qBzoxooQqCi7glYTRknP9KmH2bR7ObFAEp+eAlIieolxPJaNSal6LXfxAx0eLYjzjLgUdW4cf62lWic5VF+JcMLXglxe4ljpW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019536; c=relaxed/simple;
	bh=VuaRjIs6Q0TdmTLND/VF2/fIJ/APm6/m7AqbDcUuZBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjaVBQeX3KwvLZpUisvf26XBpeoB/zaZqFfuJb46tcJjJsZ85OExc0Ki+GlnuCdUmM7SYVrycSaxMQw4InKi+6VuEtMhvuxQudmyElG/e7y+9+17s+ceAUqID98jZRKllEbSXaad2BwHl8BVJeSFL9ZZfVXmUFG1S6fxLNt7jZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYgDBVu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYgDBVu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D02C4CEF1;
	Wed, 21 Jan 2026 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019536;
	bh=VuaRjIs6Q0TdmTLND/VF2/fIJ/APm6/m7AqbDcUuZBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYgDBVu580MFbm23yLKmL62g2wSBXzMM5fU6w5KBLMUiGVweasQBqMDQZ/1SkvtJ1
	 Y8TP2H+VjYZHKrJV0cJmRUd3/VltxnA/314I75LMvastLRwLiqL+7viTZRu2tOvoRc
	 EO+scBFuVB7O2xl+v+rg3pOMsFJkDzBIdAzpFKnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nimrod Oren <noren@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/139] selftests: drv-net: fix RPS mask handling for high CPU numbers
Date: Wed, 21 Jan 2026 19:14:43 +0100
Message-ID: <20260121181412.718265812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9ba03164d73a6..5099157f01b9a 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -473,8 +473,8 @@ static void parse_rps_bitmap(const char *arg)
 
 	bitmap = strtoul(arg, NULL, 0);
 
-	if (bitmap & ~(RPS_MAX_CPUS - 1))
-		error(1, 0, "rps bitmap 0x%lx out of bounds 0..%lu",
+	if (bitmap & ~((1UL << RPS_MAX_CPUS) - 1))
+		error(1, 0, "rps bitmap 0x%lx out of bounds, max cpu %lu",
 		      bitmap, RPS_MAX_CPUS - 1);
 
 	for (i = 0; i < RPS_MAX_CPUS; i++)
-- 
2.51.0



