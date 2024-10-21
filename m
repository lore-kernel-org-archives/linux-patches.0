Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536421E3DD8;
	Mon, 21 Oct 2024 10:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507499; cv=none; b=bmmbq4zKxigNwWYIS2YT0Zn+KiLvhW8RwLHhj/s8d3SFfhT6s4/enHZnj3XSi6nLP9FmV1xdHmPsaIYwnExCXLBIIoamO/f/LoLFnVWCunBgGMY9iCJkWGxeE0oVlEvskAiNXbqwpn3UASwIU10GNf/e24n7MILDpGrXDXlJwrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507499; c=relaxed/simple;
	bh=Zv634lCckH3dxjp7HCyrn9E16GhPsf0DMS/yzvJEA/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP7h2oXFRPRVO0uRm2fnxF2vpWPehH/I82HqY3oYjfhgbxCcYJiQdsj6P5UsQgdk6EB/bpuVbextYXDeby9niD+1Q2ku3ksnZKFYROsYDQAY+N0rMXdwdFAJA9zEx32QUP5+g9ZJcO+Wx3K8KIebA32V9NXtq/DM7Oz858+y6qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkFKGiPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkFKGiPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A50C4CEC3;
	Mon, 21 Oct 2024 10:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507499;
	bh=Zv634lCckH3dxjp7HCyrn9E16GhPsf0DMS/yzvJEA/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkFKGiPnXLMhcV2JwmKkV6Yh2Fr8qb3Libi6KOoFrGxpTt1+JOoV8vH64OyqEJVOl
	 Esb5OjPa021fOCowXOU9dbZWFdO2TjY4VGZ2qMKbS4dgqXcbVKoMGfJqE3td8iengM
	 U9h3gJgp+AjdqKjdzpcphssuRi1p+d3xJaVkFtRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Joel Stanley <joel@jms.id.au>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 90/91] powerpc/64: Add big-endian ELFv2 flavour to crypto VMX asm generation
Date: Mon, 21 Oct 2024 12:25:44 +0200
Message-ID: <20241021102253.324796295@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Piggin <npiggin@gmail.com>

commit 505ea33089dcfc3ee3201b0fcb94751165805413 upstream.

This allows asm generation for big-endian ELFv2 builds.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221128041539.1742489-4-npiggin@gmail.com
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/vmx/Makefile     |   12 +++++++++++-
 drivers/crypto/vmx/ppc-xlate.pl |   10 ++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -2,8 +2,18 @@
 obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
 vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o aes_xts.o ghash.o
 
+ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
+override flavour := linux-ppc64le
+else
+ifdef CONFIG_PPC64_ELF_ABI_V2
+override flavour := linux-ppc64-elfv2
+else
+override flavour := linux-ppc64
+endif
+endif
+
 quiet_cmd_perl = PERL    $@
-      cmd_perl = $(PERL) $< $(if $(CONFIG_CPU_LITTLE_ENDIAN), linux-ppc64le, linux-ppc64) > $@
+      cmd_perl = $(PERL) $< $(flavour) > $@
 
 targets += aesp8-ppc.S ghashp8-ppc.S
 
--- a/drivers/crypto/vmx/ppc-xlate.pl
+++ b/drivers/crypto/vmx/ppc-xlate.pl
@@ -9,6 +9,8 @@ open STDOUT,">$output" || die "can't ope
 
 my %GLOBALS;
 my $dotinlocallabels=($flavour=~/linux/)?1:0;
+my $elfv2abi=(($flavour =~ /linux-ppc64le/) or ($flavour =~ /linux-ppc64-elfv2/))?1:0;
+my $dotfunctions=($elfv2abi=~1)?0:1;
 
 ################################################################
 # directives which need special treatment on different platforms
@@ -40,7 +42,7 @@ my $globl = sub {
 };
 my $text = sub {
     my $ret = ($flavour =~ /aix/) ? ".csect\t.text[PR],7" : ".text";
-    $ret = ".abiversion	2\n".$ret	if ($flavour =~ /linux.*64le/);
+    $ret = ".abiversion	2\n".$ret	if ($elfv2abi);
     $ret;
 };
 my $machine = sub {
@@ -56,8 +58,8 @@ my $size = sub {
     if ($flavour =~ /linux/)
     {	shift;
 	my $name = shift; $name =~ s|^[\.\_]||;
-	my $ret  = ".size	$name,.-".($flavour=~/64$/?".":"").$name;
-	$ret .= "\n.size	.$name,.-.$name" if ($flavour=~/64$/);
+	my $ret  = ".size	$name,.-".($dotfunctions?".":"").$name;
+	$ret .= "\n.size	.$name,.-.$name" if ($dotfunctions);
 	$ret;
     }
     else
@@ -142,7 +144,7 @@ my $vmr = sub {
 
 # Some ABIs specify vrsave, special-purpose register #256, as reserved
 # for system use.
-my $no_vrsave = ($flavour =~ /linux-ppc64le/);
+my $no_vrsave = ($elfv2abi);
 my $mtspr = sub {
     my ($f,$idx,$ra) = @_;
     if ($idx == 256 && $no_vrsave) {


