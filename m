Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D33711C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106FDC433C8;
	Thu, 24 Aug 2023 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889078;
	bh=ziT8LjD+H6/mXuzlnivpUnSdMdH6GPHZrgYd7YEQQ40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ql3ZGIwXKU5nK4l9NXzO830OBpO5os1CkC9wXIs+NzsxMySzv0c/1hEdLwRnvHHuq
	 Zk972Pkklv5mR3gdwFCeQDeJxNKF5tuomNwQZgl+XWhH85osOAeYaywVoqsPp5+TXI
	 IbGkW47QBVeMfrUoycR10WY/0A32w9uzihh7iKoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 139/139] x86/srso: Correct the mitigation status when SMT is disabled
Date: Thu, 24 Aug 2023 16:51:02 +0200
Message-ID: <20230824145029.438143277@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 6405b72e8d17bd1875a56ae52d23ec3cd51b9d66 upstream.

Specify how is SRSO mitigated when SMT is disabled. Also, correct the
SMT check for that.

Fixes: e9fbc47b818b ("x86/srso: Disable the mitigation on unaffected configurations")
Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20230814200813.p5czl47zssuej7nv@treble
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2398,8 +2398,7 @@ static void __init srso_select_mitigatio
 		 * Zen1/2 with SMT off aren't vulnerable after the right
 		 * IBPB microcode has been applied.
 		 */
-		if ((boot_cpu_data.x86 < 0x19) &&
-		    (!cpu_smt_possible() || (cpu_smt_control == CPU_SMT_DISABLED))) {
+		if (boot_cpu_data.x86 < 0x19 && !cpu_smt_possible()) {
 			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
 			return;
 		}
@@ -2689,7 +2688,7 @@ static ssize_t gds_show_state(char *buf)
 static ssize_t srso_show_state(char *buf)
 {
 	if (boot_cpu_has(X86_FEATURE_SRSO_NO))
-		return sysfs_emit(buf, "Not affected\n");
+		return sysfs_emit(buf, "Mitigation: SMT disabled\n");
 
 	return sysfs_emit(buf, "%s%s\n",
 			  srso_strings[srso_mitigation],


