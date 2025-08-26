Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564E63376BA;
	Tue, 26 Aug 2025 13:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215080; cv=none; b=MFCkpF+8mYXVsEyc4d0jz+YfOrV20crYhLTajJ0l8xiDZV0kPUNnfQ1b45auvgm+sBhkyvVzDcEeX/NfWRzNHr/CsPxCflCScsQNij6+rP9D/M7ldKFpNJ6se+SU916jtnrIxhxhBurg05hwCbqJVFDFyOW0mOWTv8fbWsDD+1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215080; c=relaxed/simple;
	bh=bCFpKEo/17c1Mo/bn7ljM0lZsc1874z6hBTvFFwf2ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgSlwmi6ImpsI4Etfho1krx4wb9y6Ktws/Uu3rlAYvX4taohrSOdRcKaCH01SOgK7E0dgonsOSLltf085Zp/Zse9OMUPu0Y2iQuzh3o6CqWXj3eEkzTrd11et+lktO9px88zHQRgT7T8Dh1myys1ytFXhm3R7efAzVKbl+PuK8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgbl/rGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgbl/rGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA38FC4CEF1;
	Tue, 26 Aug 2025 13:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215080;
	bh=bCFpKEo/17c1Mo/bn7ljM0lZsc1874z6hBTvFFwf2ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgbl/rGEda0qH36ZMG3YXeUb/DI0XD8O7N9DK6GlQYwlphqXwWWs+o8vNFEFy/psg
	 K9/z16O5xurs2SuZGjZ/1t4WYTK4c6PfzdPC/GrvmHEzYmOUQEfcXL85q5CQOgPg8A
	 uz17mQrTiTVikbaZ1AJ6d+Gr9i8Sq7JgtsyHZAR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nianyao Tang <tangnianyao@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Patrick Roy <roypat@amazon.co.uk>
Subject: [PATCH 6.1 379/482] arm64/cpufeatures/kvm: Add ARMv8.9 FEAT_ECBHB bits in ID_AA64MMFR1 register
Date: Tue, 26 Aug 2025 13:10:32 +0200
Message-ID: <20250826110940.191345757@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Nianyao Tang <tangnianyao@huawei.com>

commit e8cde32f111f7f5681a7bad3ec747e9e697569a9 upstream.

Enable ECBHB bits in ID_AA64MMFR1 register as per ARM DDI 0487K.a
specification.

When guest OS read ID_AA64MMFR1_EL1, kvm emulate this reg using
ftr_id_aa64mmfr1 and always return ID_AA64MMFR1_EL1.ECBHB=0 to guest.
It results in guest syscall jump to tramp ventry, which is not needed
in implementation with ID_AA64MMFR1_EL1.ECBHB=1.
Let's make the guest syscall process the same as the host.

Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
Link: https://lore.kernel.org/r/20240611122049.2758600-1-tangnianyao@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -343,6 +343,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_ECBHB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_TIDCP1_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_AFP_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_ETS_SHIFT, 4, 0),


