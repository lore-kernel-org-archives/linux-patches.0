Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274D01F6662;
	Tue,  3 Dec 2024 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236462; cv=none; b=UlJzMPPbo57ieOFBXY3tqVZUf51UyPS51Fh07qit8Q7WWzS8fNHZC4QPRKPQwJ8FOuGgzh1mjN0LuiXkWt7k84Y6MswJloyXqdlzQNMMGpPBmEe10lAq4HAHrYGMkKicLkFpDS5NfHpfENAkvSvxjaEzL3u+8OTIEc1icQThhzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236462; c=relaxed/simple;
	bh=Nmc1MgM3Cwl5SFCNYp/FEsU5b9Lxq2KPltu5b/5QVEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0WiPT5dCvpQAwbtnqmaahBfjwatXUhD3W6fhCd7DpHAChdv8ryLNyb0shRSWYTVwAohY/lOjhnvjqh+a0dNYiz3HUCdXWmJK6P3O4ouzhSfOMCO8Zp8u4WVYNXRJO3Ehbfs6c6eRxjrUHUE+UNimaS9JtK3Qdq6BvwQjp3aPXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKpRLTQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKpRLTQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C544C4CECF;
	Tue,  3 Dec 2024 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236462;
	bh=Nmc1MgM3Cwl5SFCNYp/FEsU5b9Lxq2KPltu5b/5QVEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKpRLTQbPiS/+eHPa3LSDSAMmuykzCx7h+gDOb92tpGVa6MsRAf+SnPeR9EyE5fOH
	 p7GhN3nQ1lNCCKu2MD8cd2OzeHTbThMoC5U7I4D0lRrGMIywpnSkCBadSd1BQplsC3
	 kqmHxI/cmo91tTFYjtSXQEuDv5tlNg9efcHGZaiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Everest K.C." <everestkc@everestkc.com.np>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/138] crypto: cavium - Fix the if condition to exit loop after timeout
Date: Tue,  3 Dec 2024 15:30:55 +0100
Message-ID: <20241203141924.548477749@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Everest K.C <everestkc@everestkc.com.np>

[ Upstream commit 53d91ca76b6c426c546542a44c78507b42008c9e ]

The while loop breaks in the first run because of incorrect
if condition. It also causes the statements after the if to
appear dead.
Fix this by changing the condition from if(timeout--) to
if(!timeout--).

This bug was reported by Coverity Scan.
Report:
CID 1600859: (#1 of 1): Logically dead code (DEADCODE)
dead_error_line: Execution cannot reach this statement: udelay(30UL);

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Everest K.C. <everestkc@everestkc.com.np>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 7416f30ee976d..7e1d95b85b270 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -48,7 +48,7 @@ static void cpt_disable_cores(struct cpt_device *cpt, u64 coremask,
 		dev_err(dev, "Cores still busy %llx", coremask);
 		grp = cpt_read_csr64(cpt->reg_base,
 				     CPTX_PF_EXEC_BUSY(0));
-		if (timeout--)
+		if (!timeout--)
 			break;
 
 		udelay(CSR_DELAY);
@@ -398,7 +398,7 @@ static void cpt_disable_all_cores(struct cpt_device *cpt)
 		dev_err(dev, "Cores still busy");
 		grp = cpt_read_csr64(cpt->reg_base,
 				     CPTX_PF_EXEC_BUSY(0));
-		if (timeout--)
+		if (!timeout--)
 			break;
 
 		udelay(CSR_DELAY);
-- 
2.43.0



