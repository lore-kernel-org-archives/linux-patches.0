Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C82A131E48;
	Tue, 23 Jan 2024 00:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969098; cv=none; b=lVrfJTAqPiezoYAtaiDfj6VE4PA1gS47omz2MYwCDA3eaEnHUIQ/Se0nlSGZoQVwRWB3QMaEEuP3g+HeICgE9p4DQCU0cjOHA/v1h3Ef1c6QlNlmxlDcmSc54F37crATUO+Gcsl9g5xOPlOzmLFfnAkm62I7PwXDb+vQAkt2XYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969098; c=relaxed/simple;
	bh=yfr8ONk9d8LIjGKT9l5E/wWircZOEynozTz5I+doxD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPX8cIRlj+qn3wt/sLj+DAigJyA1YnhLEwwF8uqHH/nlau7F7dGldrOmrUs+8u3o2IQxY8WiRTRmd1ILCwnHmfp9BGgTsDZ9tj0NFEQsm12tiJI4FTtNnrbJ4feaShoeFfHVzxTUEP9mYpibsbTN3ITTqeS4GJXliwikI/RbS20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjzY6Aqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjzY6Aqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D63AC433F1;
	Tue, 23 Jan 2024 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969098;
	bh=yfr8ONk9d8LIjGKT9l5E/wWircZOEynozTz5I+doxD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjzY6AqcQ13AfSJUsz8p8b3WfMA5+WO4Rr1B8PeDuCcLlwShOSWrhwP9sIFLQRJW5
	 4FBL3I/237qjR1fCD+l6f8lh6J0vVfUpfGUOSfFTWHgTd6VUKqgrvqYLa6ESaolXp6
	 N0ltrAnIyWYJ/gFcDIaFFt35JW0DiFN5M2DseQwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 002/641] x86/mce/inject: Clear test status value
Date: Mon, 22 Jan 2024 15:48:26 -0800
Message-ID: <20240122235818.177099758@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 4d8d4bcf915d..72f0695c3dc1 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -746,6 +746,7 @@ static void check_hw_inj_possible(void)
 
 		wrmsrl_safe(mca_msr_reg(bank, MCA_STATUS), status);
 		rdmsrl_safe(mca_msr_reg(bank, MCA_STATUS), &status);
+		wrmsrl_safe(mca_msr_reg(bank, MCA_STATUS), 0);
 
 		if (!status) {
 			hw_injection_possible = false;
-- 
2.43.0



