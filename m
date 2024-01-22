Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31BD4F207;
	Tue, 23 Jan 2024 00:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970437; cv=none; b=AZ+hIO343JLPENO5PGfH3Pi7OyxOi2jHC7i+ZqVTuf+Wp2PvR5d+swTiq7+mhnrizkEFJYEb6R0ZSCsxrSpzQ62foWSNo2mPHn7Unq3k5I5cZ5whdPomp2BLNnsWk8w/zXVwQxFkppHiTK4P+1DqmVVsLxUBfJxwokeDxiIuo+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970437; c=relaxed/simple;
	bh=WWJd/GShoHhV5YJzAgSuwexsRDcJJ8TOxsyyzoRBAMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Te+ugtVbPuKjY+lsEJmvzSlr2rL8JpO7gkGybv4cbXIU8aFYen4S+fBST/EkjBpo7SAJn52bBDgU4C1513R/4YA8yD6pfWb6xz/vP2iT+2KjvOUFbPwuxupJqyueRjl7M15mhaYRsFBg9fh4AqHdanGI4b7ba4SdpdN+LQlLN9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xcg37iRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xcg37iRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCECDC433C7;
	Tue, 23 Jan 2024 00:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970437;
	bh=WWJd/GShoHhV5YJzAgSuwexsRDcJJ8TOxsyyzoRBAMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xcg37iRQeXm7lVU/vrU6+y8QsoA6MNRgxAQcJDSQMPZ72ACV28Srovq5RyXJS+VFc
	 h39nYluOHjd+Cx/YLnYEENyTFzE4x9idGj5NPMAVLvAXaI7qhOsDcyQBmm8a3rezfj
	 tOPl2r6JJvbIuTRU+WLoAMQI/VKWBAjXveITOUxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/417] x86/mce/inject: Clear test status value
Date: Mon, 22 Jan 2024 15:52:50 -0800
Message-ID: <20240122235751.571079296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 6175b407756b22e7fdc771181b7d832ebdedef5c ]

AMD systems generally allow MCA "simulation" where MCA registers can be
written with valid data and the full MCA handling flow can be tested by
software.

However, the platform on Scalable MCA systems, can prevent software from
writing data to the MCA registers. There is no architectural way to
determine this configuration. Therefore, the MCE injection module will
check for this behavior by writing and reading back a test status value.
This is done during module init, and the check can run on any CPU with
any valid MCA bank.

If MCA_STATUS writes are ignored by the platform, then there are no side
effects on the hardware state.

If the writes are not ignored, then the test status value will remain in
the hardware MCA_STATUS register. It is likely that the value will not
be overwritten by hardware or software, since the tested CPU and bank
are arbitrary. Therefore, the user may see a spurious, synthetic MCA
error reported whenever MCA is polled for this CPU.

Clear the test value immediately after writing it. It is very unlikely
that a valid MCA error is logged by hardware during the test. Errors
that cause an #MC won't be affected.

Fixes: 891e465a1bd8 ("x86/mce: Check whether writes to MCA_STATUS are getting ignored")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231118193248.1296798-2-yazen.ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/inject.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 12cf2e7ca33c..87c15ab89651 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -747,6 +747,7 @@ static void check_hw_inj_possible(void)
 
 		wrmsrl_safe(mca_msr_reg(bank, MCA_STATUS), status);
 		rdmsrl_safe(mca_msr_reg(bank, MCA_STATUS), &status);
+		wrmsrl_safe(mca_msr_reg(bank, MCA_STATUS), 0);
 
 		if (!status) {
 			hw_injection_possible = false;
-- 
2.43.0



