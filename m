Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F662343880;
	Wed, 20 May 2026 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301931; cv=none; b=cNARB5BD/wWZL4C2AbU+v3+Xbmwz9g7d57D7c44KBVwVhmJnub26mnLGssPhjoKCG458KJQNquT4nQvG/L685y3ECe6icVQ1kZytM4KKZlAEMJ1nEGqW+u/1TJszIH+3Z0qADDAZRHWFV3N04nT68e6Ai74CHS02jnW1gMj57OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301931; c=relaxed/simple;
	bh=3BLZkM1mziFASiG8gpar1ruA8/IHWzKORv0v9gE8oK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1f30j7kVdfQis6gsoVmoGBl/c9J7qGjigHGwGb+YQhzhjENrSJWsVrlrbIAv6tihmNYvp+6MV9H3a4qpACaFBjzO54F0o8wkTddsjKXMh+Rw/HpNdZGmerR6zFjccrV3qD2/OqqsHJiIPoRm1aOCOClG3jtTpOATJxN5ODjQmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e60Ihqx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e60Ihqx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715F41F000E9;
	Wed, 20 May 2026 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301929;
	bh=TCa/qVmyubxiy3Jw8yG07yd+4xLqzSZvqiqTmaAqS/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e60Ihqx7EumFZwywAWz4XfHifOSg02/huJtG0ajbY63J1RWAX8s7YCc0cy6s0jq49
	 LFRpQbTlkVPQ9VNcuhUrV8g2m9DXDEbDg8+EVGh4a+I8O50/ODLRjMFe4LOpL7MTny
	 427PsPpSu0xE+QgK4LgQXGcAuTz3bHQEZxTPRWw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/508] net: ipa: Fix decoding EV_PER_EE for IPA v5.0+
Date: Wed, 20 May 2026 18:18:15 +0200
Message-ID: <20260520162100.168504679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 9a0b1fe4a93a8..05157492f99b4 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -2046,6 +2046,7 @@ static int gsi_ring_setup(struct gsi *gsi)
 		count = reg_decode(reg, NUM_EV_PER_EE, val);
 	} else {
 		reg = gsi_reg(gsi, HW_PARAM_4);
+		val = ioread32(gsi->virt + reg_offset(reg));
 		count = reg_decode(reg, EV_PER_EE, val);
 	}
 	if (!count) {
-- 
2.53.0



