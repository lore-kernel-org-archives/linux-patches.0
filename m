Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8830C32BF21;
	Fri,  9 Jan 2026 12:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962989; cv=none; b=AIrFYDBFTLe+k91gyrG8sfItSpkNOeqGcOznIYAJio53HWKXj9nIsd4e2NOTrzP769TT5XFUsOGsOGfqGwpURoZQEZx8MyQLaL48ueVKz3LGz1s1axhfFj8KJ7BpLiFs3X+9gP2V5PyWruSIEZf+2oRTdm7p7DfHhstjV6WG9f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962989; c=relaxed/simple;
	bh=H8OZdNwHh/NEh5jEd4e2JHrDDManRnXLZVwbKSpJ2FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcwxXhWMPVkCf9aY3k54M83n5geug0YyBneSHGNk0DNaniyxI6y131m6sZUnoN9sMZ1VaKwEQRWycHOOIT/d/SBNpc09ewJGFgVEe0fE66gBAid+IYjxYTZwS0ssQi4aecQllkAQvDrJhC8EKZRMB8kx+g09kLlF6qmMl0W6ZIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh20LS04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh20LS04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149F4C4CEF1;
	Fri,  9 Jan 2026 12:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962989;
	bh=H8OZdNwHh/NEh5jEd4e2JHrDDManRnXLZVwbKSpJ2FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh20LS04LDo6ZZd2tYQSgzpJj5JrO3IjvS75+3l6CnzLNMqf0yhJSq5E2xYQv1Eaa
	 lXhOPLoCjdScPnEr+HsfZ6znOgqXbgeHCHny2v47iPbg40H2WGujACI7q6m3tdTZ3r
	 jYVI3OdkQxiT1DUyq52gARFFshq4wBJAPKP2SSn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Nybo Andersen <tweek@tweek.dk>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: [PATCH 6.1 526/634] kbuild: Use CRC32 and a 1MiB dictionary for XZ compressed modules
Date: Fri,  9 Jan 2026 12:43:24 +0100
Message-ID: <20260109112137.359395171@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -99,7 +99,7 @@ endif
 quiet_cmd_gzip = GZIP    $@
       cmd_gzip = $(KGZIP) -n -f $<
 quiet_cmd_xz = XZ      $@
-      cmd_xz = $(XZ) --lzma2=dict=2MiB -f $<
+      cmd_xz = $(XZ) --check=crc32 --lzma2=dict=1MiB -f $<
 quiet_cmd_zstd = ZSTD    $@
       cmd_zstd = $(ZSTD) -T0 --rm -f -q $<
 


