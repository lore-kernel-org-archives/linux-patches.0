Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1382D94A7;
	Thu, 15 Jan 2026 17:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498508; cv=none; b=t0g4z8d9iihK3gCYX/V1DBIu38CzVCCjE0BVaEY9nBXwhhFydpqlwcrgLCKl2MHIWTLP/vuaC5kEfqb0G+WBItAA2oVUDblJ8cCc0JnVWs1ekoI9YhnrXbvmTg9q9r5zPNqBfLN3vTttCiNCM42HLfmoqDaVciBIM5HL/TdGhlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498508; c=relaxed/simple;
	bh=KuDbvPaLfTOzB6wywV6pGVV31EmlstCtOHy7wJKIM1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIxKf63K7FYWD5FKxjLRPfytg0RhDUef6iYpLBdP7D1LqqYl1mAyUtnwp2HV3+QuDz9+8MU336EEEcz38PKQyIMAR1nzh2YIM4T4ToUTJzJVtATxfJxsLFn2mzHv8LTBZONLJsT3CYoRoGcRfAo8V1KyPaq7L9/gslrykSjJvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0wPrYzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0wPrYzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7193AC116D0;
	Thu, 15 Jan 2026 17:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498507;
	bh=KuDbvPaLfTOzB6wywV6pGVV31EmlstCtOHy7wJKIM1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0wPrYzl+UkadKgz60sERT+kXywVEtjhlsxwhbCpnOLNPLsgjUj8KXAuHh5l7vYgQ
	 gMcJnteHcmf4Cx3IAz83mzuL7DgnslnhIOWCp97NZPo6quSs6POYZn3fSEXbBovNE/
	 v6avQ7+ej70+Bkr91RQToiPa4bG4Evbz7ELO6krA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Nybo Andersen <tweek@tweek.dk>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: [PATCH 5.15 423/554] kbuild: Use CRC32 and a 1MiB dictionary for XZ compressed modules
Date: Thu, 15 Jan 2026 17:48:09 +0100
Message-ID: <20260115164301.569611828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Martin Nybo Andersen <tweek@tweek.dk>

commit fbf5892df21a8ccfcb2fda0fd65bc3169c89ed28 upstream.

Kmod is now (since kmod commit 09c9f8c5df04 ("libkmod: Use kernel
decompression when available")) using the kernel decompressor, when
loading compressed modules.

However, the kernel XZ decompressor is XZ Embedded, which doesn't
handle CRC64 and dictionaries larger than 1MiB.

Use CRC32 and 1MiB dictionary when XZ compressing and installing
kernel modules.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050582
Signed-off-by: Martin Nybo Andersen <tweek@tweek.dk>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.modinst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -95,7 +95,7 @@ endif
 quiet_cmd_gzip = GZIP    $@
       cmd_gzip = $(KGZIP) -n -f $<
 quiet_cmd_xz = XZ      $@
-      cmd_xz = $(XZ) --lzma2=dict=2MiB -f $<
+      cmd_xz = $(XZ) --check=crc32 --lzma2=dict=1MiB -f $<
 quiet_cmd_zstd = ZSTD    $@
       cmd_zstd = $(ZSTD) -T0 --rm -f -q $<
 


