Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9026E358D27;
	Thu, 17 Sep 2026 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658792; cv=none; b=q+lB5Ci4gPkd+I0EIniRpavyu1n/C+XmzMlMRejXKbohoMMuTAAnL7bh3ybKntvbKXOUHcVhH3ydIla6I3MABwe/U6Gw7V7A7pyN7mRQIA5/FKYfQmX2MiNkIgZtdBvmp6NSd/mZeLIIdj6EuDKC+tCwT8xHx8ZX8QLsdcfivDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658792; c=relaxed/simple;
	bh=ZgKzprobOHX8PK6vhbT7tg3re602vmP4EBMolI9QK6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iwy5j+Yy7KbOOZu8beq8mRFxWy+641ofzQA4Eq/qh0B59CCKAMR2XM5a/mfGZ+vUOuLXK+k9EI3fTwhTkUyQhIrgLppTTzDsd9azdOxN1gz2aTsuuVRkAtTWO7NNu6o52IV7wMfMguegg1hAcGgO1GsaB2Il4mGvmFbQFzNHJHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vq1b5Ysk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vq1b5Ysk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BA01F00893;
	Thu, 17 Sep 2026 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658782;
	bh=pSLvYxQduFw+HnCN/hsdq8Pe7hJzY3sZ+C3M/Ci/dj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vq1b5YskBl/++CBPjfo+PU9WCekpgeT4ZfTDnuy0ALZlvpqki/M0K5noQcGa6NeB/
	 +AwrxTuAJQSoc+lbhD6ujxOrw67NoMiUKv1BZb0vNQV4hU9yA3jH1gLsxknZdE2BqB
	 vgOLPHnRUDr7mb9m5gTo+ALrYu+/XDzLe547C3hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 007/733] EDAC/igen6: Fix interleave boundary condition
Date: Thu, 17 Sep 2026 16:05:15 +0100
Message-ID: <20260917151350.816020829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f1fc20d4ebf61..43b56a2eb5479 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1035,7 +1035,7 @@ static void decode_addr(u64 addr, u32 hash, u64 s_size, int l_map,
 {
 	int intlv_bit = CHANNEL_HASH_LSB_MASK_BIT(hash) + 6;
 
-	if (addr > 2 * s_size) {
+	if (addr >= 2 * s_size) {
 		*sub_addr = addr - s_size;
 		*idx = l_map;
 		return;
-- 
2.53.0



