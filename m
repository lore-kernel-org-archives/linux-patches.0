Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624173;
	b=a8TygK3lcPhualN/cBr4cVrjrhlDIIyaDFNXXDWEjH1AFez4i0UT0yq/q71RoFS0kyiO
	 1ErTSCyWGL9kZsnQIl6mf6jkWrH+gE4nBlcGPE58ZXluDPcuM4rnFdzY9rwBoXkLjcJtO
	 yk6aZ8Hn0RGjvfvbYqPDR7U1GdmOt0opA34VDMr91YrYBeh96OwcyZheprTAZKOXrWHGh
	 AwAwET4kpVJcSJfpQhVzzLEdWZ4EzrgjIk5GRKCdX1sAQwH1qUQ39Xgph/aE/OZGg1U8q
	 zDvoJg4r7dzKFCd7oCSExP2otBfoBv7FXPFNnN3vTG+JgHkhde/SUZCjWdbhjtte5yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LjK5uOpmND3uPA0jXdqdbHjxpNVgIjKWkfHpHIoUPhQ=;
	b=RlHvqe0MwNcS0bxYkQnlgUFLF1H4POd8n63D0nGaMh1QNRbI2iuj1/61Kyidx2nsvgUa
	 /cj7jP7hp3UW8pFBLA7HH7tAjKdZck5STg2blvJrsIorGUejnfuVDiWqxdKZSQDNsNYXj
	 7sAf6Is/Zv/tl6PqRiqaj/UlThBp3+X/uKf5lgpUiLJKPwGn+mAMQZ7SDQmfpyTatVabP
	 RQpOeKqX9eiZQZo1O9fsQrzgx58MkeihQ9qCTuwqQddPX0K8hXzN7lOTowyOyAekfGtdz
	 PqH/NVVWLZIcCYzY7uWzBWmS25pC7vYPN6YymDn9SoX0MHpw3LMHlk92Pqm2LS9nhXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEPkKE3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22C3606A32C;
	Wed, 25 Nov 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEPkKE3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ED21F000C0;
	Wed, 25 Nov 2026 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624172;
	bh=LjK5uOpmND3uPA0jXdqdbHjxpNVgIjKWkfHpHIoUPhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEPkKE3l8SCSOo+DGb2UK531oG8w2n77sW3nNlvSvBn0tgUE0UzFhFbZxaj2H+gfB
	 waNtVsK/cLWtF82zyJdzMg12sJgaN+NSxSNx4gf7Q9lZz7ehB9iFo+zI0Kh/E0NYwP
	 ZZanrz3MxeGzg3Br8HOme7cxsPkybQ9LlQEZ6TNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/816] net/smc: fix limit_smc_hs sysctl on big-endian architecture
Date: Wed, 25 Nov 2026 15:27:09 +0100
Message-ID: <20261125143851.095164645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 162cf592b577cccf04515100563e819d9eba5c4a ]

net->smc.limit_smc_hs is a bool, but its sysctl entry uses
proc_dointvec_minmax() with .maxlen = sizeof(int), so the handler
accesses four bytes at the address of a one-byte field.

On little-endian this works with the extra bytes being written in struct
padding. On big-endian (tested on s390x) the bool sits at the most
significant byte of the int therefore the bool stays false and the "1"
goes into padding. The sysctl reads back 1 but SMC sockets created
afterwards see limit_smc_hs as disabled.

Fix this by using proc_dobool() handler and adjust the maxlen to the
right value.

Fixes: f8406a2fd279 ("net/smc: add sysctl for smc_limit_hs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20261028225350.3753-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_sysctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 2fab6456f7654..7da98bd5287ae 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -93,11 +93,9 @@ static struct ctl_table smc_table[] = {
 	{
 		.procname	= "limit_smc_hs",
 		.data		= &init_net.smc.limit_smc_hs,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(bool),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.proc_handler	= proc_dobool,
 	},
 };
 
-- 
2.53.0



