Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FBE1EE02F;
	Tue, 30 Sep 2025 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245002; cv=none; b=t0UIny68Ad5IMu6QsWK6n2XNXek/VOiGZ88xFGPBKL11Q6GDoYU0wkFwGc29oNbQJwdSS9huwzOUI0dg7redchuovcDLgpQE8zi0ofYLQndB5xRsVORXbbxvS8Btcrd9XTj9EhrxCdfn2OEH53kJWqylftyTYmZarPwNGjmefJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245002; c=relaxed/simple;
	bh=311NlmIEbXeOBXYuHeWRX52oe/mDSK+CMiUcahfQ7Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAsrKRvNPjY/TS401dTjkIzoIa7EBoE1kLZZrr+ysArIpJyn+20SVNJVDkn1aeOKzNQCp0i8jkFDJ9rDEvCf1jzaG8zwXcZKploji5/FnVovuMYYyjeQConXHvxwwzyhtciWdwI8h50YnIfHW2xIXRe03t9II+jFAHtVygTPe6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4ZjMOxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4ZjMOxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE741C4CEF0;
	Tue, 30 Sep 2025 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245002;
	bh=311NlmIEbXeOBXYuHeWRX52oe/mDSK+CMiUcahfQ7Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4ZjMOxasTC0NxN23Q0S0SpBtFkNGdNLRtBvOUc/qJX1SFjYCmjKLqy0rQFYgRn/T
	 3U25gnkLtM3EPSbrNL/jqyhmQYA9BGLVYJkBDj3Y8h+09Wy+iIdIARpOghMfGjN/FT
	 Xp4XsLutsurCebc0WPqaKbfR2rCAYeR1uRquT2y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.15 018/151] KVM: SVM: Return TSA_SQ_NO and TSA_L1_NO bits in __do_cpuid_func()
Date: Tue, 30 Sep 2025 16:45:48 +0200
Message-ID: <20250930143828.335331164@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Commit c334ae4a545a ("KVM: SVM: Advertise TSA CPUID bits to guests")
set VERW_CLEAR, TSA_SQ_NO and TSA_L1_NO kvm_caps bits that are
supposed to be provided to guest when it requests CPUID 0x80000021.
However, the latter two (in the %ecx register) are instead returned as
zeroes in __do_cpuid_func().

Return values of TSA_SQ_NO and TSA_L1_NO as set in the kvm_cpu_caps.

This fix is stable-only.

Cc: <stable@vger.kernel.org> # 5.15.y
Fixes: c334ae4a545a ("KVM: SVM: Advertise TSA CPUID bits to guests")
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1014,8 +1014,9 @@ static inline int __do_cpuid_func(struct
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


