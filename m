Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B514C10F4;
	Thu, 17 Sep 2026 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658796; cv=none; b=qGDmgxrZWKZenhftR/Ezof7R0z3xNcN/Ijik9M5XoeJoyN7tgjRsSCPFn7U9tLa842z6npyLqTraQsc18p4YJwr97WSrrNechBbUsOlPE5Ae6zQSB8gia5Hl7PcmvzRq3OJMfzWe7sXR5ZqLHJ6rn4urmR9bvKq0dz6a0zVrNY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658796; c=relaxed/simple;
	bh=a+CMFd99yS0TVrKmIcEaUhJWCBuuWHVLojJ+5iV/d0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP4uo2+5hT6vCEvxq+W7OV5pQMoZFfmd17x00561NSoxz5vagqYQ1n55UbH1Cp1auY7BkgRTiHICrXoIgHVHv2onrhg+Z/4CIJY8ws1En3DBCv0yDcqUZk0zkxImjPkpatwFa8hbpmZqc2hlpeKq09y+jGt9BWpoKUfwnI8CokM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RE4wf10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RE4wf10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7531F0089A;
	Thu, 17 Sep 2026 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658784;
	bh=8aVy6v+MAbw0swqlYbkwCkqzBkq6tCp2zHuu7YZr6NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RE4wf106ELmiTOycyN9Jw3uvwd4lIgBvBpQrHR12/X/qGBlR1gWkqp0qqiYUH2Fy
	 2y2yytbCJ/kBdo4mGqWYMbKkq/gzL38HMeFSJx9cXOgJYOWWGmHi/Ve9MaLaMsBgo9
	 I/uAt7I2fZPiVtonPaKgAe+nOjFexRqO+jaDilj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 008/733] EDAC/igen6: Fix channel selection hash
Date: Thu, 17 Sep 2026 16:05:16 +0100
Message-ID: <20260917151350.845462353@linuxfoundation.org>
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

[ Upstream commit 540b79536f3a89a66c5b6c490110298d43025618 ]

In channel selection hash mode, the hardware decoding logic always
includes the channel interleave bit in XOR operations. However, the
hash mask may or may not include this channel interleave bit. When
the mask does include this bit, the current igen6_edac code performs
XOR on the interleave bit twice, effectively ignoring it - which is
incorrect.

Fix this issue by ensuring the hash mask always includes the interleave
bit, so XOR is performed on the interleave bit exactly once.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260730024238.4096623-4-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 43b56a2eb5479..f1fb644154ae3 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1009,14 +1009,22 @@ static void set_dimm_params(struct igen6_imc *imc, int chan)
 
 static int decode_chan_idx(u64 addr, u64 mask, int intlv_bit)
 {
-	u64 hash_addr = addr & mask, hash = 0;
-	u64 intlv = (addr >> intlv_bit) & 1;
+	u64 hash_addr, hash = 0;
 	int i;
 
+	/*
+	 * In hash mode, the @intlv_bit is the lowest selected bit of @addr
+	 * to be XORed. While @mask may or may not include this @intlv_bit,
+	 * we enforce that @mask includes @intlv_bit to ensure @intlv_bit is
+	 * XORed exactly once.
+	 */
+	mask |= 1 << intlv_bit;
+	hash_addr = addr & mask;
+
 	for (i = 6; i < 20; i++)
 		hash ^= (hash_addr >> i) & 1;
 
-	return (int)hash ^ intlv;
+	return (int)hash;
 }
 
 static u64 decode_channel_addr(u64 addr, int intlv_bit)
-- 
2.53.0



