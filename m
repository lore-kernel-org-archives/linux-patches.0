Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B2081AA8;
	Wed, 28 Jan 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616045; cv=none; b=P0AaWMM3h+nzWsTJMBI8Cd942i+zJ9IGjDfsN/3SzppqgRexIVIW9EpaYez/xhWDBLhyrjopJUeHWh3mrBzs9QQwDyu7wQ47//uiE0dY34NGYFmMXsd/DL8wT+lI4IP9KxeZB09qK07K4w8Y5XWR1QRFF9VnPhfxmCoW8SbucXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616045; c=relaxed/simple;
	bh=U5U+Dxyzbkv+frTwShZe3aDQQauM75213JRjwrOXeAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5ArjUfH4tF4zngiPnM8Xzr6VMXW7e4m6xGtvPhmAHc2deTwM7JOmkOWua8V9MknEE26fIhvZ1wV5qUf9UgIGNjZNdl3+9l/bLiMqAwlPSnP66m/uDA3SpJS+/C3HI0odafaDjNtg31j6fS4kPIykLN69T4vmnC/0eOiRPCdpHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWjycgHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWjycgHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4697AC4CEF1;
	Wed, 28 Jan 2026 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616045;
	bh=U5U+Dxyzbkv+frTwShZe3aDQQauM75213JRjwrOXeAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWjycgHgYG2B4oC1GG7Me4OmzbcKpQWNey7EdZM/YucXiq89YkmmkTrR3KKPk96z+
	 arfJVLs21zaBfxgJvQwIKbqFFkXbCcbtcX9x1GyI/hYBRwYJgcpXHVXt/k7nb1zdHG
	 FIbfunXBg7iOVJGssLqDgetEBRwnUMRyosNHSHQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 190/227] s390/boot/vmlinux.lds.S: Ensure bzImage ends with SecureBoot trailer
Date: Wed, 28 Jan 2026 16:23:55 +0100
Message-ID: <20260128145351.282542187@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit ddc6cbef3ef10359b5640b4ee810a520edc73586 upstream.

Since commit 3e86e4d74c04 ("kbuild: keep .modinfo section in
vmlinux.unstripped") the .modinfo section which has SHF_ALLOC ends up
in bzImage after the SecureBoot trailer. This breaks SecureBoot because
the bootloader can no longer find the SecureBoot trailer with kernel's
signature at the expected location in bzImage. To fix the bug,
move discarded sections before the ELF_DETAILS macro and discard
the .modinfo section which is not needed by the decompressor.

Fixes: 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
Cc: stable@vger.kernel.org
Suggested-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/boot/vmlinux.lds.S |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/arch/s390/boot/vmlinux.lds.S
+++ b/arch/s390/boot/vmlinux.lds.S
@@ -137,6 +137,15 @@ SECTIONS
 	}
 	_end = .;
 
+	/* Sections to be discarded */
+	/DISCARD/ : {
+		COMMON_DISCARDS
+		*(.eh_frame)
+		*(*__ksymtab*)
+		*(___kcrctab*)
+		*(.modinfo)
+	}
+
 	DWARF_DEBUG
 	ELF_DETAILS
 
@@ -161,12 +170,4 @@ SECTIONS
 		*(.rela.*) *(.rela_*)
 	}
 	ASSERT(SIZEOF(.rela.dyn) == 0, "Unexpected run-time relocations (.rela) detected!")
-
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		COMMON_DISCARDS
-		*(.eh_frame)
-		*(*__ksymtab*)
-		*(___kcrctab*)
-	}
 }


