Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226BA40314E;
	Tue, 21 Jul 2026 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654239; cv=none; b=sWFY1DA9aqMX5KMVUBomD0UtuQMMyBuLhHS3faagL96X92gd+dvKjq12ADaWnQfaWcDNutMnO9I0cIJ8gLTXIYh+XRfn0Sr9LOfbvs8rkWaXXFEA2sn8dNxfEieCeo98xAR5rHjKdJM3KCw/p65eJgSD91r/yQkAKo7an77ANCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654239; c=relaxed/simple;
	bh=URvSE88Yx08ckalM/69VY2MqXifrEbXHuozGnByZzpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1gvy9X8a4R9Sm6mJabfVPowdiNHSeK6V5hxb3HBnw1E6jrbvvvRsvxPB5NHu8Y9qLPZzMZThjhb4UEUHmiNQhIJG2U+g7Q6kXlIb4B5wyRhugi3EuiFNN6oinbBUOltJp2ERpaXmpPGEp8rhU5eWFlTUNwQNx15fX6pestZUcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+iskwXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+iskwXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F981F000E9;
	Tue, 21 Jul 2026 17:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654238;
	bh=GjJXEnhcxJOHgD1J7FVNzDb9/tLrwGowuRytNMe0Wvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+iskwXj7W/O7sy7EYGveLZyAEZPgQXWXlC2uYArkGY3KsvzuDF65Uan6S1Q3/vkm
	 QFZqht66BDTPxSUSx1KPNjQ60SZcGxNxOn6lpUfiU86h+UlgPLAQ/zh0hg4T0mUJzs
	 BeTf9zEvXnFJSYUKqhfqxBGvp3AaPIb+slyhg6ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikanth Aithal <Srikanth.Aithal@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org
Subject: [PATCH 7.1 1630/2077] x86/virt/sev: Revert "Drop WBINVD before setting MSR_AMD64_SYSCFG_SNP_EN"
Date: Tue, 21 Jul 2026 17:21:43 +0200
Message-ID: <20260721152631.200389336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tycho Andersen (AMD) <tycho@kernel.org>

commit 4c2509f3b79756679a02bea649c6a7501b58f52c upstream.

Revert

  99cf1fb58e68 ("x86/virt/sev: Drop WBINVD before setting MSR_AMD64_SYSCFG_SNP_EN").

Section 8.8 of the SNP spec says:

  Before invoking SNP_INIT_EX with INIT_RMP set to 1, software must ensure
  that no CPUs contain dirty cache lines for the memory containing the RMP.

Cachelines can be moved from cache to cache in a dirty state. The
wbinvd_on_all_cpus() before SNP_INIT_EX flushes the caches for each CPU, but
if the IPIs for WBINVD race with this dirty cacheline movement, it is possible
that they may not get flushed, violating the firmware requirement.

Doing wbinvd_on_all_cpus() before setting SNPEn is safer since the RMP
table is not yet in use.

  [ Heroically bisected by Srikanth. ]
  [ bp: Massage commit message. ]

Fixes: 99cf1fb58e68 ("x86/virt/sev: Drop WBINVD before setting MSR_AMD64_SYSCFG_SNP_EN")
Reported-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260707150033.2364758-1-tycho@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/virt/svm/sev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -527,6 +527,8 @@ void snp_prepare(void)
 
 	cpus_read_lock();
 
+	wbinvd_on_all_cpus();
+
 	/*
 	 * MtrrFixDramModEn is not shared between threads on a core,
 	 * therefore it must be set on all CPUs prior to enabling SNP.


