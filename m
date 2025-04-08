Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EB126A0BF;
	Tue,  8 Apr 2025 10:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109977; cv=none; b=S4hUJte5XR78IVs1KW3311DD0nv1090ZLEWWynhfrD8MVLcsVLMEP+S24YjmKSytUXZ+glK5Wr9RSSiKTpAPivGBayVWgqO5VbeQMGPBExtUPIFHtZcJMHtDLg7rsn6ZzYW7TNTjWj6+GJwlZInnhmqHY3ovhPOhjiREjSn8h+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109977; c=relaxed/simple;
	bh=VzTkGgK2gT502HgjiHcFGg1lR1UE4ieKlSGsJu2jcMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDLhnlbhn0ug5IXLjxdBIok1Dq0UbZoH2pNhFcKyVB04h3BZW+CMYBmkwXwUp0Ngnh1JGfZkqCXqYCSaw+5dvnzgp4m9NzF7PDAoAyNJHX542mHvaHy2FV4HQezLJXWnsZEK3X+Rp65TZerYfzox9LoYubXMtFhkiPaZJ2o3Nlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBhANQ4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBhANQ4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD94C4CEE5;
	Tue,  8 Apr 2025 10:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109977;
	bh=VzTkGgK2gT502HgjiHcFGg1lR1UE4ieKlSGsJu2jcMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBhANQ4ekG2QcNefKS088hyex2a/zQyKolVtah0DEFkUnU4rGpP9P3DgO8/i07Lb0
	 amTLEoBATlqD8zNg2kGue42YwcXNW8Mcr+nVVv0v2QYDIZGDuEVJhKSeDw2WXehzs+
	 I0DkeQt5n6joiJXBjLWqF5h8aHh7wnsrv85lLv0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 5.10 086/227] ARM: shmobile: smp: Enforce shmobile_smp_* alignment
Date: Tue,  8 Apr 2025 12:47:44 +0200
Message-ID: <20250408104822.959784854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 379c590113ce46f605439d4887996c60ab8820cc upstream.

When the addresses of the shmobile_smp_mpidr, shmobile_smp_fn, and
shmobile_smp_arg variables are not multiples of 4 bytes, secondary CPU
bring-up fails:

    smp: Bringing up secondary CPUs ...
    CPU1: failed to come online
    CPU2: failed to come online
    CPU3: failed to come online
    smp: Brought up 1 node, 1 CPU

Fix this by adding the missing alignment directive.

Fixes: 4e960f52fce16a3b ("ARM: shmobile: Move shmobile_smp_{mpidr, fn, arg}[] from .text to .bss")
Closes: https://lore.kernel.org/r/CAMuHMdU=QR-JLgEHKWpsr6SbaZRc-Hz9r91JfpP8c3n2G-OjqA@mail.gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/c499234d559a0d95ad9472883e46077311051cd8.1741612208.git.geert+renesas@glider.be
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-shmobile/headsmp.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-shmobile/headsmp.S
+++ b/arch/arm/mach-shmobile/headsmp.S
@@ -136,6 +136,7 @@ ENDPROC(shmobile_smp_sleep)
 	.long	shmobile_smp_arg - 1b
 
 	.bss
+	.align	2
 	.globl	shmobile_smp_mpidr
 shmobile_smp_mpidr:
 	.space	NR_CPUS * 4


