Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AFB15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8280EC433C1;
	Tue,  8 Nov 2022 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916166;
	bh=udMOj4RmnI/70++N5+1bOmwL6qZMN1Lgadg5rZz7nUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ll3WK59kU/7n5oEwdCDBYG1nHlcH7aWAQwwrI6NRn3ForH1KEul5OPmz+jxVRlO7K
	 mZnmALA1jOH5cc3mccilMLpNJGoa3zDGlIkqX/5M5nQUstNmZ4k0Pgg7aLhR5rst7r
	 KVsl8hJqgq5H+RprT95BTjawJFnaINnPPUddQHfs=
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
Subject: [PATCH 5.15 083/144] efi/tpm: Pass correct address to memblock_reserve
Date: Tue,  8 Nov 2022 14:39:20 +0100
Message-Id: <20221108133348.796811842@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 8f665678e9e3..e8d69bd548f3 100644
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
2.35.1



