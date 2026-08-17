Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC133ACEFE;
	Mon, 17 Aug 2026 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978134; cv=none; b=i5eLAW1gsqgAgD/uyptm8ePzG+VN87TWtyJTJKYaLXU7O5YI5gDPJWrvQXezyAEk69RgCE95tYR/WsZRBrvNUb81CdT2Ru+pGYnt6lifJUV+Y5Hk5Q7e3MwQt4lNBrLqYHHnvqPL/FfPlh5m20M4AfSqvn82vLCllr7WCl2PNqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978134; c=relaxed/simple;
	bh=uN3EwmJXEO/lpCHRct2rC877T7NV90ghlh/XdLRQXOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqYSGJtK5+LOQ6RQhEnIGU1k7Jq49VEFC40HrIxPUCtDSE0Sf+GEw4vHJwi+WXBFxbFHmq8UbvIsIl+/Btz6GbPbdSsZvujRcmJSl8Z0zHmZhCR2suEhZxo71VCgnwwNwFLZIxXUB7i+tsodhuarRecud7xsaHNYcTX/qo1D91M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OrdA6pL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OrdA6pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95601F000E9;
	Mon, 17 Aug 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978133;
	bh=JhYfE+RteH3z3IKMsHWiCStX6EkinTxMaqK4LwoIOg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OrdA6pLlqg0hRJBmt7RPVOUG3hNJrojXjrqFdqHTJ16oX4Lxx7OLy3kGrv0k5P77
	 2hQuXcRJCg54txBV2YHmZWM96rDA6JvWjCLzUAtfraSYgvcRbnoaesAcnrfd7GRP7D
	 LWrNy10WuLwWtbFacmdvMU2xdq9yjraVorWqkMis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego GonzalezVillalobos <Diego.GonzalezVillalobos@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/181] crypto: ccp - Fix checks for SNP_VLEK_LOAD input buffer length
Date: Mon, 17 Aug 2026 15:33:26 +0200
Message-ID: <20260817132539.925724285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Roth <michael.roth@amd.com>

commit ed53a5050f42a3243a7ed8dfa49030e54034b952 upstream.

The SNP_VLEK_LOAD IOCTL currently fails due to sev_cmd_buffer_len()
returning the default expected buffer length of 0 instead of the correct
value, which would be sizeof(struct sev_user_data_snp_vlek_load). Add
specific handling for SNP_VLEK_LOAD so the correct expected size is
returned.

Reported-by: Diego GonzalezVillalobos <Diego.GonzalezVillalobos@amd.com>
Cc: Diego GonzalezVillalobos <Diego.GonzalezVillalobos@amd.com>
Fixes: 332d2c1d713e ("crypto: ccp: Add the SNP_VLEK_LOAD command")
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[Jack: sev_cmd_buffer_len() in queue/6.12 does not yet have the
 SEV_CMD_SNP_FEATURE_INFO case the upstream context line matched
 against (it lands in a later, unrelated commit not queued here),
 so the new SEV_CMD_SNP_VLEK_LOAD case was placed directly after
 SEV_CMD_SNP_COMMIT instead. No functional difference from upstream.]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7c05cae7e5778..6e08378eb5fac 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -226,6 +226,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
 	default:				return 0;
 	}
 
-- 
2.53.0



