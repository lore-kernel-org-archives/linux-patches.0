Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB6E1E89C;
	Tue, 27 May 2025 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366423; cv=none; b=Vcusul0VWGIeU7LdZCSTCAmNaPqZCjb/GP+rlS/F+3c8zAoZwWVwuz1M8BlvzgAeuACUaDZ4DsgO1ftDl1AwabEPFCBSi/1u3aHNn8OfFCJQKpINArXC4J/tqK1jXU+K8tATaRHFvsKMebduFevylkbNuEVO5g2qBlBDgAap230=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366423; c=relaxed/simple;
	bh=xkYVr6IOWl2tQWy7lglBVHlrE62z8DdU+0s66jP9JKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpMI4U3oux2oSaJU3ym9mQM0Hsnj9RMKjcof0XdgIcYTZFEkaR8JdOdJ0CXqerb/yUA87YEbT0Ditpx7FU9zlwA+qXf6vyhtcwtP25ybirSWuLnkc+InmEsknDKIDM+F26ltPY5vvp3ByFd4sdstri+pqjyP3KL0k+WWQGEZNQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=My9DJiHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="My9DJiHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9E4C4CEE9;
	Tue, 27 May 2025 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366423;
	bh=xkYVr6IOWl2tQWy7lglBVHlrE62z8DdU+0s66jP9JKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=My9DJiHJAlhA/I1ERbwO2xlDsXE0q8/bE47kUSno16oDfjVs+88Wj3l/v72vBhMRO
	 W8001e6sV8/GYrUto/4PUTixLKzSIoHZjGXIuLE59CbVLxsld9uyBK7N571M6HzoUr
	 4tGl1Bdmc6ihoVX+esdkm6BVl7as+QwrH6b/WgFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 063/783] tpm: Convert warn to dbg in tpm2_start_auth_session()
Date: Tue, 27 May 2025 18:17:40 +0200
Message-ID: <20250527162515.690855314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index a894dbc40e43b..7b5049b3d476e 100644
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



