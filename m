Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C698223C4D;
	Thu, 12 Dec 2024 17:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025081; cv=none; b=erFbDiHLx1K+5gw7PbAiCgcRKgY6G7nbm7BPBm4fVYUOnaVCDrGk1PUi4ycm5WRUU6g2oJW/U+6tq3F6jWwnfj6Tl4VZtfXLT0SCkEp86I7IE58z/8yjvW88lqctvrSeVSFhvyc/o4mRajmlFQXU7DBafBLmnJwcwTCHX4o4iuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025081; c=relaxed/simple;
	bh=SF0RB7dBCrY+ZVkHfLv8RiXP87IQmRp7cTF2L6wBgDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbUvKwTNu+rKLHpYxoyj1ll6GoO4fdigBLFdmXbET6Etbp3NzGAYYLKhkPks7JZPOTS3w2rJ3fNsXVLNL62jg2O29ZZZd3Gpm+MKOdDB/kgO6EZ/mfuxEysoxVBzhvA4V97B61xdiLnaFE+Pqf29lpPqJxomDG7f2M/R6ntnJUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DChVhCpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DChVhCpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20D4C4CED0;
	Thu, 12 Dec 2024 17:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025081;
	bh=SF0RB7dBCrY+ZVkHfLv8RiXP87IQmRp7cTF2L6wBgDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DChVhCpHZDYFpIfs8/oF8Pyl4SsTE4W4r1M7SeoFs9Dg5bugc1xGNLLW0YZHq7ops
	 BC3kZ0drmBMQLERiYyhVmA6XIHCsjtaoje2olnUgzhY5unekzmI6NNtfD0gLe7f7ZS
	 /DIg2I4lwGfz4HaNEm1ueoaR4GsZfhsKLox9efiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Garrett <mjg59@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Bartosz Szczepanek <bsz@semihalf.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/321] efi/tpm: Pass correct address to memblock_reserve
Date: Thu, 12 Dec 2024 15:59:28 +0100
Message-ID: <20241212144231.971847399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit f4cd18c5b2000df0c382f6530eeca9141ea41faf ]

memblock_reserve() expects a physical address, but the address being
passed for the TPM final events log is what was returned from
early_memremap(). This results in something like the following:

[    0.000000] memblock_reserve: [0xffffffffff2c0000-0xffffffffff2c00e4] efi_tpm_eventlog_init+0x324/0x370

Pass the address from efi like what is done for the TPM events log.

Fixes: c46f3405692d ("tpm: Reserve the TPM final events table")
Cc: Matthew Garrett <mjg59@google.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Bartosz Szczepanek <bsz@semihalf.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Stable-dep-of: e6d654e9f5a9 ("tpm: fix signed/unsigned bug when checking event logs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 8f665678e9e39..e8d69bd548f3f 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -97,7 +97,7 @@ int __init efi_tpm_eventlog_init(void)
 		goto out_calc;
 	}
 
-	memblock_reserve((unsigned long)final_tbl,
+	memblock_reserve(efi.tpm_final_log,
 			 tbl_size + sizeof(*final_tbl));
 	efi_tpm_final_log_size = tbl_size;
 
-- 
2.43.0



