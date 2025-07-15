Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3762E3378;
	Tue, 15 Jul 2025 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585867; cv=none; b=bWXBFNtHZtJl8D9Tx4ha+kAe3ULxLzL2IUSE56fnp6NxSrvi5VQrNp8YMgXym+ho7nTC1puuXsFTq6KT1xD6NRPICHjdMCkc9y206pNutePCjh0yg1jxh/PWQDe6Le//qsJgIJpkHXORNefczK0BijH/1HYsZU20ZgPA3FV5NJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585867; c=relaxed/simple;
	bh=Rcpcaha7vHuaSYqFmPHsFudI7ztp3iVmcp3jqjMEV04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szVUrSqhgWCdSYhfSnj5AQ7vykhEreg01WHp6BhmyNE4ERcnMnFCAo+CyA1orZCk2gtEWhoJlKnEGT37W35ErwR5/4Z9cpvqhdHuI45QU/Lq19uhAeIL/0PDU4ymLWkYb1ZgCd9OtXyt2imL3q+CEMLAnMiSRSa/QnS9I+Vlmn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dexzafS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dexzafS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8E6C4CEF1;
	Tue, 15 Jul 2025 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585867;
	bh=Rcpcaha7vHuaSYqFmPHsFudI7ztp3iVmcp3jqjMEV04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dexzafS26guIdBB17lu7x4cYjiMfh3jyz2Z5tFqFMR0G40bDG5PS2Jf1iklcuOvsb
	 SqexNR7/CvG4zncxdDe8EFAPz7RgV36IJFCuBFoL+SAwTTYutHCFcingx4tud7DnGj
	 4nW5E8ujL+Xce0hi0jeEiGyePxV2s2kSNUisoonw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aijay Adams <aijay@meta.com>,
	JP Kobryn <inwardvessel@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 036/109] x86/mce: Make sure CMCI banks are cleared during shutdown on Intel
Date: Tue, 15 Jul 2025 15:12:52 +0200
Message-ID: <20250715130800.326700632@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JP Kobryn <inwardvessel@gmail.com>

commit 30ad231a5029bfa16e46ce868497b1a5cdd3c24d upstream.

CMCI banks are not cleared during shutdown on Intel CPUs. As a side effect,
when a kexec is performed, CPUs coming back online are unable to
rediscover/claim these occupied banks which breaks MCE reporting.

Clear the CPU ownership during shutdown via cmci_clear() so the banks can
be reclaimed and MCE reporting will become functional once more.

  [ bp: Massage commit message. ]

Reported-by: Aijay Adams <aijay@meta.com>
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/20250627174935.95194-1-inwardvessel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -517,6 +517,7 @@ void mce_intel_feature_init(struct cpuin
 void mce_intel_feature_clear(struct cpuinfo_x86 *c)
 {
 	intel_clear_lmce();
+	cmci_clear();
 }
 
 bool intel_filter_mce(struct mce *m)


