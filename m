Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CFA331220;
	Wed, 20 May 2026 17:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297805; cv=none; b=YVUHBIRPauuhV9OooEB2POohZSkRbufh/4DjPi7xxignUKy4EN4FYAyCOvTsPRx4YUjh2dcdF2IZuXTv5eAuUb2Fi4tHHTP+V1ScL6SiHB+GBfCPim4IS18ki2clXJoPnBBjuctesoii0VEq/pwLiP+hPFaA+yexRXN7uM+3Fpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297805; c=relaxed/simple;
	bh=TDhkyw+wokx/aOwZXJNxjTgTpG+fIheQfEImLZyW8Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrYi7AsgXjQ+rli1uSha8J7O5yIdF+3OQhqkI1JOuDr05cllGDaqI+b5oMdReXZSXfSh4AMvCoitHV6LuQI3vUhD97G+xqCcL/0c+duD2ZQX2eQwjpRItYYev51ZKX0Ggt/MNeZmqJxCPmtyJZPjYqHjJsBfQGJOvhCT/V9prvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10zkti/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10zkti/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE71A1F000E9;
	Wed, 20 May 2026 17:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297804;
	bh=aLL40Mf3PJCWLLTp3uSf2mOHh8qjAe27KVY/ViMcrXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10zkti/q3BMzXQMgEbKi2fFoCuC02Hnzgae4IJcHogU0m59G+SgOybQeuCG4pDrkh
	 MD8V0u1ZnA46+3DwOcbKs1w+OcMHUl3/AtFhxOdQpSpgTXsCpAP3Mkv16IPkiGstdn
	 N4QIWz1cwlLrk4k6qoFoYrbgSGpIiVUH7XbqHXcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/957] net: ipa: Fix decoding EV_PER_EE for IPA v5.0+
Date: Wed, 20 May 2026 18:10:51 +0200
Message-ID: <20260520162138.195041950@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 1335b903cf2e8aeaca87fd665683384c731ec941 ]

Initially 'reg' and 'val' are assigned from HW_PARAM_2.

But since IPA v5.0+ takes EV_PER_EE from HW_PARAM_4 (instead of
NUM_EV_PER_EE from HW_PARAM_2), we not only need to re-assign 'reg' but
also read the register value of that register into 'val' so that
reg_decode() works on the correct value.

Fixes: f651334e1ef5 ("net: ipa: add HW_PARAM_4 GSI register")
Link: https://sashiko.dev/#/patchset/20260403-milos-ipa-v1-0-01e9e4e03d3e%40fairphone.com?part=2
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-ipa-fixes-v1-2-a817c30678ac@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4c3227e77898c..624649484d627 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -2044,6 +2044,7 @@ static int gsi_ring_setup(struct gsi *gsi)
 		count = reg_decode(reg, NUM_EV_PER_EE, val);
 	} else {
 		reg = gsi_reg(gsi, HW_PARAM_4);
+		val = ioread32(gsi->virt + reg_offset(reg));
 		count = reg_decode(reg, EV_PER_EE, val);
 	}
 	if (!count) {
-- 
2.53.0



