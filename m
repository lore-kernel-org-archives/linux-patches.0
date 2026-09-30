Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E56942C513;
	Wed, 30 Sep 2026 18:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791245; cv=none; b=oomyg3YtNaA+Kn9CAdWuS79VyVFDOLAWcGtbG1HpLKWsvGHRTRJ6Mx+WoRQK3xNbjMuEovc6h2F/K8s2P4v1aadtsi3zWItErZkWJjujf4ZsJTz9fWOAYZrlTMcSAVBtYiNewtTbfTvWqwYEcTsuzDtqHkQVUdyMZ2QUkDyrh/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791245; c=relaxed/simple;
	bh=vmFlwYZBWp6dBjWAMI0x8CclTH+BvzhnfBligBDirlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzseZO7ctE23M8+RnUK0qJLRqJMhp+LsCg6KsWlIQdBPRmyBfBJThVNlakP5NlyyH4W8LAtMd/M87eq46OQ2nXE6/JWAtku8lVi3y09gdznJ5bw/MwowOvtaL9+YuW8g/inyyysnn/ryILolVjbtLt8AEjBSPRWtEONkEKeg7Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjJDsNKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjJDsNKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EC51F000FF;
	Wed, 30 Sep 2026 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791244;
	bh=/xFwF5IKyBy01FyfRsAf426B6MTwmKpvvG38R4DA/a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjJDsNKJI+1J0ineZff7DZadPChWXfMPgHz3jmgg9uQqnKbjY55Rg1B/7/8s3XKG2
	 ojJSs+uvOny9reH2MqYSEYrsyDvfzZpex/Vi1+UOesiLqYa9nFURyZe93XaCUGmTi/
	 RG2e7+K2VQYgl/y1JhVQ139/udl1Wxl1fnOBIj/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/752] EDAC/igen6: Fix interleave boundary condition
Date: Wed, 30 Sep 2026 17:21:45 +0200
Message-ID: <20260930152403.349796801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit f4008169bd320eedb9ddf2b39eeb21370ddac278 ]

The address translation logic splits the memory space into interleaved
and non-interleaved regions using a boundary at 2 * s_size.

The current check uses '>' and incorrectly classifies the boundary
address (2 * s_size) as part of the interleaved region. This leads to
incorrect channel/sub-channel selection at the region boundary.

Fix the classification by using '>=' so that the boundary address is
handled in the non-interleaved region, matching the hardware layout.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260730024238.4096623-3-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 0ab8642c4e55a..8201e92714c68 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -493,7 +493,7 @@ static void decode_addr(u64 addr, u32 hash, u64 s_size, int l_map,
 {
 	int intlv_bit = CHANNEL_HASH_LSB_MASK_BIT(hash) + 6;
 
-	if (addr > 2 * s_size) {
+	if (addr >= 2 * s_size) {
 		*sub_addr = addr - s_size;
 		*idx = l_map;
 		return;
-- 
2.53.0



