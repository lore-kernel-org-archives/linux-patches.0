Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CC73CB57B;
	Wed, 30 Sep 2026 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794993; cv=none; b=oWlrgwlyW4igiT5ojXGVpwhvVs9WTTKJBgPSzhknOCmkiBBPMFepEhxb8jTJZkJvJY+2ct01ddrdNADGx4Nin4yBV5zMngB4bR+s4CiQi82aYaR+y0JhP+jYAYr6rinI+z3Cv+f+Q4S0xNbZb3o6Oe1oa55tIeEx+8TBPxGJGDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794993; c=relaxed/simple;
	bh=WsNtl/0ypgP2uTgJelGRlbcgc7IOYipU8M66BRNwJZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Md/YbT6HuPMe0CWKcB7taaDVaC5scBp7MzBbht+PScKrNkP659d+/eskMZhptxdljdjpzJDcUL8iAzsyt3IOHiYH1R0tsGA99BCsX4PRIr4OOTRWcsfbDidqx/n3Ku0P7HhfWq9rTkDlIDrOIIGXehD76EEAMTxUPVaBj5oDdEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpYxMkV/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpYxMkV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCEB1F000FF;
	Wed, 30 Sep 2026 19:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794991;
	bh=9cgXRVhGd1LadSIGYo3Gv8Qye51dmTga2YbFTs82eMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpYxMkV/jrEnvE0jsmf3LCNu4FvDtlPLb1HnZyFd2wQs5ZQ7fZnh84QIv8+jzEz7S
	 Bv3IcuaJFZze90anRpBtdAt2p35cPqqYaDpiXR6/swKrIElF7oNSz0A9T6bKtkbnwG
	 BsphZrDwzxDHg+la0bXuf66aH3hYxB5sL6fexcFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0404/1193] OPP: of: Fix potential multiplication overflow when calculating freq
Date: Wed, 30 Sep 2026 17:18:08 +0200
Message-ID: <20260930152443.170224683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 782802806fc9b..56aa753f7b0d9 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1080,7 +1080,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 
 	val = prop->value;
 	while (nr) {
-		unsigned long freq = be32_to_cpup(val++) * 1000;
+		unsigned long freq = (unsigned long)be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
 		ret = _opp_add_v1(opp_table, dev, freq, volt, false);
-- 
2.53.0



