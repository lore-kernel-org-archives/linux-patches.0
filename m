Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D414F68C9;
	Wed, 30 Sep 2026 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793065; cv=none; b=LrT64vVcOhvh7tRcq3YKkMo5DLL2QfxRJ8LfK3mm3/rNpSvDMqn0PJHQR0QmFMzIqaPsK2Y5Yw+eJt63aVELiFLPcNDLRfPEgB3IsEsw3HnxM7aQXaEDkM4ONspbgJt5N2RcHjYTFaGlTv44xcI9N3F4PEghvSaYhZc50pyBanQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793065; c=relaxed/simple;
	bh=+YUoFwVbTDbvXxmF6RQcZUxLIiJ9q78LtS6OXQTkMUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMi8+O0mMGwG1UHEWFBJGoSEsN2QXVNNN/QCcP7sPi9tt3qIwRxfX1WtfgUAVNf2u3P5l7l9JA3GcdKzgIbcqqLrGHMNRxCajDSNtQsFZ0lwP6Y99eDsPaEfmIVzwZymaDFAI7XUXz7OP0Ieq5uIqqwh5IqKjBpzQyRDTzBmwh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TC/4Gy2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TC/4Gy2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375031F000FF;
	Wed, 30 Sep 2026 18:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793064;
	bh=oHP86Cbw0tM+T86dmGw4cttlgOqmGNgj7UgXoymg6Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TC/4Gy2g4cI6XZXwSRF9coBmzyf8lt4oqHKDL+tJigSlazkg2+TRx0sM6pB6V4Ki/
	 2TqQA9mr23QO/BhzZvvn5STY0u3ZF3YrT8HG3A5fBtpo+NJcRmKLa3mqC6lLabsauY
	 d3kIAmGTbXO45ai8U1H+JP2Wto4sITr+2nif0rRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/395] s390/debug: Fix NULL pointer dereference in debug_info_copy()
Date: Wed, 30 Sep 2026 17:26:23 +0200
Message-ID: <20260930152343.266488393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit 012bfcd5a51082d5a65f096dfb9ca652b5267965 ]

When debug_register_static() fails, it clears areas, active_pages and
active_entries but leaves the area bounds unchanged. Copying such an
area, either by opening its view file or via debug_dump(), makes
debug_info_copy() dereference the NULL pointers.

Skip the copy loop when the source has no areas.

Closes: https://lore.kernel.org/r/20260903132123.12F271F00A3F@smtp.kernel.org
Fixes: d72541f94512 ("s390/debug: add early tracing support")
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 4cbad08453edc..c4db346688ed8 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -346,7 +346,8 @@ static debug_info_t *debug_info_copy(debug_info_t *in, int mode)
 		debug_info_free(rc);
 	} while (1);
 
-	if (mode == NO_AREAS)
+	/* debug_register_static() failure leaves areas NULL, bounds intact */
+	if (mode == NO_AREAS || !in->areas)
 		goto out;
 
 	for (i = 0; i < in->nr_areas; i++) {
-- 
2.53.0



