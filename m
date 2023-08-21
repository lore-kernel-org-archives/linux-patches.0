Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689701171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF47EC433C7;
	Mon, 21 Aug 2023 20:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648388;
	bh=/cqN16+Qs2mGXLtrbvjwXl76Z3tXO2E6uKjJ2kxVBXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvx+LGwKRjIZbP9AfLxLntupM2LfbwBy5g8Co7BbGJvdbKCOB77v8/8OxEYG48erU
	 FiMiRDFnz7CHNPEwRjDV+S1W3Cfd4zBRH40ylqppyqVu0hMeI3HnPplAnquYPIpupq
	 Is6F1OEivktNQI817TvqMMtqLKolj/V2lM8SBXA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.4 128/234] x86/srso: Disable the mitigation on unaffected configurations
Date: Mon, 21 Aug 2023 21:41:31 +0200
Message-ID: <20230821194134.498077383@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
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

commit e9fbc47b818b964ddff5df5b2d5c0f5f32f4a147 upstream.

Skip the srso cmd line parsing which is not needed on Zen1/2 with SMT
disabled and with the proper microcode applied (latter should be the
case anyway) as those are not affected.

Fixes: 5a15d8348881 ("x86/srso: Tie SBPB bit setting to microcode patch detection")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230813104517.3346-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2429,8 +2429,10 @@ static void __init srso_select_mitigatio
 		 * IBPB microcode has been applied.
 		 */
 		if ((boot_cpu_data.x86 < 0x19) &&
-		    (!cpu_smt_possible() || (cpu_smt_control == CPU_SMT_DISABLED)))
+		    (!cpu_smt_possible() || (cpu_smt_control == CPU_SMT_DISABLED))) {
 			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
+			return;
+		}
 	}
 
 	if (retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
@@ -2716,6 +2718,9 @@ static ssize_t gds_show_state(char *buf)
 
 static ssize_t srso_show_state(char *buf)
 {
+	if (boot_cpu_has(X86_FEATURE_SRSO_NO))
+		return sysfs_emit(buf, "Not affected\n");
+
 	return sysfs_emit(buf, "%s%s\n",
 			  srso_strings[srso_mitigation],
 			  (cpu_has_ibpb_brtype_microcode() ? "" : ", no microcode"));


