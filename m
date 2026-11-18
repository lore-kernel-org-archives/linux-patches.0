Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027403;
	b=0shCu6H07S/caKt1Wn4aypbLtYMsapWzKKzsnUpNMse9NNBzRpT9I3zR97UAf6LCyHvR
	 vA2V9BoBQ8fXO3sh0sb3uTAkVj7ot9U+vRwI5aublXJJiUrNPIZpJ5CsQm3i5Jyyh8AvM
	 oSqbZanzS5FYjDjbeHNgWsepruVBSO6OaSvbm4kQxK6k0ygOal7i84DwkcV85iI7GQKfI
	 PPAL+IhpgYZKugsJ1/k726VXRS+VJCMcr6Bev2waF6z3KC+vdRxdeuVBNZUa27diRV1GO
	 6p0lhaUjEMtWy4QiMYAFmSWeY3xfmFQyMo8EUkXe4B97YaLHxkKgcucCgAtYvf8ci5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xC61WVh8N726k08EFsnF/tO9zf5natJecxkr9r83yG4=;
	b=qq9YODVx7VplZ/Rr3HG5EGKDfCZwyUHg4T5l9KO0v4P2TJLcbgteWR5ITGBiVS35jA6e
	 vtvm94ENHIHKViqj9ECroevY3eQeDpITXR3Jsr6CMoAbErNIMPqNIC+8IfE7Cc3/rolp/
	 r9fH+LILtDs/R7CAOcJVIi3mRDHp1+CdlZiFJ+TEu4u+RQsKmRZ2dizlzzyLfi8coeyWc
	 rH58NCw6SEciJfcjqA451Ofx/U3hkh2rFytN3D3Uj6VCgBoXjsIRsycDFMPqjj38q05wR
	 DtvSC04NBJPsClCxzykKtcpAlo88on35ghfMaV4hSunf4mxMjlav7v2z4iM4N5H1/yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D03FU3Dk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AC060A2612;
	Wed, 18 Nov 2026 18:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D03FU3Dk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB81F000C4;
	Wed, 18 Nov 2026 18:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027403;
	bh=xC61WVh8N726k08EFsnF/tO9zf5natJecxkr9r83yG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D03FU3DkAZzEeUXb3qoEa0Uvbykqe2wESkXqplq8peyTEhbGzmFbHz3oGTmVPAB2b
	 rV5DG5AXKy/1EmzYBiaw0K9FHEYKjaChu+SSYuM2Fxes/xxkXtHwtgHFynbn7+/l6b
	 KfDoIWK4xVxxcvnaW9yNymOVa7u2LSxqC+DGUVa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1775/2151] tools/power turbostat: pmt: Improve sscanf() hygiene
Date: Wed, 18 Nov 2026 15:58:30 +0100
Message-ID: <20261118150226.488260188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit e817a533bbc0aef5a9cb6255153941ed968d2fb1 ]

Explicitly check sscanf() return values for number of matches,
and handle EOF (-1).

Defensive programming -- not an issue actively seen by users.

Fixes: 4265a86582ea ("tools/power turbostat: Add PMT directory iterator helper")
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index fb8f679549279..1b9983be4dfc9 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1880,15 +1880,17 @@ int pmt_telemdir_filter(const struct dirent *e)
 {
 	unsigned int dummy;
 
-	return sscanf(e->d_name, "telem%u", &dummy);
+	return (sscanf(e->d_name, "telem%u", &dummy) == 1);
 }
 
 int pmt_telemdir_sort(const struct dirent **a, const struct dirent **b)
 {
 	unsigned int aidx = 0, bidx = 0;
 
-	sscanf((*a)->d_name, "telem%u", &aidx);
-	sscanf((*b)->d_name, "telem%u", &bidx);
+	if (sscanf((*a)->d_name, "telem%u", &aidx) != 1)
+		aidx = 0;
+	if (sscanf((*b)->d_name, "telem%u", &bidx) != 1)
+		bidx = 0;
 
 	return (aidx > bidx) ? 1 : (aidx < bidx) ? -1 : 0;
 }
-- 
2.53.0



