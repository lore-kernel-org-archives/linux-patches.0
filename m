Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5D1579818;
	Wed,  9 Sep 2026 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963637; cv=none; b=abeekTEw+sfrwzNraDgQNdM1VkA6tdRyKGvBnUb1GBb4DBC+t+Vwa7kKrAP1RXftQPlQ/naPnqVKdQFrkC3FnSy4m4T9TJZ4ahQ1QE7dW0H+L1VfxSjqxdYpOlVcRNMtseM3g2YAgWHGzWhNADmwxkF+2WU5QahuihOYD9l8ONg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963637; c=relaxed/simple;
	bh=qOtEw1lgkJCciqpwjPKEDTZ9QL/AmzDuEUTOYijL/Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ynrimc7Ld0+4v9o1C4qalZN9qDitO0UAhgIZoET8Bj+SZnrC+Nei2JJaq+2NyzDl+6UtBj2MQ4XBOoUIlNOEcdIrXXHrSDykNTxZCCSvF7+olZMeKUkMIxLeU/L94U2SSSDazMFYlphW0DhIsHmF9J5dYgue/YAeaYmGWCJq4XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQ6rkA2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQ6rkA2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0D21F00A3A;
	Wed,  9 Sep 2026 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963635;
	bh=O8Gkv29lMvbHZI0m7RJFLBRQ7M20sUl47Ij2n7qDbsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQ6rkA2sa//XBMLZwi1Xh3xBgqmrkD0xtjL9ai1GwG+dW+ytsmceLhlUZRGszeNe6
	 FriFt2qBe63+C0OWSB2/gb6W87oL+Z799pLEygXCaORsC7el/Vaf0BcH8LeCqUK7+p
	 GAawNeFHC4dWs13x8kGam+ClR8oGrXWtusv3Lrrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pale=20L=C3=B6bl?= <pavel@loebl.cz>,
	Brian Masney <bmasney@redhat.com>
Subject: [PATCH 6.18 146/583] clk: clocking-wizard: fix integer overflow in rate calculation
Date: Wed,  9 Sep 2026 15:37:11 +0200
Message-ID: <20260909134243.234783184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


