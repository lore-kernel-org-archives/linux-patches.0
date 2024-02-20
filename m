Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B16151CD6;
	Tue, 20 Feb 2024 21:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463711; cv=none; b=MlIzNIdeCArIMAkQRiikMmu7TGzm1yGy8aiAwkoWF7BpyfjaZ91LcvmXNQDUUTj2/g9TFsUauotZXKQiT7o7382kQGlcs6w9zKx2tACTJISUEdbR/DTxwjpRMM3BWmx8NFUVNiOys5k76KJgKxzVO2LzvzqYvBI+jcE+iKpWiEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463711; c=relaxed/simple;
	bh=HjfYc2gMOf86f0PDu/oukRzntPuU1keVYneNr4h1iZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1uGqOSKezWeZcA6OT7S7psBnWYa+a08Ml5y+7dGKSNZ6liiw2JpybbypIkT6i7zLnRAitD4P/HW//l4a2SxplFJUQ+pzv/Dpu8uWYosPqHB5zrXRTuL2AskUnqsEdiLsROdizFWVi7mY51P/vpTGq+G8Tovpd6fkEb4FuT6E/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0AxI27H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0AxI27H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C24C433F1;
	Tue, 20 Feb 2024 21:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463710;
	bh=HjfYc2gMOf86f0PDu/oukRzntPuU1keVYneNr4h1iZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0AxI27HfnM2piKhlhYPx8CR6IUTFMQmXMx/G1mnAlYNZGSUUvPXedAelEHOlWHnU
	 jqcHQT4Zw0IbdenYZmNKzaSE7s4Tm8VPtInONO5ns9IWVWaDbp9KaRw3bt5p5amUGB
	 l+k5/a2A6aCUaLPNelmIXisXl5HCGbDHpTaqqY3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Fangrui Song <maskray@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Kees Cook <keescook@chromium.org>,
	Justin Stitt <justinstitt@google.com>
Subject: [PATCH 6.6 129/331] kbuild: Fix changing ELF file type for output of gen_btf for big endian
Date: Tue, 20 Feb 2024 21:54:05 +0100
Message-ID: <20240220205641.637734618@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit e3a9ee963ad8ba677ca925149812c5932b49af69 upstream.

Commit 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
changed the ELF type of .btf.vmlinux.bin.o to ET_REL via dd, which works
fine for little endian platforms:

   00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
  -00000010  03 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |................|
  +00000010  01 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |................|

However, for big endian platforms, it changes the wrong byte, resulting
in an invalid ELF file type, which ld.lld rejects:

   00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF............|
  -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
  +00000010  01 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|

  Type:                              <unknown>: 103

  ld.lld: error: .btf.vmlinux.bin.o: unknown file type

Fix this by updating the entire 16-bit e_type field rather than just a
single byte, so that everything works correctly for all platforms and
linkers.

   00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF............|
  -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
  +00000010  00 01 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|

  Type:                              REL (Relocatable file)

While in the area, update the comment to mention that binutils 2.35+
matches LLD's behavior of rejecting an ET_EXEC input, which occurred
after the comment was added.

Cc: stable@vger.kernel.org
Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
Link: https://github.com/llvm/llvm-project/pull/75643
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/link-vmlinux.sh |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -135,8 +135,13 @@ gen_btf()
 	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
 		--strip-all ${1} ${2} 2>/dev/null
 	# Change e_type to ET_REL so that it can be used to link final vmlinux.
-	# Unlike GNU ld, lld does not allow an ET_EXEC input.
-	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
+	# GNU ld 2.35+ and lld do not allow an ET_EXEC input.
+	if is_enabled CONFIG_CPU_BIG_ENDIAN; then
+		et_rel='\0\1'
+	else
+		et_rel='\1\0'
+	fi
+	printf "${et_rel}" | dd of=${2} conv=notrunc bs=1 seek=16 status=none
 }
 
 # Create ${2} .S file with all symbols from the ${1} object file


