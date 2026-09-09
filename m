Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E698562600;
	Wed,  9 Sep 2026 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962202; cv=none; b=AuF7keinaRoPxtGr9O75QMt+xJNvNvbaoeN8N4bDsHdes8BCxg4H5uWaMwRBeIXtOCUmicqc57+9E8jyjzUZi71fLMyCUki18tyPaLMzVy/qPupWJJ2C+RzwwmO78ZAnFdYgtZvkSvWyI7jXJCLflG7kKM/NrngYxRBfmhS9SUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962202; c=relaxed/simple;
	bh=3+7WkHFQefPkTWRA/jO3zvNCiuGnoxaawNjRcJoNZ+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6HcaWBT9vdhM+z915qfPsCkkODU0zAunXeuvILZqB6MMJePDZPA5aG+l9woVWyThujVl0tQaaDpq+0GLupQ38aptWXUWCob7CnN/5tWZBC8Yu3sOE6LkQhUa93scs2B4O9ShG8TOsk5jiVFrvxK/Kiqw0dXSdvx0BCZH3Tp8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eilDLnYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eilDLnYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C170E1F00A3A;
	Wed,  9 Sep 2026 13:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962201;
	bh=NhrbPcqYWCrkkgApukOCru85OzE2im34A/Z1WMSOvzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eilDLnYyY39CoV6gnDtpkBTbFIod7WkdKVTpDHlJmPOST7eFcnLEQ2U/Lna1aHCMN
	 ASS0ZQzCkvXqlqNsqUm9/Xt1l2/MovkETQRcQLS4d2fWuSwl+FftmMugKRciqktsFO
	 +XCHDnqsNxnsqygeiJDCRoLDPvg454wZK2dkGwt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pale=20L=C3=B6bl?= <pavel@loebl.cz>,
	Brian Masney <bmasney@redhat.com>
Subject: [PATCH 7.2 207/556] clk: clocking-wizard: fix integer overflow in rate calculation
Date: Wed,  9 Sep 2026 15:38:07 +0200
Message-ID: <20260909134237.672940062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Löbl <pavel@loebl.cz>

commit 4adf593c6fc5aed4639add011f71a074a1bd3966 upstream.

When using driver on Zynq-7000 (32-bit) determine_rate calculation
overflows. For instance requesting 32MHz with 100MHz parent clock
results in 100000000*(4*1000+0) 32-bit multiplication.

Replace the expression with mult_frac which is already used in
clk_wzrd_recalc_ratef.

Cc: stable@vger.kernel.org
Fixes: 7681f64e6404 ("clk: clocking-wizard: calculate dividers fractional parts")
Signed-off-by: Pale Löbl <pavel@loebl.cz>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
+++ b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
@@ -663,8 +663,8 @@ static int clk_wzrd_determine_rate_all(s
 	d = divider->d;
 	o = divider->o;
 
-	req->rate = div_u64(req->best_parent_rate * (m * 1000 + divider->m_frac),
-			    d * (o * 1000 + divider->o_frac));
+	req->rate = mult_frac(req->best_parent_rate, m * 1000 + divider->m_frac,
+			      d * (o * 1000 + divider->o_frac));
 	return 0;
 }
 


