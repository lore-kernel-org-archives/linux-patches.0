Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B002188CB3;
	Tue, 10 Sep 2024 09:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962287; cv=none; b=QTeEMZbMJXpf/NTJVDPZkY7ohppMdTGG+rcXFH6DcBZeUEn3sd8enVhDC14sxUXbK5geRjxz1PXUaeLSm8kXojqpe8YmvUdj0LKyJPRlvekJTg8CTLrPEYoKMuU6isSbfDTZ6hUw7FtMQwq5aEPZGss4ywsfLDQI18IpSkDILy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962287; c=relaxed/simple;
	bh=l0BI7y3mJVaX1SEj5uNtcJCY9AJBnxZljr+gG4cLkWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlP+FIPtXIRWEkMaOFwIskeUNkhNkGeKsxtKNedpQE/SysDQtXyVCPjC0b/xPROMzl5lsJ3Y5HxLZCesj6yQ2slRRGFnQvOCewETT7oIgzfmX37zLiwz5wAUTmWiadvh5uzHLmpUQZAcz/icXJKaBYJZ1XWQJCKRTA+pjlFTvsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XhcLSdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XhcLSdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9A0C4CEC3;
	Tue, 10 Sep 2024 09:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962286;
	bh=l0BI7y3mJVaX1SEj5uNtcJCY9AJBnxZljr+gG4cLkWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XhcLSdjK+aOwZ+nH/APD7vsJ+bybsKMiloYR67vmrcVJRGqVMmT+5t+OxSBukqdS
	 DqgWzrIsyAwAaOTUISeIbNBoNipzOtNBfNMhMkmKEnI5eRkwsDAWuSh6Tn8PZTH5CB
	 BpoMwoqOQ+hzxopln9tdiNEJPpYLaiIOVyb2HSN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 341/375] powerpc/vdso: Dont discard rela sections
Date: Tue, 10 Sep 2024 11:32:18 +0200
Message-ID: <20240910092634.041425922@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 6114139c3bdde992f4a19264e4f9bfc100d8d776 ]

After building the VDSO, there is a verification that it contains
no dynamic relocation, see commit aff69273af61 ("vdso: Improve
cmd_vdso_check to check all dynamic relocations").

This verification uses readelf -r and doesn't work if rela sections
are discarded.

Fixes: 8ad57add77d3 ("powerpc/build: vdso linker warning for orphan sections")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/45c3e6fc76cad05ad2cac0f5b5dfb4fae86dc9d6.1724153239.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/vdso32.lds.S | 4 +++-
 arch/powerpc/kernel/vdso/vdso64.lds.S | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/vdso32.lds.S b/arch/powerpc/kernel/vdso/vdso32.lds.S
index 426e1ccc6971..8f57107000a2 100644
--- a/arch/powerpc/kernel/vdso/vdso32.lds.S
+++ b/arch/powerpc/kernel/vdso/vdso32.lds.S
@@ -74,6 +74,8 @@ SECTIONS
 	.got		: { *(.got) }			:text
 	.plt		: { *(.plt) }
 
+	.rela.dyn	: { *(.rela .rela*) }
+
 	_end = .;
 	__end = .;
 	PROVIDE(end = .);
@@ -87,7 +89,7 @@ SECTIONS
 		*(.branch_lt)
 		*(.data .data.* .gnu.linkonce.d.* .sdata*)
 		*(.bss .sbss .dynbss .dynsbss)
-		*(.got1 .glink .iplt .rela*)
+		*(.got1 .glink .iplt)
 	}
 }
 
diff --git a/arch/powerpc/kernel/vdso/vdso64.lds.S b/arch/powerpc/kernel/vdso/vdso64.lds.S
index bda6c8cdd459..400819258c06 100644
--- a/arch/powerpc/kernel/vdso/vdso64.lds.S
+++ b/arch/powerpc/kernel/vdso/vdso64.lds.S
@@ -69,7 +69,7 @@ SECTIONS
 	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
 	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
 	.gcc_except_table : { *(.gcc_except_table) }
-	.rela.dyn ALIGN(8) : { *(.rela.dyn) }
+	.rela.dyn ALIGN(8) : { *(.rela .rela*) }
 
 	.got ALIGN(8)	: { *(.got .toc) }
 
@@ -86,7 +86,7 @@ SECTIONS
 		*(.data .data.* .gnu.linkonce.d.* .sdata*)
 		*(.bss .sbss .dynbss .dynsbss)
 		*(.opd)
-		*(.glink .iplt .plt .rela*)
+		*(.glink .iplt .plt)
 	}
 }
 
-- 
2.43.0



