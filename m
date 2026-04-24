Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A833D6CCE;
	Fri, 24 Apr 2026 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037757; cv=none; b=m8Jhr0H7f2BKkNfvHWW8YSdQ853itU21CQu58rH55h9+dravKVJRqGjIMbpGntqGFUAYcWun27w0/DEnl2YcaCt3lvb4TyUvr8YoHkEZQ1zO1SeSoR+WGZzEe3p1tGdA2bHVRMBR1ZgtCiYtDzql3BXx7736zVnfAxiMax1lc54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037757; c=relaxed/simple;
	bh=oEKuqSovpedAa82Og0h1gepDWiDFBOncZiFE48YLHws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emsU32Il4gkFZ9C7yeieoLr7V4u8BoRf3JBCV3YalJIBhxHKaHMSZ0cQOHlcMdsLUj61z+GIEYomsw0RoVXj6hQqouMEfSrapkEI9YfOzPlg2kj+whPUcr56YW/r53R8MRMjTBMNVlB27YkvG1N3OEy9oxMpaTvUItxDuCb0GRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unyQ5WPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unyQ5WPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD63C19425;
	Fri, 24 Apr 2026 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037756;
	bh=oEKuqSovpedAa82Og0h1gepDWiDFBOncZiFE48YLHws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unyQ5WPdiHHfaLHp/zPq85S8WUpjRqjfcV/a8/cGeGCk6dcYq/ovIGM5dKwpoWyan
	 z8qZn1TipQwgrY47apVej3u+NwPjOms4D+OQ5HRs++riUo8hV9XkkuEm2JVbznWylC
	 S1SOOMUd2cUq+ljhCzsM9+uMJAKvFWmO0UsKk7vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/166] net: ipa: fix event ring index not programmed for IPA v5.0+
Date: Fri, 24 Apr 2026 15:29:32 +0200
Message-ID: <20260424132544.935742409@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 56007972c0b1e783ca714d6f1f4d6e66e531d21f ]

For IPA v5.0+, the event ring index field moved from CH_C_CNTXT_0 to
CH_C_CNTXT_1. The v5.0 register definition intended to define this
field in the CH_C_CNTXT_1 fmask array but used the old identifier of
ERINDEX instead of CH_ERINDEX.

Without a valid event ring, GSI channels could never signal transfer
completions. This caused gsi_channel_trans_quiesce() to block
forever in wait_for_completion().

At least for IPA v5.2 this resolves an issue seen where runtime
suspend, system suspend, and remoteproc stop all hanged forever. It
also meant the IPA data path was completely non functional.

Fixes: faf0678ec8a0 ("net: ipa: add IPA v5.0 GSI register definitions")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260403-milos-ipa-v1-2-01e9e4e03d3e@fairphone.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/reg/gsi_reg-v5.0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/reg/gsi_reg-v5.0.c b/drivers/net/ipa/reg/gsi_reg-v5.0.c
index eac3913297c27..cbc7cd5b34f31 100644
--- a/drivers/net/ipa/reg/gsi_reg-v5.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v5.0.c
@@ -28,7 +28,7 @@ REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
 
 static const u32 reg_ch_c_cntxt_1_fmask[] = {
 	[CH_R_LENGTH]					= GENMASK(23, 0),
-	[ERINDEX]					= GENMASK(31, 24),
+	[CH_ERINDEX]					= GENMASK(31, 24),
 };
 
 REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
-- 
2.53.0



