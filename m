Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ACC1F4CA9;
	Tue, 26 Aug 2025 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215621; cv=none; b=huhHLInTF8FHVzm0kRrlAJ1KD9y6WycxcBpuRC8NdErxqdzAWuogrDaN/8cGk+NS3Yc1aNTGZ5aUT5gdH6VGcMmjcdgk/M3qFxAgh6maZqJPJrYYV+PL/jbtTjXlPGoVsYOW14L9leG+NzgmYBVB1Ce9oBX4vpiq/ik/Od89UPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215621; c=relaxed/simple;
	bh=BxCfLaqtnV+02w6BNIEBRfJdwJsIoGb+d7Qhe48V1Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyGiXcizbbO5z03DSGTcOXSeE6G4urSzLdvlH83aPeyEv2q4AJ9VdiKNwySYfcj6XySbEHyzqsdJ2np8ghxXP6aSlWb0Bj7GDDzPzj1nyFsG2ugvqi9kCkVd61PuxlTJUD/0AHzLfzxifFcNsEYYG10kZKxXGICmqIfVMoMPolE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlhQx6Z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlhQx6Z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC49AC4CEF1;
	Tue, 26 Aug 2025 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215621;
	bh=BxCfLaqtnV+02w6BNIEBRfJdwJsIoGb+d7Qhe48V1Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlhQx6Z6G5CWHzxtSiygjI5uM5gAAEHlmuz7keQSxpTrh+dSPbtmGhvgV8CDhqOr3
	 EENDYHuGFQLAgcZGZD0H2esq5+FfqtmAZZ6NrSOcADg/8kZVufwN7OUt63TpA6LFgu
	 6s+uTXdG/l8SocC+COucjj62mUVVZp8A4+1yzfjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zhivich <mzhivich@akamai.com>
Subject: [PATCH 5.15 103/644] x86/bugs: Fix use of possibly uninit value in amd_check_tsa_microcode()
Date: Tue, 26 Aug 2025 13:03:14 +0200
Message-ID: <20250826110949.067063401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Zhivich <mzhivich@akamai.com>

For kernels compiled with CONFIG_INIT_STACK_NONE=y, the value of __reserved
field in zen_patch_rev union on the stack may be garbage.  If so, it will
prevent correct microcode check when consulting p.ucode_rev, resulting in
incorrect mitigation selection.

This is a stable-only fix.

Cc: <stable@vger.kernel.org>
Signed-off-by: Michael Zhivich <mzhivich@akamai.com>
Fixes: f2b75f1368af ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -592,6 +592,8 @@ static bool amd_check_tsa_microcode(void
 	p.model		= c->x86_model;
 	p.ext_model	= c->x86_model >> 4;
 	p.stepping	= c->x86_stepping;
+	/* reserved bits are expected to be 0 in test below */
+	p.__reserved	= 0;
 
 	if (c->x86 == 0x19) {
 		switch (p.ucode_rev >> 8) {


