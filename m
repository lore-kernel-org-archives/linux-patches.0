Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3E618C034;
	Thu, 17 Apr 2025 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912980; cv=none; b=c2Dscg/+38BRBC/MH5VurkLlkoeaEkYtPf3bd9wNwmCog9jNkdfmWpQcG6bBAm6EZTtSBazLwSNjVE6E6HgD7Rtr+m+2eqLLLrvj4wgF/L30NxZcOfeDB+A2lBikapqfqERF4+FDKyxFWmtQNQM2/l25L3ApJflguLbxzqTMzX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912980; c=relaxed/simple;
	bh=iIRi9/353erOrkrxASAG5XHC0hO2QfTwyuOsQ1pzF9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ubkujkr0zbfczx/fzIzs9LcI91p9bpn/xX/04dlh5OYMFAkg31mmZeWZtEoy1OKs4on1wH7l2C3mybqoz4B7fYII8IeE5BEgTiUcFVtsb7ayHkQYcqBi25eSBI17dC2MBm5tp6ZzsGLlpRDbIzo2CVoD41bqw1FJkncJ21pFrFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=untsye+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="untsye+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA9EC4CEE4;
	Thu, 17 Apr 2025 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912980;
	bh=iIRi9/353erOrkrxASAG5XHC0hO2QfTwyuOsQ1pzF9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=untsye+ZOwKaYtKHwmPA2Bdwo/6TQ4aCpi1BPv4MjEik/IrPqSKb54i4/p+qt9+VC
	 yljGVBWKkbFOX8aUPVTi8WGAfmyGXEBe0P+jci0WgjIUcUSN/s/4LprDe7vw5rsoZ/
	 5JH/prG7H2Zoza17a2Y9IPTLSmIqswZt8HsdobtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 187/449] tpm: End any active auth session before shutdown
Date: Thu, 17 Apr 2025 19:47:55 +0200
Message-ID: <20250417175125.498487909@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan McDowell <noodles@meta.com>

[ Upstream commit 1dbf74e00a5f882b04b398399b6def65cd51ef21 ]

Lazy flushing of TPM auth sessions can interact badly with IMA + kexec,
resulting in loaded session handles being leaked across the kexec and
not cleaned up. Fix by ensuring any active auth session is ended before
the TPM is told about the shutdown, matching what is done when
suspending.

Before:

root@debian-qemu-efi:~# tpm2_getcap handles-loaded-session
root@debian-qemu-efi:~# tpm2_getcap handles-saved-session
root@debian-qemu-efi:~# kexec --load --kexec-file-syscall …
root@debian-qemu-efi:~# systemctl kexec
…
root@debian-qemu-efi:~# tpm2_getcap handles-loaded-session
- 0x2000000
root@debian-qemu-efi:~# tpm2_getcap handles-saved-session
root@debian-qemu-efi:~#
(repeat kexec steps)
root@debian-qemu-efi:~# tpm2_getcap handles-loaded-session
- 0x2000000
- 0x2000001
root@debian-qemu-efi:~# tpm2_getcap handles-saved-session
root@debian-qemu-efi:~#

After:

root@debian-qemu-efi:~# tpm2_getcap handles-loaded-session
root@debian-qemu-efi:~# tpm2_getcap handles-saved-session
root@debian-qemu-efi:~# kexec --load --kexec-file-syscall …
root@debian-qemu-efi:~# systemctl kexec
…
root@debian-qemu-efi:~# tpm2_getcap handles-loaded-session
root@debian-qemu-efi:~# tpm2_getcap handles-saved-session
root@debian-qemu-efi:~#

Signed-off-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 7df7abaf3e526..87f01269b9b53 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -300,6 +300,7 @@ int tpm_class_shutdown(struct device *dev)
 	down_write(&chip->ops_sem);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		if (!tpm_chip_start(chip)) {
+			tpm2_end_auth_session(chip);
 			tpm2_shutdown(chip, TPM2_SU_CLEAR);
 			tpm_chip_stop(chip);
 		}
-- 
2.39.5



