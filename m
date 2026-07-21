Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A142EBB8D;
	Tue, 21 Jul 2026 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666088; cv=none; b=FG8p08B7InPuuwjrqVttBKIsHchrtEmdPEKFqjnPoxwZc0wjfvVsdKhN2dZPCXk4Pr4ggH05FBsAWHS7fvryMi/3I097eP/FRWT6++touubwhuSNtBr5aLiJ+7imWKTv+CoCMp/E1/mvy516pVljtnoH1k7JQZ2oQlmi91zrGu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666088; c=relaxed/simple;
	bh=nCa1/AuCvBuPB+ypccUvCy2lzdSwyCZLVKJP2HaE0VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4NMpnF5CCq1e186okpS4gcbaDXRIGjkTEuzMPep/LDElWjKFKd6YCLFXa8BF2OzBqw+uO/JAkn6tqbrp/Pks8WHtuWx7ccF2uQRp/g2n2nmf1ZRMYEbe/Iii+wmb9k0frhwOXHNKVZdxraG2rPzRQotna4uHnKRUfIwxc6y2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zp3wOuJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zp3wOuJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5001F000E9;
	Tue, 21 Jul 2026 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666082;
	bh=PuqLjDjyThU6nDDxpuqJhzZCpvkNVSKqIMA9Y3ZQTyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zp3wOuJRm3b36Nvx7OXIgie/xzQp2Mg8yMia4Fb0HGRG/4yzpkb2yH/hLyxzJVWwO
	 xtvPb8uzIA2GYLPMz30rQ4y+SGxjclvwMnYvBemvuscJxWG2PpiRr3Juix4e4i3m4r
	 grAQp+pMvrTJbBiUVJav+ih8hV6auB3bmdS3kGS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0546/1266] of: cpu: add check in __of_find_n_match_cpu_property()
Date: Tue, 21 Jul 2026 17:16:23 +0200
Message-ID: <20260721152454.084566881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



