Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2111198A0D;
	Wed,  5 Mar 2025 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197071; cv=none; b=tw0IUcXuKM/yA7KKGA+AOcgcmb5tLJbjFmr2XMGKkT1VvrkJeL65ucvNAcj0FOzB2qz5SvcZAhcodulD+UrMw6x6rCbDv/HPOmmLQfOJ1ixbC6aXe6DoHUYWyHp6QJzHZTIkomJ85TAGnZlpYhCwUjtxSjSf+v0Qah+aFn+Vkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197071; c=relaxed/simple;
	bh=vXzFk+B0eHu8vxaQ3MOHj4I8MCaluXcF18XZV97wjVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXQ8A0ACM4wPUy1yW2ItrLE9ZnoDIF5sXq4NgcGdwiQPZ6XrLWzyRdqA14lMXxDY4Ibn9fGAnKPoQlWmdjBCKjsrVV5gimibQWqm3cQcvxvGTwjf0fq/T3BS05AtExEG2o/UxM2W37AuCfUfjVpbBcuh97ThGmAp15JK2wvgmrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sc3lOkTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sc3lOkTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61263C4CED1;
	Wed,  5 Mar 2025 17:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197071;
	bh=vXzFk+B0eHu8vxaQ3MOHj4I8MCaluXcF18XZV97wjVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sc3lOkTq/hmK4EpNrpiSdRs0D5T2rzpSTViQrZx/d227sKWGriX6aYmq+ZjRhalnO
	 U9iGvTvoBvTWDwzXN2fJh3NkAQjCKHPXZtAI9MYh/vK7p1flCn2v6a7jaKpg1dAUGD
	 uFtIng7atoKOKEZfnJoIyD8OjAFoeePgB0/1FIFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Andy Liang <andy.liang@hpe.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Takashi Iwai <tiwai@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/176] tpm: Change to kvalloc() in eventlog/acpi.c
Date: Wed,  5 Mar 2025 18:46:38 +0100
Message-ID: <20250305174506.631286995@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit a3a860bc0fd6c07332e4911cf9a238d20de90173 ]

The following failure was reported on HPE ProLiant D320:

[   10.693310][    T1] tpm_tis STM0925:00: 2.0 TPM (device-id 0x3, rev-id 0)
[   10.848132][    T1] ------------[ cut here ]------------
[   10.853559][    T1] WARNING: CPU: 59 PID: 1 at mm/page_alloc.c:4727 __alloc_pages_noprof+0x2ca/0x330
[   10.862827][    T1] Modules linked in:
[   10.866671][    T1] CPU: 59 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.0-lp155.2.g52785e2-default #1 openSUSE Tumbleweed (unreleased) 588cd98293a7c9eba9013378d807364c088c9375
[   10.882741][    T1] Hardware name: HPE ProLiant DL320 Gen12/ProLiant DL320 Gen12, BIOS 1.20 10/28/2024
[   10.892170][    T1] RIP: 0010:__alloc_pages_noprof+0x2ca/0x330
[   10.898103][    T1] Code: 24 08 e9 4a fe ff ff e8 34 36 fa ff e9 88 fe ff ff 83 fe 0a 0f 86 b3 fd ff ff 80 3d 01 e7 ce 01 00 75 09 c6 05 f8 e6 ce 01 01 <0f> 0b 45 31 ff e9 e5 fe ff ff f7 c2 00 00 08 00 75 42 89 d9 80 e1
[   10.917750][    T1] RSP: 0000:ffffb7cf40077980 EFLAGS: 00010246
[   10.923777][    T1] RAX: 0000000000000000 RBX: 0000000000040cc0 RCX: 0000000000000000
[   10.931727][    T1] RDX: 0000000000000000 RSI: 000000000000000c RDI: 0000000000040cc0

The above transcript shows that ACPI pointed a 16 MiB buffer for the log
events because RSI maps to the 'order' parameter of __alloc_pages_noprof().
Address the bug by moving from devm_kmalloc() to devm_add_action() and
kvmalloc() and devm_add_action().

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org # v2.6.16+
Fixes: 55a82ab3181b ("[PATCH] tpm: add bios measurement log")
Reported-by: Andy Liang <andy.liang@hpe.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219495
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Andy Liang <andy.liang@hpe.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/eventlog/acpi.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/eventlog/acpi.c b/drivers/char/tpm/eventlog/acpi.c
index bd757d836c5cf..1a5644051d310 100644
--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -63,6 +63,11 @@ static bool tpm_is_tpm2_log(void *bios_event_log, u64 len)
 	return n == 0;
 }
 
+static void tpm_bios_log_free(void *data)
+{
+	kvfree(data);
+}
+
 /* read binary bios log */
 int tpm_read_log_acpi(struct tpm_chip *chip)
 {
@@ -136,7 +141,7 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 	}
 
 	/* malloc EventLog space */
-	log->bios_event_log = devm_kmalloc(&chip->dev, len, GFP_KERNEL);
+	log->bios_event_log = kvmalloc(len, GFP_KERNEL);
 	if (!log->bios_event_log)
 		return -ENOMEM;
 
@@ -162,10 +167,16 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 		goto err;
 	}
 
+	ret = devm_add_action(&chip->dev, tpm_bios_log_free, log->bios_event_log);
+	if (ret) {
+		log->bios_event_log = NULL;
+		goto err;
+	}
+
 	return format;
 
 err:
-	devm_kfree(&chip->dev, log->bios_event_log);
+	tpm_bios_log_free(log->bios_event_log);
 	log->bios_event_log = NULL;
 	return ret;
 }
-- 
2.39.5



