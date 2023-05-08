Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E30168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075A4C433EF;
	Mon,  8 May 2023 09:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539452;
	bh=H65d8sQvz6pQgFW8AVz+EIIZlzDYoiKDmQ8UkJSsJ4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/CvMR4IJbcGVXBgLbDTkqyWJx8ck38WN8qL40q2d07clfIA0AEHkM4NlT9Udexh3
	 78RZi1+mUPXabUBCObjSswXTUCgZ+GzveujpOHVSNqXwAwlRDguDtNpf5kf1a23qre
	 8ocdaw0o9TmVU9dwEli4u950y7Zsn0GmCSt8ZV+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/611] x86/hyperv: Block root partition functionality in a Confidential VM
Date: Mon,  8 May 2023 11:37:26 +0200
Message-Id: <20230508094421.709459046@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit f8acb24aaf89fc46cd953229462ea8abe31b395f ]

Hyper-V should never specify a VM that is a Confidential VM and also
running in the root partition.  Nonetheless, explicitly block such a
combination to guard against a compromised Hyper-V maliciously trying to
exploit root partition functionality in a Confidential VM to expose
Confidential VM secrets. No known bug is being fixed, but the attack
surface for Confidential VMs on Hyper-V is reduced.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1678894453-95392-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 831613959a92a..34d9e899e471e 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -291,12 +291,16 @@ static void __init ms_hyperv_init_platform(void)
 	 * To mirror what Windows does we should extract CPU management
 	 * features and use the ReservedIdentityBit to detect if Linux is the
 	 * root partition. But that requires negotiating CPU management
-	 * interface (a process to be finalized).
+	 * interface (a process to be finalized). For now, use the privilege
+	 * flag as the indicator for running as root.
 	 *
-	 * For now, use the privilege flag as the indicator for running as
-	 * root.
+	 * Hyper-V should never specify running as root and as a Confidential
+	 * VM. But to protect against a compromised/malicious Hyper-V trying
+	 * to exploit root behavior to expose Confidential VM memory, ignore
+	 * the root partition setting if also a Confidential VM.
 	 */
-	if (cpuid_ebx(HYPERV_CPUID_FEATURES) & HV_CPU_MANAGEMENT) {
+	if ((ms_hyperv.priv_high & HV_CPU_MANAGEMENT) &&
+	    !(ms_hyperv.priv_high & HV_ISOLATION)) {
 		hv_root_partition = true;
 		pr_info("Hyper-V: running as root partition\n");
 	}
-- 
2.39.2



