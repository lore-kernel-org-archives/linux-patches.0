Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8CA46A60E;
	Tue, 21 Jul 2026 19:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662103; cv=none; b=BljpK8yjQOfrCbCmI8X7yP5GgRzTuJjD5e5idX5CWkYgRoy0WOECZF92ApACDaTCaUTBCItpM7HQ/9P4e5vZZnGbpZvHqY/ag8+JbAsb1RGuHyFaL4LJFsGa2jYhGvLuqHI6jfTwPKIryixv/AKEl6eCgb8+Q1vvPf9f3ufN8JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662103; c=relaxed/simple;
	bh=hnwwKoYMORMNXFHVtGOjHSajwZaWLx1j+XAmPmwLf9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjHY+jnpdHL9U53SN0vos5KHH6U2Af9Q81A/bLTWm+OryWdeeD9DcvQkBnguwhpV0CKQrcinCJ7VYGWaf2rTOY5VuAxvkjT22G3RTc7PiucXf4nlRRUdS13eH6O3AN1rLcFP9xgjZaD6W61nrplvFj09UvKi2/9Pa6+zEd5qbG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnvgT39N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnvgT39N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B271F00A3E;
	Tue, 21 Jul 2026 19:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662095;
	bh=WAZiZ6egsSza25uIlWYRHfijxuqMbA2CFjtAuaGnSOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnvgT39NbyGDh4rBNGlp24E+dne94rPw8rJoUOE5ffMDAKRCq0NLDNElkt2AX6QQ2
	 H9Uk4IlVo3yLDLrbw6HXIWRIgiYEKUgt/NU7qsl5MI2PR9SQQxj13udh6Hq8fESg38
	 zXFx91Ay3eqWd48xqiTWeSV46BRDtsHeI9zeSMcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0313/1276] of: cpu: add check in __of_find_n_match_cpu_property()
Date: Tue, 21 Jul 2026 17:12:36 +0200
Message-ID: <20260721152453.102118123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index d17b2f851082cb..8b618e8c5ddf77 100644
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



