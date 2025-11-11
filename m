Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6058262FEC;
	Tue, 11 Nov 2025 01:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823837; cv=none; b=V0FhEtsFL/3Tn3GR3nQd6ArMIprFjJw2jAi6nZQm1InembKla6Zm0ytPHSrjCAsPG78BPeMpV3FG0o2NT0xbe/pUUtnbCLncmyCowVesEXgyRxRcX3S5KfWJQK99dDQoMV5jPt7AM8c1TFQjMh+BRzWS427eUbR4P2olcEzBe58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823837; c=relaxed/simple;
	bh=QkL2A1Sv8kMrPuLreNvYw8Qfaqv+C8zaaXeFDFEPxiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALtEFnf8psTugXAIBLfpzk6/L+4SQIutZtyI6Loju/PNZVfPyld7TFjlFNxVEBSfT+kQimhAWw7MfWgr75/K1HDjIu8XM1nRjeEz97SN6P4jQ9s5H9oeWbXG6voJahEPu74A0X4MbqVexpCklxhJXQH79dDYSsk35mXfSj9nMX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY+1QdEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY+1QdEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4892DC19424;
	Tue, 11 Nov 2025 01:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823837;
	bh=QkL2A1Sv8kMrPuLreNvYw8Qfaqv+C8zaaXeFDFEPxiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PY+1QdEY4DTLud4G9J75UbIyBLfDZYzND73O0/RVzwYKqaq3dEbUK/6ONZe9ZNQgR
	 /3Tpj3TY7D+qusChRU3LLlEIMgp1rTqVSLDINN5Jjdo8/CxmHg5DdlLkUB7u/UxHOz
	 2rFredclVxJ3rco9Ila7nOgAybZi6F0CtRwyqKXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/565] drm/msm/registers: Generate _HI/LO builders for reg64
Date: Tue, 11 Nov 2025 09:43:10 +0900
Message-ID: <20251111004534.395035048@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 60e9f776b7932d67c88e8475df7830cb9cdf3154 ]

The upstream mesa copy of the GPU regs has shifted more things to reg64
instead of seperate 32b HI/LO reg32's.  This works better with the "new-
style" c++ builders that mesa has been migrating to for a6xx+ (to better
handle register shuffling between gens), but it leaves the C builders
with missing _HI/LO builders.

So handle the special case of reg64, automatically generating the
missing _HI/LO builders.

Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/673559/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/registers/gen_header.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/msm/registers/gen_header.py b/drivers/gpu/drm/msm/registers/gen_header.py
index 3926485bb197b..812eb89a224a6 100644
--- a/drivers/gpu/drm/msm/registers/gen_header.py
+++ b/drivers/gpu/drm/msm/registers/gen_header.py
@@ -149,6 +149,7 @@ class Bitset(object):
 	def __init__(self, name, template):
 		self.name = name
 		self.inline = False
+		self.reg = None
 		if template:
 			self.fields = template.fields[:]
 		else:
@@ -255,6 +256,11 @@ class Bitset(object):
 	def dump(self, prefix=None):
 		if prefix == None:
 			prefix = self.name
+		if self.reg and self.reg.bit_size == 64:
+			print("static inline uint32_t %s_LO(uint32_t val)\n{" % prefix)
+			print("\treturn val;\n}")
+			print("static inline uint32_t %s_HI(uint32_t val)\n{" % prefix)
+			print("\treturn val;\n}")
 		for f in self.fields:
 			if f.name:
 				name = prefix + "_" + f.name
@@ -619,6 +625,7 @@ class Parser(object):
 
 		self.current_reg = Reg(attrs, self.prefix(variant), self.current_array, bit_size)
 		self.current_reg.bitset = self.current_bitset
+		self.current_bitset.reg = self.current_reg
 
 		if len(self.stack) == 1:
 			self.file.append(self.current_reg)
-- 
2.51.0



