Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB463BED30;
	Fri,  4 Sep 2026 05:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500899; cv=none; b=POd/2tg6SB3kvtGcGGdNo27dwXIFrCmMZ03pRA7/iN0wU34MgEoECBJ8MCRr8sOOGjYWroKQlECkGPEM2NftaGYAHBepDGCQyqCvGbeHczclMQKTARFc7lcgZr/wYHmpCqPoiJ4sLTKdGCsi7HlhdSxmFIz0JmeXS+e+jIQDbus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500899; c=relaxed/simple;
	bh=DJObuMLUdc4lkJcEvT6qdY1vLQbgRABp/be/pJqsHt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqMFXKS36KMkXX7lbveBwNh7cgEpjy6QrlVLn+oNrfmmwalRQ9PnKYAR0/3mYyND748lez/8xjbg1r7FZ3Yg34HGAgs140t9j7Rpge4bKx1rI9HI5BogTNThXiqKFtnZqf/5NzHwUur8tZsGui9Kwg8nwiK+7VHVitzw+jt5IpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIVP9rsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIVP9rsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A8F1F00A3D;
	Fri,  4 Sep 2026 05:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500898;
	bh=KVvGDRkRGUBBLd7Shupf9vaLTA2bOqkDI6EWR6+lYSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIVP9rsFLdKJyyIsxUYMIzTutb0HfHmGHm5/+FH6mNPf3a2+uCAamfLGqGcg938PP
	 CQcvQVdUmK8HcalTEUpVF1AmT8NfkQmFnfCpJVOt410xWMxE2B2DxIqCyW1hEl6aev
	 sOs+d7qZvsOXEu1PfyWPOgsBwYE804oZ5NCEEYH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.18 220/552] ARM: 9477/1: Disable broken eBPF JIT on the Risc PC
Date: Fri,  4 Sep 2026 06:56:17 +0200
Message-ID: <20260904045754.484222429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit 7e8ee82e69fde9d589272ec5e6f702358903be1f upstream.

The eBPF JIT unconditionally generates ldrh/strh instructions, which do
not function correctly on the Risc PC because its bus is unable to
signal half-word accesses. Work around this issue by disabling the eBPF
JIT when building for ARMv3 (the Risc PC is the only currently
supported machine whose kernel is built for ARMv3).

Comments from Ethan Nelson-Moore:

 From LKML: https://lore.kernel.org/all/CAD++jL=0qYGoygUwGEXQL7C_ROnC7kfpRv8RA+H5tNWwYu+pQA@mail.gmail.com/

 The commit message has been updated slightly relative to the version on LKML to clarify that the Risc PC is not actually ARMv3.

Fixes: 39c13c204bb1 ("arm: eBPF JIT compiler")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -96,7 +96,7 @@ config ARM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
 	select HAVE_ARM_SMCCC if CPU_V7
-	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
+	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32 && !CPU_32v3
 	select HAVE_CONTEXT_TRACKING_USER
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_BUILDTIME_MCOUNT_SORT


