Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038546;
	b=qYoTz9LQWHpBvHteI28LvsDsQzg1xU/zo4IU7ZgjvKolidOg+8fX543sbLCmxCF2qPHO
	 c3sF+c4ZyZ9sl4YzXqm59Jf2yE9+j5ge3UHMtSX2B+KmOO8yl0twv7LCwiqLmJpElgOmD
	 azfI3OAYz+D790NsDkqqCFTGtKZGpSEctAmGdTQb5teYuOSdZNA6PpsVSWiAbnR2GPKHM
	 uOfpz81yZrqo1OlvQ/O6wjUZyPDCapUFhjCKw5DqsEjIrgHdvc6jzDSZBUgN9grslvnuN
	 F323eA5PAapw+pLrBM4mor4CiZ2vsWXgBpp/fPLvc4LpIGwq1VzucEhAzgSvImM/f5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvNVyZ8F69ShkN39WL+nWnBKzTUTYIZNjchA91coZAw=;
	b=QEX24N2zTzBRLyBabl65PwilgcGtsNOsWxOgB1L3VN7+UYcNnBtxCkXORTXzQX3A1vvy
	 ASIQqGDuSoOpfZJrK5chTrOY8W9cyZZ0dratWqOHpIpGcvDB2iHkA3RnSpLY/Fqg8jB+b
	 F6Cp8kybmR4ZDqmn1i9iuhUHbMsmo7k8SRmBTsPlRBKcqZ7DckoNn5ChculW8Pho3/RJ1
	 HoIPiPMAM3e/IWgZzDITb0r5d9+AOTW+C0c5/NibtK2wcfZQWjF4Do033xF8YNKTtIl8t
	 WMPbHAGMMcO34CYnSaBiG5jJNCbpz988Ki5cpSAQ0XivtX3yvkl00hJAsNWZCvrRcHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHQIQmJa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4CA606A333;
	Wed, 18 Nov 2026 21:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHQIQmJa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A591F000C4;
	Wed, 18 Nov 2026 21:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038546;
	bh=rvNVyZ8F69ShkN39WL+nWnBKzTUTYIZNjchA91coZAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHQIQmJaHq2oukktJz0YfDkTDlm4FbiZSmL6zgb1T1jG25iP3FJzO/eXwoBxZmYI0
	 P0FzYny5WyyiTwe2cuX6KYhDCxxA0mkXMZl6sWoqgkiQXFQ2qvcoEQclLMiCsH3ts7
	 MvZsBhOPhid7W6vmJw55sMqMa+TnO8beQLdfYejw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1779/3318] tpm: tpm2_probe: propagate transport errors
Date: Wed, 18 Nov 2026 15:40:01 +0100
Message-ID: <20261118150415.229283882@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 7d4f1cbfe063af5581dac66abe9e9c965e1031cc ]

tpm2_probe() reads the protocol version from the response tag and is
documented to return -errno on failure, but it always returns 0.  A
transport error (tpm_transmit_cmd() < 0) is thus swallowed together with
the intentionally ignored TPM response code, leaving TPM_CHIP_FLAG_TPM2
unset. A transient bus failure on the first command then misdetects a
TPM 2.0 as a 1.2 and the probe fails on the TPM 1.2 path:

  tpm_tis_i2c 0-002e: 1.2 TPM (device-id 0x1C, rev-id 22)
  tpm tpm0: A TPM error (-62) occurred attempting to determine the timeouts

Return the transport error instead; rc >= 0 still means a valid header was
received and the TPM's own response code is still ignored.

Fixes: 94e266ba1fa3 ("tpm: migrate tpm2_probe() to use struct tpm_buf")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20261001060114.1582092-1-alexander.sverdlin@siemens.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
[ sashal: Replaced the early return with rc = 0 to preserve cleanup of the stack-allocated buffer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 57bb3e34b770f..d01d90beab788 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -507,9 +507,10 @@ int tpm2_probe(struct tpm_chip *chip)
 		out = (struct tpm_header *)buf.data;
 		if (be16_to_cpu(out->tag) == TPM2_ST_NO_SESSIONS)
 			chip->flags |= TPM_CHIP_FLAG_TPM2;
+		rc = 0;
 	}
 	tpm_buf_destroy(&buf);
-	return 0;
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm2_probe);
 
-- 
2.53.0



