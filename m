Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B16A26E6F5;
	Tue, 21 Oct 2025 20:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077405; cv=none; b=HibhE7toeV69/h++Sx3JSAzeX3PbRoomR0SzMvKYxmxvUVn7Nd1DUBXcNGnlTW5MdJEMLvhPp9g5PruPVv/iLzKc+XeaduOF+8Re0lrVnxMF20O0Z/070jKTkju2Y13Cy5bwlMRZM4qjX1x1q6pmYUI6vvruOVQAcqMkc5qpqlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077405; c=relaxed/simple;
	bh=bHctqq02osBEGEv5mrDuVGAqNPkW1x43ncoTaDG+KkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekcQsbSD/udfJSJpYxHKi+hTuXVknzvV0p6YCYadfZiUy0eL7BtELVAfEqEyyjHrjpqTUAHjqcg8H+X1GqAUzJibSQbfUAGbYZMX0+PYLTtX/KtRJpn4uPlXEV1uwpyhjh/4JcxvNmrg0jR5eQ3WeflVzuKcSpXoX1M3HV/Uyrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvVNQcVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvVNQcVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D6EC4CEF5;
	Tue, 21 Oct 2025 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077405;
	bh=bHctqq02osBEGEv5mrDuVGAqNPkW1x43ncoTaDG+KkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvVNQcVR/NHNvC8ANW0v0TSOBTU5AI3HzKrdHeDXYUror4QPlsn4/fQmzfvW4MFnb
	 ChV2CO/U6DVeoWeytmvlvMYySsnHC4oxhwTM66KD6nhIamOmxS7fuE3Fmj5nN0IhP+
	 9FcSc8po+MsOZTBbaNz3h8JdP3/TzCyvQjq1PhFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 096/159] powerpc/fadump: skip parameter area allocation when fadump is disabled
Date: Tue, 21 Oct 2025 21:51:13 +0200
Message-ID: <20251021195045.493162321@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 0843ba458439f38efdc14aa359c14ad0127edb01 ]

Fadump allocates memory to pass additional kernel command-line argument
to the fadump kernel. However, this allocation is not needed when fadump
is disabled. So avoid allocating memory for the additional parameter
area in such cases.

Fixes: f4892c68ecc1 ("powerpc/fadump: allocate memory for additional parameters early")
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Fixes: f4892c68ecc1 ("powerpc/fadump: allocate memory for additional  parameters early")
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251008032934.262683-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 5782e743fd270..4ebc333dd786f 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -1747,6 +1747,9 @@ void __init fadump_setup_param_area(void)
 {
 	phys_addr_t range_start, range_end;
 
+	if (!fw_dump.fadump_enabled)
+		return;
+
 	if (!fw_dump.param_area_supported || fw_dump.dump_active)
 		return;
 
-- 
2.51.0



