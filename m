Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054111;
	b=mdeisHabeqAC6KDVrOxHos8Q7ZSqfV69CGsVjL4VDmv/vVf4447TguhXc6FWlsbP2ueN
	 Dd3uqeVQGDBD5tOnD8StmWwTHXr5qdfBq1ws23FlwC/7if+JekZa64YWJ3yYmn5BVUNA6
	 fQxgrZ2EvpDyrH1pIYzi6eKIqCGLojmo1GpD6+yDN2bF2oUZDA73b4anKovXnB6wJ75Z4
	 inzEoefFBVNop2TCB8vk5+LNoNulT9g1lY490VH3U5p71WKblsZTTIWx/Iu5kx9bbidQz
	 1lLMf8w8zLuk4mERIV/Sx2M8o8ImhAk/RoiEznOkMEdWwLO9/vgkz49CnIPHMiOspgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q46CyaoBKcnp5zLtDz7uXvwpbpdUy9dNQhtAuCRlGfY=;
	b=Gln6RtfP0YeOSfsgbEvuO7VfZ2oD74OZM6RTthyFo1AwGVEJ+7VfkRn4fIF+rhdqaCre
	 FNna9hBfH+CR185bmgVDXggluBhnYQUH7/+7XifT4UoI6VZBsVAzn2Z+MwFL2OVb1JstN
	 tIqmkMHcunJVcbrUuSRKJnSOWoKpIza1eC6Se3HaSRLEUUmXvngwmrCFrkRZ7warohx7c
	 YAI/CZUWW8Q4wBKVT5WmPyLGjb2vWMUIcVB+SWKm3j/DskUtkI7GuRygRmcymv8oQO5wN
	 paJdEuWgLZrtkHJ6KRlsyMTmjgvVDmoW8ZiVwO/6xgM+4Cn4J+lIJsxm/26+EhRZsNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgeO5GYi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0769606A31C;
	Thu, 19 Nov 2026 02:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgeO5GYi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAB61F000C4;
	Thu, 19 Nov 2026 02:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054110;
	bh=Q46CyaoBKcnp5zLtDz7uXvwpbpdUy9dNQhtAuCRlGfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgeO5GYiLXs1izjW5xbJP6mLfrofQ9DECgI+WWYeSzWQ/ZZ+OX3e/eOcyhRQljyCJ
	 8cXyyx/1zgHbQ7N0W9MJDEf8Wnjw0JeZW7UzWA4mmaBnK+DglSczV5OdA5qt/z8nNP
	 K8TVuyZ8pn2CDtl8g86e0TWTy9hsD9DOvgCTvSGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1115/2214] tpm: tpm2_probe: propagate transport errors
Date: Wed, 18 Nov 2026 15:46:31 +0100
Message-ID: <20261118150056.729500670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced the early return with rc = 0 to preserve tpm_buf_destroy() cleanup of the stack-allocated buffer ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 440b703e29e5f..662642c59f6d3 100644
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



