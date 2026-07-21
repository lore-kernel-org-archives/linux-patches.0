Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6387472520;
	Tue, 21 Jul 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656623; cv=none; b=O7MSZBHmA8FVA2wszO/xGwzbsP8OHpwGcxvHJy4taU+c+CyfonUWQvB2VHNNqAJmvCAgTL7DKMpKSZvSYVCfBYivzaI74Za6RECkMN5lElIy+omf7PZTTCyxp5oDPJ/n0GQIMF7bWvfgR1sZ1ZWsbK3mnmqMyLOm4w5fgdAIXMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656623; c=relaxed/simple;
	bh=JVGEBo4vvqd8+9lSJ9JYUcKIXb6KW9OUcqevDMjKYjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSM4MWL1n6yD3FngnDK196Lxrj/v8aBi8CKf4n0KjSlFiOMqATb0AAm8u+sSNDT5PrtbEgID7B84eNK1E+ZIg9MSSmfa34fZk9HnEt2ylmuFm9E3w3HZkOKoyUfV7iJbWj3TalDLK/rJ40A16IjMIrWY/hX/5WqTy005x3/CMuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fRv0iuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fRv0iuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0696E1F000E9;
	Tue, 21 Jul 2026 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656620;
	bh=0gxj+zcDepUop3HdejTWjeo56bnIAHRv1kNaHTJy1Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fRv0iufFRDA9TqjdTH66ryl3CLz0BoEJy+40ik4vaitK99wPJyaNxdLyZwzfDjsY
	 LgVtA6l07Yqfq+RN0zYrxYdpae5zSoTIZeeHJ+RDfsQSYcYxObPv2ARNSLhMQJZr3/
	 L7IoCpKjE9I15jJeaAZfjPZhYRdKzEvtGPy+6HT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0455/1611] of: cpu: add check in __of_find_n_match_cpu_property()
Date: Tue, 21 Jul 2026 17:09:31 +0200
Message-ID: <20260721152525.540153298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



