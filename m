Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CADB2BE05F;
	Tue, 21 Jul 2026 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649651; cv=none; b=T6ltqytzM6ENDRkAvI+bnOcZw9CPkynfA4H3ure3L+GhBNkIRF0Kee8TCRGhEv+JHMUGGFbhsGzV90ENz/tJ21Eufa+/pje0xT1XdqrRAAzWD3/xc+FojFWNKQKdqU3LvRpqqfQSSEoN+tMN6N31NAjSjvThSErDeo07WIikDB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649651; c=relaxed/simple;
	bh=xI2LSyEw9rnURAvMA9/i0hVlVDzJp+0JTN3eVO4TpVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2LB150OGsteKAH4Uq54XF5scJHkP7+XWWwTiCsKMEcWuHIXSos111vbFj0H0FAsDcgxmEn67iVwlI8d28e1cbjFNZPuLS/kXrUt4OaFOOypVbv96qB1MY00ILDcYrWFvtLQHn5UrJVge4vAl5AofP2cIl/hjQTB5re53U6XwDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0HCv64O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0HCv64O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E921F000E9;
	Tue, 21 Jul 2026 16:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649649;
	bh=oL73RTh/5RMeNip9VjgmmJl7Kvt8CD9wsmX13kwGzr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0HCv64ORemWlGalxdGA7kU5THHlGTQ+GiK5NcKtGpnbBmfRzSQZcieCKwFMG6WLs
	 tfNTe50X2bx0p70UGCeCsp8E9QRh9y6Ud7s8e5BmA2m9D1B6eYScsKDssthAWbFGpa
	 GOLCSwp2DpP12eImaYJMzkA6SX8DD5y5lPw8eOq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0658/2077] of: cpu: add check in __of_find_n_match_cpu_property()
Date: Tue, 21 Jul 2026 17:05:31 +0200
Message-ID: <20260721152608.323920877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

[ Upstream commit 5901eda2ed99ba0d3661da6eb265970559323bb3 ]

In __of_find_n_match_cpu_property(), checking the variable ac for 0 won't
prevent a possible overflow when multiplying it by sizeof(*cell). Besides,
of_read_number() (called in the *for* loop) can't return correct result if
that variable (which equals the #address-cells prop's value) exceeds 2, so
additionally checking for that seems logical...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: f3cea45a77c8 ("of: Fix iteration bug over CPU reg properties")
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Link: https://patch.msgid.link/0c7bf7e9-887c-42d5-bcfb-0ba7fe1e70b6@auroraos.dev
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/cpu.c b/drivers/of/cpu.c
index 5214dc3d05ae17..bd0e918d6f290e 100644
--- a/drivers/of/cpu.c
+++ b/drivers/of/cpu.c
@@ -60,7 +60,7 @@ static bool __of_find_n_match_cpu_property(struct device_node *cpun,
 	cell = of_get_property(cpun, prop_name, &prop_len);
 	if (!cell && !ac && arch_match_cpu_phys_id(cpu, 0))
 		return true;
-	if (!cell || !ac)
+	if (!cell || !ac || ac > 2)
 		return false;
 	prop_len /= sizeof(*cell) * ac;
 	for (tid = 0; tid < prop_len; tid++) {
-- 
2.53.0



