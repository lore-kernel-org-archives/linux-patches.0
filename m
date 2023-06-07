Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED5534CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505C3C433EF;
	Wed,  7 Jun 2023 20:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170666;
	bh=5DwqsY8jX3cH76DHY0a72VrqD2LzZ4K6+l06hTIRTzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=av6N8iPZcFdDNWZ2HaG/Ai/I9uRps9xElKfvhI9/1NOWobaxcmhBQM92DaSmi5Pmn
	 RUdiD9XPICbKrz2N9SJnN0WjZo3sAZkM5yxIO5e6lCkokxgW4esWHnk6K+iikSDTJ9
	 W8MVEfUMCwO02ucQmtJfzCuXfncZAuzFmsthUk6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Kujau <lists@nerdbynature.de>,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Jason Andryuk <jandryuk@gmail.com>
Subject: [PATCH 6.1 171/225] x86/mtrr: Revert 90b926e68f50 ("x86/pat: Fix pat_x_mtrr_type() for MTRR disabled case")
Date: Wed,  7 Jun 2023 22:16:04 +0200
Message-ID: <20230607200919.984425789@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

commit f9f57da2c2d119dbf109e3f6e1ceab7659294046 upstream.

Commit

  90b926e68f50 ("x86/pat: Fix pat_x_mtrr_type() for MTRR disabled case")

broke the use case of running Xen dom0 kernels on machines with an
external disk enclosure attached via USB, see Link tag.

What this commit was originally fixing - SEV-SNP guests on Hyper-V - is
a more specialized situation which has other issues at the moment anyway
so reverting this now and addressing the issue properly later is the
prudent thing to do.

So revert it in time for the 6.2 proper release.

  [ bp: Rewrite commit message. ]

Reported-by: Christian Kujau <lists@nerdbynature.de>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/4fe9541e-4d4c-2b2a-f8c8-2d34a7284930@nerdbynature.de
Cc: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/memtype.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -434,8 +434,7 @@ static unsigned long pat_x_mtrr_type(u64
 		u8 mtrr_type, uniform;
 
 		mtrr_type = mtrr_type_lookup(start, end, &uniform);
-		if (mtrr_type != MTRR_TYPE_WRBACK &&
-		    mtrr_type != MTRR_TYPE_INVALID)
+		if (mtrr_type != MTRR_TYPE_WRBACK)
 			return _PAGE_CACHE_MODE_UC_MINUS;
 
 		return _PAGE_CACHE_MODE_WB;


