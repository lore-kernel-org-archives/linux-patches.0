Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029852;
	b=MjAeaJwIQCk29uWuFx16M9LFJLMt7ombJKsCMsHtiLNF1UiCX3WLoj56jVRww+aGIuHA
	 nEbZnqp6eNkmjLO1n8XrvDoU8yywFRpBD0r1EJymD6+8MhYv8iG1nnFdpxheGFy4GU1r1
	 dG/q472F9gJKOw/QqhhAnBvIthc0GfH8DS+sKNkujp8ZJD/A55eeXU3LSwVQ8xLplwtgB
	 t+yUO/7UQ1JZ7nTx2qAdzVQScIG05Y/SyDgBjIXq6l1lJ2l/hZXvhBDuVZvQ420GDU9vr
	 WeoV33kxViLHOC2R2P48mO0EvHUJrLyzJhQ4yEiXa+sAKGGpJXZ75VMd0fopJvO9HNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=65GdzSOYRyeYSTFMJUN3FHbtNaMOye1ddHRXWIaS5Eo=;
	b=kpgr9+9SrLeZ2TQ+qyixRiqz39z6WEmyDlzZBVSg9hQDrfedF08k5h2z4AEjnP7xpd60
	 +emxv5vtSgyiay/rme76Zf29qmMtBRychSOEIMZyI4m3qjMePYmCpftEmnjKO6sIFCsND
	 YujAoqCBmdrB21BwXvbqHwmRz5wS0MVkzHsXzfat+ztSk+zlnEOuHe1WOijLOS6li0LY3
	 YXjkbdQjC1VYbTJ3XHqba5jyj8EZBGWyT5xudFYUP+0JWEMj0kgIdElSXEN/sGd6LU9dW
	 /tRfbz31Z/18HbAJrdgilrMrMOn6aitejZFLt4jYAqBhXnlfD4ynkwG1oHAs2QScUhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SQYiLWH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB40606A31C;
	Wed, 18 Nov 2026 19:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SQYiLWH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6171F000C4;
	Wed, 18 Nov 2026 19:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029852;
	bh=65GdzSOYRyeYSTFMJUN3FHbtNaMOye1ddHRXWIaS5Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SQYiLWH6xKzpypCFPDqD1n0NffHy15I/z+3mYLooaRriope/R33VcteyIqXAVYa2
	 R3kyYGPiHfTSgFYRVjtwNeKPTP47P2U946abLXwZwDguvS2B9mbDL8nUPLGfVKrVeE
	 e7HzLg88npT1nX4wUBtz66JtEWRQR23m5ZdzI1ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0496/1756] RDMA/irdma: Fix erroneous -ENOMEM for large MR registration
Date: Wed, 18 Nov 2026 15:43:43 +0100
Message-ID: <20261118150028.835713135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 5bb710151753fe53047b1d34b1b54d0f179cec68 ]

Commit cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
replaced the explicit level1_only boolean with a bit mask
but did not properly convert the "if (level1_only)" check
in irdma_get_pble() to be "lvl == PBLE_LEVEL_1" and instead
left it as "if (lvl)".

User MR registration passes "lvl = PBLE_LEVEL_1 | PBLE_LEVEL_2"
so this check always evaluates to true and causes the
loop to bail after grabbing a single SD even if the region
actually requires more than one SD (as is the case for
regions larger than 1 GiB with 4k pages). As a result, these
registrations can fail with -ENOMEM even if there are
sufficient PBLE resources.

Fixes: cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260915170317.2901672-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index bd9e7b7f6ca34..9370fce3cc8e3 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -474,7 +474,7 @@ int irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 
 		status = get_lvl1_lvl2_pble(pble_rsrc, palloc, lvl);
 		/* if level1_only, only go through it once */
-		if (!status || lvl)
+		if (!status || lvl == PBLE_LEVEL_1)
 			break;
 	}
 
-- 
2.53.0



