Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18720BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8852DC433A0;
	Tue,  7 Mar 2023 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209536;
	bh=g+BuVrnphDbyp4L4O2qBX1/9pq68NrGBG3v0HVcmUnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kujom+PDffBvdBEsIwlwVwGqEmoWkXc9xM3EsSDzR3cKAmqc+Oq2RnkzFf5N/S5Gy
	 W0J/Y4GP0Z+y4cpYEtUY4Y88U7OgBG3aV3dPxFb7sJnamjAcUvAdSGLiOkSHyoI2Cf
	 xWzXCiTdIbcxx5fEwqHZlsaDD7blOId321PnxGsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ashok Raj <ashok.raj@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0223/1001] x86/microcode: Adjust late loading result reporting message
Date: Tue,  7 Mar 2023 17:49:55 +0100
Message-Id: <20230307170031.553666959@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ashok Raj <ashok.raj@intel.com>

[ Upstream commit 6eab3abac7043226e5375e9ead0c7607ced6767b ]

During late microcode loading, the "Reload completed" message is issued
unconditionally, regardless of success or failure.

Adjust the message to report the result of the update.

  [ bp: Massage. ]

Fixes: 9bd681251b7c ("x86/microcode: Announce reload operation's completion")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/lkml/874judpqqd.ffs@tglx/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index a25ba851a9208..3c4e732a61dff 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -453,11 +453,14 @@ static int microcode_reload_late(void)
 	store_cpu_caps(&prev_info);
 
 	ret = stop_machine_cpuslocked(__reload_late, NULL, cpu_online_mask);
-	if (ret == 0)
+	if (!ret) {
+		pr_info("Reload succeeded, microcode revision: 0x%x -> 0x%x\n",
+			old, boot_cpu_data.microcode);
 		microcode_check(&prev_info);
-
-	pr_info("Reload completed, microcode revision: 0x%x -> 0x%x\n",
-		old, boot_cpu_data.microcode);
+	} else {
+		pr_info("Reload failed, current microcode revision: 0x%x\n",
+			boot_cpu_data.microcode);
+	}
 
 	return ret;
 }
-- 
2.39.2



