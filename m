Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFD246D2D2;
	Wed, 30 Sep 2026 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782877; cv=none; b=FKtzDI0kDdTVcfr5dKd6Ug5pDKvc8i1LdhhAtPAFZSyFfhsI8svFZ8h5LSyvEm/CJKpLZQvcRZt1QRSwjBs5ExrbQx5zI4RTm/ZtIook8Tg+JSMjNEoo2Z4sKauo+b1blw//KPcTeGii7qofkCz4qK9H7mtirLWc/MKyYB0fZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782877; c=relaxed/simple;
	bh=GgJ1Dx1xkZZ0JBha4SmCJmd/JeoPtpzfEhfFEdYRydY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFvKNFuim5LPE7/0iWC5vgxOKZgMZ8MPSPRMJ94SJIyLwOpMQxgm8GP0YdAbW/sev9jEx7Un/rOTfT0sSD3tJxpwy7CaxPozeMcbkLe8g/qfj5ZMXJgkbUnxWXXr65opnR5E1Qyc3mNROgwCrGPzNOo+edtmGOiiTow68did4T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iF3sKE9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iF3sKE9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC971F00898;
	Wed, 30 Sep 2026 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782871;
	bh=eUwJ7pjGcxKOv1FA4zewa991GOiVF0v4kdqy+McGeik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iF3sKE9CjM8HeCaA8Zn5Z7FmbmiOrpUCv+qLL6YOuOYcyKyZyzABrDrKgqymmOZbD
	 nls0afXrMQN7aEexCdYpigUDZkleQWu45dXn0f7EBdkELSTMhdgXE13/M2B7N8BC69
	 rqNUPl9Cl5D4dfohvJ49RNvzb/wrg0Tbxj9a17Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/595] OPP: of: Fix potential multiplication overflow when calculating freq
Date: Wed, 30 Sep 2026 17:21:31 +0200
Message-ID: <20260930152351.995606668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit e11811a552252740bd396ec38378e9570ee16578 ]

The multiplication be32_to_cpup(val++) * 1000 is performed using 32 bit
unsigned integers and hence uses a 32 bit multiplication; this will
overflow if be32_to_cpup(val++) is greater than 4294967 (which is
very unlikely at present). The result is assigned to an unsigned long
(which is a 64 bit value on 64 bit systems), so fix this potential
overflow by casting the first operand of the multiplication to
an unsigned int.

Fixes: b496dfbc94ab ("PM / OPP: Initialize OPP table from device tree")

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 3d7adc0de1288..f7df2299a57a4 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -925,7 +925,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 
 	val = prop->value;
 	while (nr) {
-		unsigned long freq = be32_to_cpup(val++) * 1000;
+		unsigned long freq = (unsigned long)be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
 		ret = _opp_add_v1(opp_table, dev, freq, volt, false);
-- 
2.53.0



