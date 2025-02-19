Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455FA1DE2A1;
	Wed, 19 Feb 2025 09:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956726; cv=none; b=FzT2LT3tkVSaKbqRkTa7eYPLC30nKR+5WvN34KLuwCdkOb8ikfVMbRjTvhnCTXqJLdgreX3pxTAag6TWArRqHKAPzaHG8zsK/hqZz35Y008SrkGYgpKIpFllCXpFPhxEbOIGjKz3Zjr6BLPiKlQxdjRJuXJhzL1CvZKJ6KnHDsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956726; c=relaxed/simple;
	bh=wDAJLO5ys4WTBpv5EuapJlA6qQUX0Mg7VRW7h7Y8Z6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZEDjDt6/N7su5OIUxq9yncLxLAJpj56S2eqyWHb0SEIsPbwfApm3odPpQcG7Vfp1Zw3zFYX+9kCIMuZrb67KsF+iyRfkuJs6IjjePm3mlIes27gRmyYarBwf+uu2UT13u+Yxs9fmfm6rmYFgWQwB0LA/hI7zx9wRGrphUSmXgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wa+N8W7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wa+N8W7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F4AC4CEE7;
	Wed, 19 Feb 2025 09:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956725;
	bh=wDAJLO5ys4WTBpv5EuapJlA6qQUX0Mg7VRW7h7Y8Z6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa+N8W7UHN6CYZPDhzrConEmayFBEQH/lqgRs60OeI6mZeBhG2cJrkHKnuC2xCmrx
	 LMpZpeSL49KqzP9ZKwgnWZ6WZnA2jLgAcq62u1QnLPMErIPh0WZXtK3HRApzEtWFjG
	 jSODgOHefwUrt8dkICRzh4DlGI2wupRI/pkuoHno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 277/578] x86/amd_nb: Restrict init function to AMD-based systems
Date: Wed, 19 Feb 2025 09:24:41 +0100
Message-ID: <20250219082703.916542033@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit bee9e840609cc67d0a7d82f22a2130fb7a0a766d ]

The code implicitly operates on AMD-based systems by matching on PCI
IDs. However, the use of these IDs is going away.

Add an explicit CPU vendor check instead of relying on PCI IDs.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241206161210.163701-3-yazen.ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index e8cc042e4905c..8992a6bce9f00 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -519,6 +519,10 @@ static __init void fix_erratum_688(void)
 
 static __init int init_amd_nbs(void)
 {
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
+		return 0;
+
 	amd_cache_northbridges();
 	amd_cache_gart();
 
-- 
2.39.5



