Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22978584970;
	Wed,  9 Sep 2026 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963507; cv=none; b=LOJOCXlEl8P+1rtxELmAs6WeSuSBNWFnCNvDIixuz4+M6h5ptJrTH/oVoPcKJiJu3zQ5UkeANaPe49u7DyD5+xW95qwXkVv6asTRqyRyCpcIZ02ORLs2JVVWbSYQB10ZG7Q6D6iK6dvHi1EKHIJxSIC/6NMRtFTaxJXeey3AJpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963507; c=relaxed/simple;
	bh=JfVWRojp98dG66DIMxXltUfpkpm43qaYL00FCu04zfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eevrE+JgAiDL4BLNu4GH0GPfm0B962D0+0GJ3xUpCd9y/0bVPo973hfa74boGExb2RpDPWB7NfPeg7B7Jl8S/Z/Z7RPJ8LTVnL7vwcTXvFLSeIf6LoFJVEWsPXaif1eoZyDwBoLLyqsK7bRvyr4nHvMTholSgzVc0bpy2T/Lmyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQWPIM+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQWPIM+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9451F00A3E;
	Wed,  9 Sep 2026 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963506;
	bh=UyDGfgW7TS/mDVVDMKVNbr+5NA0cFUHTf1TTDVmklpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQWPIM+bRsEkw1PWhOUY/DWfJf2xuqM1s/SVOxVnNsSNEGMOc1UzGqAJRWh6tAefp
	 58ivrksS81G3z9x4/u5OgxBcapmj0OXM0GrnPwtwSDiVbcN4UWx2A7I4OK2RPmFFYS
	 Szdjyl8hBJ8vfaygCxfi418th5c/CAwQVRPQF6sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khushit Shah <khushit.shah@nutanix.com>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 102/583] arm64: errata: pass REVIDR when matching target implementation CPUs
Date: Wed,  9 Sep 2026 15:36:27 +0200
Message-ID: <20260909134241.664800879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khushit Shah <khushit.shah@nutanix.com>

commit 5541432e09dc2031978188f3e8a00b9fc78cf097 upstream.

When target implementation CPUs are provided, is_affected_midr_range()
accidentally passed the MIDR as both arguments to __is_affected_midr_range(),
so the REVIDR mask check operated on the wrong register.

Pass REVIDR as intended.

Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -82,7 +82,7 @@ is_affected_midr_range(const struct arm6
 
 	for (i = 0; i < target_impl_cpu_num; i++) {
 		if (__is_affected_midr_range(entry, target_impl_cpus[i].midr,
-					     target_impl_cpus[i].midr))
+					     target_impl_cpus[i].revidr))
 			return true;
 	}
 	return false;


