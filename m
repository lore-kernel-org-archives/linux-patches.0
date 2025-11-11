Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF69DDAB;
	Tue, 11 Nov 2025 01:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824479; cv=none; b=D/OKtLEbdWtOEmcr74V2Ndn+C/8akdJUoJJlMxgfu0Ov79yQwe0w1owguJYFTlpDxDNZ/OoLDit+X/Xl8Pg6l568WdzaIZp2AT7J9FS6YrAQ6f78wo/fMvU9a0gmi5O7BOD8YE2X9I5dUZHO6drvDR/q7q/W1COECRG2Ji18mEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824479; c=relaxed/simple;
	bh=yl/xIZ1cSLuolNgL6pSE3LWnaH/9AB/bn2pOz2msM6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMeC7MsxiRYYMD7LpGKODFRohR16zqYDaxNheGy4I/wWP0g1q2qbiXsGSNNQAlg19buKihOUmhVq3NlyxAOvU4dWZVGOEJ2G+EOeT+NoHNmh0Sdvkj10dJ/FAMM8/nw2An8m05pS3F2TmMt397PXo/5xs6FqabWwhifyR6oqmdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGAXGWDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGAXGWDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADDAC4CEFB;
	Tue, 11 Nov 2025 01:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824479;
	bh=yl/xIZ1cSLuolNgL6pSE3LWnaH/9AB/bn2pOz2msM6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGAXGWDFXV7TE2VedGqiQQowxP7z+QkVG9GPBf11uTlkPdUYau19GaiXwCvNm9X90
	 gi2FKoM+IxnRzR0I2tKXyhNvTCa3Lg9buzT/NUm2oUVIK4t3sb0DMA4oczJESU9L53
	 cVwOcMzYnSmX8s/zNXJGUSuG3yaiX0sZIHeChUyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 508/849] drm/msm/registers: Generate _HI/LO builders for reg64
Date: Tue, 11 Nov 2025 09:41:18 +0900
Message-ID: <20251111004548.710207047@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a409404627c71..6a6f9e52b11f7 100644
--- a/drivers/gpu/drm/msm/registers/gen_header.py
+++ b/drivers/gpu/drm/msm/registers/gen_header.py
@@ -150,6 +150,7 @@ class Bitset(object):
 	def __init__(self, name, template):
 		self.name = name
 		self.inline = False
+		self.reg = None
 		if template:
 			self.fields = template.fields[:]
 		else:
@@ -256,6 +257,11 @@ class Bitset(object):
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
@@ -620,6 +626,7 @@ class Parser(object):
 
 		self.current_reg = Reg(attrs, self.prefix(variant), self.current_array, bit_size)
 		self.current_reg.bitset = self.current_bitset
+		self.current_bitset.reg = self.current_reg
 
 		if len(self.stack) == 1:
 			self.file.append(self.current_reg)
-- 
2.51.0



