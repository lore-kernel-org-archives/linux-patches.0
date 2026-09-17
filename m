Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382FC39021A;
	Thu, 17 Sep 2026 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658989; cv=none; b=fUP0jnXADHbmeGmezoNvMm0tkvlMY7Ub51CcNRzc4D8MY5ZzR7YdLPowcfq4OIcoAljX26vghOQKRSgYGbPM40gLHtMNtLRVjkxMXSRyh80aueEnHek8zgv0aGtu2dum2ucTpstPkMyTZJxygUss1rkA0c9VEypmbYpi8elYdcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658989; c=relaxed/simple;
	bh=Nv3S14ndQP+qmrvNg+BB4NWxOJu4UhX4I1eZCGxqGtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3PsP1NZynfz8LlQez3RS6BidKheaJWHyphFRNus6zM2BrnRROHC8spN8EH0gDHS6cmlCWPYzrvtTooOiRukLKeUmUImk9MS/nY5BazgEGbuaqeQclP4nUYK+Uf5kFe9ojbZUJLgChLpAjHXHFBCyTM3Gnz2Z0VcdV5RUbSYJYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsDl1PEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsDl1PEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5171F0089A;
	Thu, 17 Sep 2026 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658983;
	bh=FISipWQoKmN+68P+yXFx2hsf9YizvMRV+pSUlDO3xZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsDl1PEmCgW14g26nWbGnk51FSJN9Tf0o78ianMkYWQZqVAJVv8C1jMoCVRhwvgHw
	 nqN61tKfApdfkJd7SVN9QfTonUL74rNcRdZETNcAw34M3I8ydy0X96Cro5ZcAh5KEH
	 WybKZxgtYjrK2SEbcAjwJD9e+p24sbOpa33jh870=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 104/733] s390/pai: Reduce excessive debug feature size
Date: Thu, 17 Sep 2026 16:06:52 +0100
Message-ID: <20260917151353.556479736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 8cff0ac21658fedd4598e9904dd0c518bdaf5856 ]

The pai debug feature is registered with 256 areas, where each area
contains 32 pages. This sums up to a total of 32MiB. The code does not use
any debug exceptions, which means that 255 of those areas are never
used. In addition all existing debug feature calls have a lower level (5)
than the default level (3).

This in turn means that without user interaction the debug feature is
unused.

Reduce the number of areas to 1, and also reduce the number of pages for
the remaining area to 1. Since user interaction is required, the user can
also increase the size of the remaining area, instead of wasting memory by
default.

This reduces the total size of the debug feature to 4KiB.

Fixes: a3f8423622ef ("s390/pai_crypto: Add PAI crypto characteristics table for parameters")
Reviewed-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_pai.c b/arch/s390/kernel/perf_pai.c
index cdb8006220ca0..ab76ed7ad791e 100644
--- a/arch/s390/kernel/perf_pai.c
+++ b/arch/s390/kernel/perf_pai.c
@@ -1221,7 +1221,7 @@ static int __init paipmu_setup(void)
 static int __init pai_init(void)
 {
 	/* Setup s390dbf facility */
-	paidbg = debug_register("pai", 32, 256, 128);
+	paidbg = debug_register("pai", 1, 1, 128);
 	if (!paidbg) {
 		pr_err("Registration of s390dbf pai failed\n");
 		return -ENOMEM;
-- 
2.53.0



