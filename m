Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBF6531B18;
	Thu, 17 Sep 2026 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660112; cv=none; b=Z8/vrde9zfNPWEvHbQShYA/gtn0GgXLV5W3taJCM7BsqtPdzYT7A4LXR8L8ZkxOIi2knnWpbgOkkF2ROCyJWI9FChXlk8UF2Q3yfXixr4Xu15UpsVkCxLdoYNXI/Pzg5FhWBvgpxjo/Dyc7XTIo8M/HEnU8JYY45+sFATs22qF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660112; c=relaxed/simple;
	bh=lK8ADAwk1Y0pQlB4KFsLjGXIU5TXDG9Hrl8ISLMGMvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdMvqmR53AamHtRZO2oHrw0cebgoKO5J0J6JAES/3sC/iUzQUvV+aohK7Kdybp7tvB+wsvQJuQe61+lhmSn8qFFBHmZFm5QjAaBR2rPpQWBBRvHoO0I1UZPMpNMQKCDrircBKCyl9nBF2UCAzFREQ0dJKzNn6HfFvT4HIymP3BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXzstsRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXzstsRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21F61F00898;
	Thu, 17 Sep 2026 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660106;
	bh=MFW2jysTdQSy/oAbx7sbwe5kFpQ9Uvqh3m9uMttTcfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXzstsRyHmQeL0bCVYkL54x2HFGBRGg8SZ5Dz/60LMy4XkpbFYx4qrfLbJDwsRSdJ
	 35h93x3XZM2Zp5oU1KZITsEl8GyVsJpy3qky3HJ6kaVs1nJri/FFkF01WIByKi2o04
	 lWXYcOWAdZriiDNVeEU8TNLrIvmVhoz03++Tfue8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasjeet Rangi <jrangi@purestorage.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 7.2 454/733] x86/MCE/AMD: Fix inverted interrupt enablement during storm handling
Date: Thu, 17 Sep 2026 16:12:42 +0100
Message-ID: <20260917151403.228608724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jasjeet Rangi <jrangi@purestorage.com>

commit d2929113b15bfc06793b852aeba3d2db6d79fcc9 upstream.

mce_amd_handle_storm() currently does the opposite of what storm
handling needs: it enables thresholding interrupts when a storm is
detected and disables them when the storm subsides.

Flip the "on" function argument before passing it to threshold_restart_bank()
as it should have been done.

To clarify: "on" to mce_handle_storm() means, the storm is on now when
"on" is true, and off when "on" is false.

  [ bp: Simplify. ]

Fixes: 5c4663ed1eac ("x86/mce: Handle AMD threshold interrupt storms")
Signed-off-by: Jasjeet Rangi <jrangi@purestorage.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260812221514.598842-2-jrangi@purestorage.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -864,7 +864,7 @@ static void amd_deferred_error_interrupt
 
 void mce_amd_handle_storm(unsigned int bank, bool on)
 {
-	threshold_restart_bank(bank, on);
+	threshold_restart_bank(bank, !on);
 }
 
 static void amd_reset_thr_limit(unsigned int bank)


