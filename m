Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543781A00CE;
	Tue, 21 Oct 2025 20:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077139; cv=none; b=YPs/o7CtKL0ZCbDQmRDTE2XwhsGCtz26B8fARC541aM8do2yCFh5VW1eiRXkMNrfK+obnc9LfqKu1AQdgJczjAJcMF/sU/570Qm6dDn9USiIjhqN+pBfJZpNW4VVJy2IzxijEElO/YgFIkLu5XSnqwGXyDHfW8AC3wX6N0qKW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077139; c=relaxed/simple;
	bh=JSpZ2LgfnqNhK8doxqza0A7czdKvp/kM7Uw8h4MwmT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdVbJiJACyP6rxsVpWr0wy7DaFJjORYcpypYdkLVIDQpKRrf6ZgCBFMiyVDxMDoc/0iZvybPN4gFFigfHEMCMO1mpsuOIZ3U6MHoq16k0Zvt9oKCUnaO8eKvEE1CmlxNiDUy10Fo5xkUwji+TPNfZNHsPPWbeUgHAr+55t1OFEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gk2fXIZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gk2fXIZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69CCC4CEF1;
	Tue, 21 Oct 2025 20:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077139;
	bh=JSpZ2LgfnqNhK8doxqza0A7czdKvp/kM7Uw8h4MwmT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gk2fXIZU9/pzu8Ih5o3KEmho0pssrBJ4DfX41CeuvVONKVesZXZut4/UPw2v7SkBt
	 9Dz+gy9zlhqXL3uPM5P5yFd911m1as1xzynEk0s5C24OwUqAnnU186xzRwjwQtxxaG
	 nrAItIsgojDQn59u7PM9mu8UlSGcVKs9nQ5LaBYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.17 012/159] x86/CPU/AMD: Prevent reset reasons from being retained across reboot
Date: Tue, 21 Oct 2025 21:49:49 +0200
Message-ID: <20251021195043.479090565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Rong Zhang <i@rong.moe>

commit e6416c2dfe23c9a6fec881fda22ebb9ae486cfc5 upstream.

The S5_RESET_STATUS register is parsed on boot and printed to kmsg.
However, this could sometimes be misleading and lead to users wasting a
lot of time on meaningless debugging for two reasons:

* Some bits are never cleared by hardware. It's the software's
responsibility to clear them as per the Processor Programming Reference
(see [1]).

* Some rare hardware-initiated platform resets do not update the
register at all.

In both cases, a previous reboot could leave its trace in the register,
resulting in users seeing unrelated reboot reasons while debugging random
reboots afterward.

Write the read value back to the register in order to clear all reason bits
since they are write-1-to-clear while the others must be preserved.

  [1]: https://bugzilla.kernel.org/show_bug.cgi?id=206537#attach_303991

  [ bp: Massage commit message. ]

Fixes: ab8131028710 ("x86/CPU/AMD: Print the reason for the last reset")
Signed-off-by: Rong Zhang <i@rong.moe>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/all/20250913144245.23237-1-i@rong.moe/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1338,11 +1338,23 @@ static __init int print_s5_reset_status_
 		return 0;
 
 	value = ioread32(addr);
-	iounmap(addr);
 
 	/* Value with "all bits set" is an error response and should be ignored. */
-	if (value == U32_MAX)
+	if (value == U32_MAX) {
+		iounmap(addr);
 		return 0;
+	}
+
+	/*
+	 * Clear all reason bits so they won't be retained if the next reset
+	 * does not update the register. Besides, some bits are never cleared by
+	 * hardware so it's software's responsibility to clear them.
+	 *
+	 * Writing the value back effectively clears all reason bits as they are
+	 * write-1-to-clear.
+	 */
+	iowrite32(value, addr);
+	iounmap(addr);
 
 	for (i = 0; i < ARRAY_SIZE(s5_reset_reason_txt); i++) {
 		if (!(value & BIT(i)))


