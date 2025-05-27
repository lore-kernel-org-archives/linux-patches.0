Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2B527FD56;
	Tue, 27 May 2025 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364453; cv=none; b=FGqNWdiKwwvvk3l+xnLyFSWv6MbgWN/0IVfQW0qEPE8pWuduODZbdrv1Ln0QIxNPFXQRq5SQI7kvIXYey/iaST26P0EigBBEfaXGH27ax4NSceFSHwi4lZzCttmqyFsSsJQkWkhFWgnuZblgvA0TSQFWHF7DVGQRdOgLfij4Pb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364453; c=relaxed/simple;
	bh=JkSoNRrrrIvpYZ+meXywXinFnEWi45epu4M9r6YQdDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6aezQC4M+Xx7Ndx8X4v7FZxorY8yC0KLk3o7RRzhT5V+O2Y1jkPnf4bgN5yUV3hpwT/LL0H6vm/vdTvuQZnphGIv22u5zWsQD1Q3aThGErkT2QLJV7vEyU6JzE7sCeWKcv2L+CodMehZATnBE99rDb30xjZHe6SXhkba+89TuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEOu3OQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEOu3OQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE76C4CEE9;
	Tue, 27 May 2025 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364452;
	bh=JkSoNRrrrIvpYZ+meXywXinFnEWi45epu4M9r6YQdDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEOu3OQc8wTXtPc5q+7Pgi+0wnKJzpc7JxwCnjp06NKJ3KSl/zkSTpQGaVA5pJWhE
	 qaaokTNnbD5yCoyPZH7dLnbxbXv1FTFLfpgnWeKZKrOGL3yvl+H9ChK4ZGuF3WhHmg
	 hS7cVhDpp74crkobjH25GrSQC7M8bvRYhdPuIT1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/626] tpm: Convert warn to dbg in tpm2_start_auth_session()
Date: Tue, 27 May 2025 18:19:14 +0200
Message-ID: <20250527162447.540085134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan McDowell <noodles@meta.com>

[ Upstream commit 6359691b4fbcaf3ed86f53043a1f7c6cc54c09be ]

TPM2 sessions have been flushed lazily since commit df745e25098dc ("tpm:
Lazily flush the auth session").  If /dev/tpm{rm}0 is not accessed
in-between two in-kernel calls, it is possible that a TPM2 session is
re-started before the previous one has been completed.

This causes a spurios warning in a legit run-time condition, which is also
correctly addressed with a fast return path:

[    2.944047] tpm tpm0: auth session is active

Address the issue by changing dev_warn_once() call to a dev_dbg_once()
call.

[jarkko: Rewrote the commit message, and instead of dropping converted
 to a debug message.]
Signed-off-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-sessions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index ecea089157301..cf0b831540447 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -974,7 +974,7 @@ int tpm2_start_auth_session(struct tpm_chip *chip)
 	int rc;
 
 	if (chip->auth) {
-		dev_warn_once(&chip->dev, "auth session is active\n");
+		dev_dbg_once(&chip->dev, "auth session is active\n");
 		return 0;
 	}
 
-- 
2.39.5



