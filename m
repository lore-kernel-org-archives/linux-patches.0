Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447C41EB1AA;
	Wed, 19 Feb 2025 08:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954294; cv=none; b=pFM8duJbDb0DSxIVw7M8C8kqv9Cyc6iAb5LMQcSxCJPDfoaoqbnqYGCm5pmZVmAsg9VQVB6356u6S8llkBKUteaQZFfjX1L46EWCDNn1Qlu75mD+XIDY4Ja+/+JvlICRTcpy3QS6OEum7wZAEQV40j57tuLobXv2eXDSKFxxHbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954294; c=relaxed/simple;
	bh=7H2ngf/puQdQW/0ScuTbUzHytomm0SYR4ddX6dYFudI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vCB1Ch+CQ5xMimQ0X0abwZ/OHj9ETmAqINkhquoVPGpbqELgk3c1HvvFn8ossUo7v3F7lslbS04o4jrQgnIvMuClf+rlIdXmHm3sAyYz//Yr5Gw9I5EmFb0yo3+QaWBqzXtXS/YdRhrK0BguWOo/XIUDtMO0QTlwNNj1Mbjxks8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaDhAYma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaDhAYma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61297C4CEE7;
	Wed, 19 Feb 2025 08:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954293;
	bh=7H2ngf/puQdQW/0ScuTbUzHytomm0SYR4ddX6dYFudI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaDhAYmajZ4q3kRJzfHCfW7jR8oYHR/b2whH9KR8kBaLJol79Qw2sUJet1ezHQZfl
	 dUBzNkSF7g8NTo205ECOb+E87mhiTvfPeDrN04K5tOojc2fL9Je79mOJkjr0x/wgtx
	 foacL7l1w76rPQEZKOeaEhV5/vSwACN8Y8lMcfsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.13 158/274] kbuild: userprogs: fix bitsize and target detection on clang
Date: Wed, 19 Feb 2025 09:26:52 +0100
Message-ID: <20250219082615.779840890@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 1b71c2fb04e7a713abc6edde4a412416ff3158f2 upstream.

scripts/Makefile.clang was changed in the linked commit to move --target from
KBUILD_CFLAGS to KBUILD_CPPFLAGS, as that generally has a broader scope.
However that variable is not inspected by the userprogs logic,
breaking cross compilation on clang.

Use both variables to detect bitsize and target arguments for userprogs.

Fixes: feb843a469fb ("kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1119,8 +1119,8 @@ LDFLAGS_vmlinux += --orphan-handling=$(C
 endif
 
 # Align the bit size of userspace programs with the kernel
-KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
-KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
+KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # make the checker run with the right architecture
 CHECKFLAGS += --arch=$(ARCH)


