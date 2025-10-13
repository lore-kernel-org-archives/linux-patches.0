Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B03D26F2B6;
	Mon, 13 Oct 2025 15:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368661; cv=none; b=lDHB8fYMecO3jpovdpzQF0im2s8YVKC42R9BQstkjbY/IHaUlWyEW8+C5a4ERg4DGlGrxpHV2vIo8Y53XqVknT5T0nC4oDemaim6C64FuSiWQmPS9MtT+xAUpXM9x4puFvrBPi8+MlVce+IOs9PpQoSbwGQfjzdgrfOC+cJ5SNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368661; c=relaxed/simple;
	bh=0Z8UL2GhDJSI19a3Y1AzZSMsUVmigrZxRxSJB6psBNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tit7RBbgsbeMjMtEpIVLmirUowMlTIvEXaEToIKu6xZJr6Bdq3Md9QQhm9lD3U2qK9IpNyMmu07c9xI4nTbxoPQFLyAUCzfANwOMYzj86EL/aS/XxrlGB6nPeA37SD+Vra2ONxV3NfRrp8aai3+IOPEddLgobqO6dyfVMiRmG+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQUVynzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQUVynzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920D3C4CEFE;
	Mon, 13 Oct 2025 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368661;
	bh=0Z8UL2GhDJSI19a3Y1AzZSMsUVmigrZxRxSJB6psBNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQUVynzFUVVHQkWuqECrPyABXSmhk+ABFSSR9YR9upCAHjoGoRQjkAx8SjZgL9zpg
	 /iq90jVqwdriBbE2p1T3EdWgyWd5ZcVfWaxUFOPEtfcbBK+f5C1GMLyDThxt0rKeqg
	 KgTnkCdxkekbhs96NqsvIwSoiug32m1Il+W2MlZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 238/262] LoongArch: Automatically disable kaslr if boot from kexec_file
Date: Mon, 13 Oct 2025 16:46:20 +0200
Message-ID: <20251013144334.811147918@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youling Tang <tangyouling@kylinos.cn>

commit c8168b4faf1d62cbb320a3e518ad31cdd567cb05 upstream.

Automatically disable kaslr when the kernel loads from kexec_file.

kexec_file loads the secondary kernel image to a non-linked address,
inherently providing KASLR-like randomization.

However, on LoongArch where System RAM may be non-contiguous, enabling
KASLR for the second kernel may relocate it to an invalid memory region
and cause a boot failure. Thus, we disable KASLR when "kexec_file" is
detected in the command line.

To ensure compatibility with older kernels loaded via kexec_file, this
patch should be backported to stable branches.

Cc: stable@vger.kernel.org
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/relocate.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -166,6 +166,10 @@ static inline __init bool kaslr_disabled
 		return true;
 #endif
 
+	str = strstr(boot_command_line, "kexec_file");
+	if (str == boot_command_line || (str > boot_command_line && *(str - 1) == ' '))
+		return true;
+
 	return false;
 }
 


