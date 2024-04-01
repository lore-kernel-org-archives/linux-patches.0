Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16251E525;
	Mon,  1 Apr 2024 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990281; cv=none; b=hASwW4MqzD67YjOacHRjSttilljU2SGk1AFM4Ch9knxwY61UCmtiZBh9Rm98h/otZ7s17MI3DGMUhc2rdfbARw5IXjBFJBwpKudPs9Vb1Wb/9Eli2MJ/2+YE5dsZhsGTkENBF5tJkyc8qKd9s3qnO/I8AZz5Wt8/jRaTh5q+2b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990281; c=relaxed/simple;
	bh=5+nTIL7w0OtY1dz2J6kr94BjTtcvJxB28z9arG7W6So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxLkIlHlkI2oCkgACL4Z2acYzP8eGt2cu/MRMe4uRCh+heeJ4Or7+wKvsi8kL+zcKddLkzIrnVKgtUlNpzYO16p0piaOsrtDva/obHkdU8oZz89Eh2zxW4HRPtVv7FNXDTbR8ch6Q9u5MzbtOfixfmcYhXUmDmkIpWom1/Mqku4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXngDd7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXngDd7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E05C433A6;
	Mon,  1 Apr 2024 16:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990281;
	bh=5+nTIL7w0OtY1dz2J6kr94BjTtcvJxB28z9arG7W6So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXngDd7HprONyjUk011/jvqOrXXadmEjO8t6jVJ2eCHmRWKBT2q58PhjZgMfxdTne
	 /c07xQNlWRDzhzVJ2rO28McAFDbGdKD6G0/STwWrr9VfU0SVN38dhuOZGAu/I3vEF6
	 NPViBTPAYUPFmmGO/Y0gprF/P3MvUHXeuetsMbrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/396] x86/mpparse: Register APIC address only once
Date: Mon,  1 Apr 2024 17:45:50 +0200
Message-ID: <20240401152556.874691756@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit f2208aa12c27bfada3c15c550c03ca81d42dcac2 ]

The APIC address is registered twice. First during the early detection and
afterwards when actually scanning the table for APIC IDs. The APIC and
topology core warn about the second attempt.

Restrict it to the early detection call.

Fixes: 81287ad65da5 ("x86/apic: Sanitize APIC address setup")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240322185305.297774848@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/mpparse.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b223922248e9f..15c700d358700 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -196,12 +196,12 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
-	/* Initialize the lapic mapping */
-	if (!acpi_lapic)
-		register_lapic_address(mpc->lapic);
-
-	if (early)
+	if (early) {
+		/* Initialize the lapic mapping */
+		if (!acpi_lapic)
+			register_lapic_address(mpc->lapic);
 		return 1;
+	}
 
 	/* Now process the configuration blocks. */
 	while (count < mpc->length) {
-- 
2.43.0



