Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8F37C92A;
	Thu, 20 Aug 2026 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238241; cv=none; b=T6dJLsNT730dKnF/CaYpOX51i3tfRhrXFQYHl9tGuTRVQEKIcgUAetIz9DH0Ji/zldT8+SzVOgtZvoz6F4XcFhgIRFRG4EBjQgUiO/UtzwMlF4m1Ey1hUDLQv3KLmrmAeXjkzynsOF2dO5QYZPMInLaGOphmh1C4wCGIUXryJ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238241; c=relaxed/simple;
	bh=CYAdaI/jDzTtKNrdC1pAvYVmWE3zkRykwklTjITUFhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mm+/DyHCY86n003RGKD+gk24/xE/BlfOVbMKm7fMLlVmFGFjTLWdlIGri6iuLHVKLxpg3bh4JpNVVwLzrpovJb23GlW3qPS1I7bWUhQV+GitggdNVh968bNftzlqN4VNJDoNdx8rjFTwmg6jz/dGzmvXLOrQU50xdFXGraTk3v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3E1MWtN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3E1MWtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE1E1F000E9;
	Thu, 20 Aug 2026 15:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238240;
	bh=C0P1o27a924MD2v0Mf1We4u9XacDtTZ0ku/e+CmODk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3E1MWtNHJnbcYM4RIAB1Ayh7xUn9AGFmJ4W9F41yrAP3hWCJZy+QL9bscut+EV6L
	 uDfAMiayHZd9MGfQordOE6ZCOWRTGv1LXE2oEznafBPc/5x49ySvrcsY2n/fKNamDc
	 WfoymlQiFHTwz+W70bgj+w54NYQKCfHQjee90dPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 079/228] mmc: omap_hsmmc: fix busy_timeout overflow in ns conversion on 32-bit
Date: Thu, 20 Aug 2026 16:53:41 +0200
Message-ID: <20260820145246.875802897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit f64ea900e4bda3055ef24a2c906f8d049cf1c3bd upstream.

omap_hsmmc_prepare_data() converts the command busy timeout to nanoseconds
with:

	timeout = req->cmd->busy_timeout * NSEC_PER_MSEC;

busy_timeout is an unsigned int (milliseconds) and timeout is a u64, but
NSEC_PER_MSEC is 1000000L.  On 32-bit builds the multiplication is
performed in 32-bit arithmetic and wraps for busy_timeout values above
~4294 ms, before the result is assigned to the u64.

The driver does not set mmc->max_busy_timeout, so the core does not cap the
busy timeout, and commands such as erase or SANITIZE (MMC_SANITIZE_TIMEOUT_MS
is 240000 ms) can pass a busy_timeout far larger than 4294 ms.  The wrapped,
much smaller ns value is then programmed via set_data_timeout(), so the data
timeout is set too short and the operation can time out prematurely.

Cast busy_timeout to u64 before the multiplication so the conversion is done
in 64-bit arithmetic.

Fixes: 8cc9a3e73de1 ("mmc: host: omap_hsmmc: use generic_cmd6_time to program timeout value for CMD6")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1357,7 +1357,7 @@ omap_hsmmc_prepare_data(struct omap_hsmm
 	if (req->data == NULL) {
 		OMAP_HSMMC_WRITE(host->base, BLK, 0);
 		if (req->cmd->flags & MMC_RSP_BUSY) {
-			timeout = req->cmd->busy_timeout * NSEC_PER_MSEC;
+			timeout = (u64)req->cmd->busy_timeout * NSEC_PER_MSEC;
 
 			/*
 			 * Set an arbitrary 100ms data timeout for commands with


