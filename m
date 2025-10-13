Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C7330FF34;
	Mon, 13 Oct 2025 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367987; cv=none; b=cIJOz7ikC/FJKk/QrRjkfXAwXMR64y2bGSzQrIsDbLPelAyQyJZziSdNAzFe9nmRynEsd+9uekWhBYPJgfOMbwm/iyDFNgEaDG8DVnxFqlao1ckpG4dryOrHNT7kaBAuzLQOCaWZ4hPfIIvaYfwKI8UaFSjWPan3WMEWH/ZhgMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367987; c=relaxed/simple;
	bh=wtUFZ3dIXdIZSr2LYfeiPx49pVoBeeenTvOWn1c1V7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhH+JmgBbz4IvhXYZkTx7TzyzmW7SwRVLRtU2PlJZkUjsNDW7PDyJTshfRkNWjArZ4wFxJb0kQoZMwT9ZfA9Wi+BbKvX/N/8/7F95lsgPJ3qsGeicKC2PttqzR+JFx/zoCWCDEh7cxfxtVPSugSWTQIgcNnSlo9Xomd7OwQCEFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9ltX55I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9ltX55I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AF3C4CEE7;
	Mon, 13 Oct 2025 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367986;
	bh=wtUFZ3dIXdIZSr2LYfeiPx49pVoBeeenTvOWn1c1V7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9ltX55ICwtNrzu2oWDMwOQzVFlzZqVosPeOIXNgx25uDP7q61waXk3m1+NxNzvDZ
	 SPdqAbne2ggCOxSgBkw6Yg/GKo8e3fFkhsLyImCBbQ1PtxefERHadCpJMfKLgyLmgk
	 KxTujDV0XG+x+JVRr6bY2mxpD9+CK91ELHhMMhLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 179/196] LoongArch: Automatically disable kaslr if boot from kexec_file
Date: Mon, 13 Oct 2025 16:46:10 +0200
Message-ID: <20251013144321.783912248@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -124,6 +124,10 @@ static inline __init bool kaslr_disabled
 	if (str == boot_command_line || (str > boot_command_line && *(str - 1) == ' '))
 		return true;
 
+	str = strstr(boot_command_line, "kexec_file");
+	if (str == boot_command_line || (str > boot_command_line && *(str - 1) == ' '))
+		return true;
+
 	return false;
 }
 


