Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A5533AEBA;
	Wed, 17 Sep 2025 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114017; cv=none; b=E88gHZPPtlxRc2TaqKBaD85tANVa7t257kbqWuSebjodJlsLbU23NoSkEdIYZYfxbuzl9RCHKuXLGHNg6s8aZaUOh8+Kn93B4RwCqvhT94CcMgSWh/Jf7fMIX/cARuPsm5XPDoib2414ChGZrETVfqTrA6I08kGljhv78JMBJ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114017; c=relaxed/simple;
	bh=Q9iqw20X7DAbdM3ok1CaB8lMhDl4LmAHQsMkpz2Ureo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6RHY1G6gjgHchRq/fz3l2mWvd4xBRXErdMuHDbea7T+k/qtTPHNUYGWU2SPORi9Ke8WvTHah9qpZJ5DYHKfF6IR+m6alK47bypdbJmh/K7K9NnIFrdyCVrnNlZf3qR2rZOvORvy/65+RWSXCYEnuRthJvk48A6O8CrDkOkefw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reZwpULg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reZwpULg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22226C4CEF0;
	Wed, 17 Sep 2025 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114017;
	bh=Q9iqw20X7DAbdM3ok1CaB8lMhDl4LmAHQsMkpz2Ureo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reZwpULg6F1imXF7QPW68Hh6F6Bs0AzkbQJtQqVbdFmFm3XmaBWhlTZ/aABGjjIgZ
	 A8mDMDuzlbfDz4Rz03t5883IryRwo/7ENyxNtmdQpcctMjZ6L1lHtxb0d1wOMHGzRe
	 M7SpH6WU2//V7umspF3r4KCQFbBTU1D9Zfq1YFcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 6.1 21/78] KVM: SVM: Return TSA_SQ_NO and TSA_L1_NO bits in __do_cpuid_func()
Date: Wed, 17 Sep 2025 14:34:42 +0200
Message-ID: <20250917123330.081828979@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Commit c334ae4a545a ("KVM: SVM: Advertise TSA CPUID bits to guests")
set VERW_CLEAR, TSA_SQ_NO and TSA_L1_NO kvm_caps bits that are
supposed to be provided to guest when it requests CPUID 0x80000021.
However, the latter two (in the %ecx register) are instead returned as
zeroes in __do_cpuid_func().

Return values of TSA_SQ_NO and TSA_L1_NO as set in the kvm_cpu_caps.

This fix is stable-only.

Cc: <stable@vger.kernel.org> # 6.1.y
Fixes: c334ae4a545a ("KVM: SVM: Advertise TSA CPUID bits to guests")
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1259,8 +1259,9 @@ static inline int __do_cpuid_func(struct
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->ecx = entry->edx = 0;
+		entry->ebx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
+		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:


