Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325D7305976;
	Tue, 11 Nov 2025 01:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825529; cv=none; b=OOFnqr9Hj5ge7H3JVmgK//nr68hQKp1YL5vXqSvANabxSP5hbqwE12TLxun6f1X41G1iO/9g6LyG8vkaot5gZGMwQ6hTli2Bm8j+KyDvWcju/WB4SSJyZk2Gjrt+NYpWdOlffAlpXqC95hNZSA+O8VYxDscFUDoix28r51Y/T7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825529; c=relaxed/simple;
	bh=tYdb6CRbT61gIzaRcyrbMHB3RR77MHgKEon8g4ZKgGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eageh46qipTd2M2jmtP/b+PfAdNp7fRklrDEO+BJtqtYKT/aWAmGpDIFfo5qCu576fY2npUbRTC8qkZ5+irGS5GJE8yMoKojKHQD/opSTX83JEcNZSWeDTQj0O0OoNqFwmSKmr5Q9PYjO/grrrx6Y60BT3KfoOqPOZPaF4n82Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0b7N55Xk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0b7N55Xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6173C16AAE;
	Tue, 11 Nov 2025 01:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825529;
	bh=tYdb6CRbT61gIzaRcyrbMHB3RR77MHgKEon8g4ZKgGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0b7N55XkKgMJ7DmVBMw6WKzSgm0WgvFV2jRw+UqZ6NsKmQfUDhwZwGKs3RapEXp2q
	 dyvsB/rMCZ3/GyD9qTVnfEkSQ4Hfi41FRKjGLZx8aqSVqO7ih5OEzm66/YHW3V7Q3K
	 1WFsFW7R5n1AXsuW0TNYSdT2E9viBLW0FsVf3u4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	Samir M <samir@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.17 840/849] kbuild: Strip trailing padding bytes from modules.builtin.modinfo
Date: Tue, 11 Nov 2025 09:46:50 +0900
Message-ID: <20251111004556.729582472@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit a26a6c93edfeee82cb73f55e87d995eea59ddfe8 upstream.

After commit d50f21091358 ("kbuild: align modinfo section for Secureboot
Authenticode EDK2 compat"), running modules_install with certain
versions of kmod (such as 29.1 in Ubuntu Jammy) in certain
configurations may fail with:

  depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix

The additional padding bytes to ensure .modinfo is aligned within
vmlinux.unstripped are unexpected by kmod, as this section has always
just been null-terminated strings.

Strip the trailing padding bytes from modules.builtin.modinfo after it
has been extracted from vmlinux.unstripped to restore the format that
kmod expects while keeping .modinfo aligned within vmlinux.unstripped to
avoid regressing the Authenticode calculation fix for EDK2.

Cc: stable@vger.kernel.org
Fixes: d50f21091358 ("kbuild: align modinfo section for Secureboot Authenticode EDK2 compat")
Reported-by: Omar Sandoval <osandov@fb.com>
Reported-by: Samir M <samir@linux.ibm.com>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/7fef7507-ad64-4e51-9bb8-c9fb6532e51e@linux.ibm.com/
Tested-by: Omar Sandoval <osandov@fb.com>
Tested-by: Samir M <samir@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20251105-kbuild-fix-builtin-modinfo-for-kmod-v1-1-b419d8ad4606@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
[nathan: Apply to scripts/Makefile.vmlinux_o, location of
         modules.builtin.modinfo rule prior to 39cfd5b12160]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.vmlinux_o |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/scripts/Makefile.vmlinux_o
+++ b/scripts/Makefile.vmlinux_o
@@ -76,11 +76,24 @@ targets += vmlinux.o
 # modules.builtin.modinfo
 # ---------------------------------------------------------------------------
 
+# .modinfo in vmlinux.unstripped is aligned to 8 bytes for compatibility with
+# tools that expect vmlinux to have sufficiently aligned sections but the
+# additional bytes used for padding .modinfo to satisfy this requirement break
+# certain versions of kmod with
+#
+#   depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix
+#
+# Strip the trailing padding bytes after extracting .modinfo to comply with
+# what kmod expects to parse.
+quiet_cmd_modules_builtin_modinfo = GEN     $@
+      cmd_modules_builtin_modinfo = $(cmd_objcopy); \
+                                    sed -i 's/\x00\+$$/\x00/g' $@
+
 OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
 
 targets += modules.builtin.modinfo
 modules.builtin.modinfo: vmlinux.o FORCE
-	$(call if_changed,objcopy)
+	$(call if_changed,modules_builtin_modinfo)
 
 # modules.builtin
 # ---------------------------------------------------------------------------


