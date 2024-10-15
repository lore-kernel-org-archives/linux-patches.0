Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABA61E3DF3;
	Tue, 15 Oct 2024 11:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992535; cv=none; b=NainJ7SOIfWSgBrP2CgT4OpQGwkr6F4YCiSxoVDoYszy5YQNMD2QnfZon/5XaloSQqx6MUDObvg2D2TCqtNmD//tjMlUKc6LqgkfEHmKfjza9VJj9LIGYkDNAphM0y1MxWAsQNTxQZx5NW5jyDbG2O9TStsnWvSZYv2Bvfl/d4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992535; c=relaxed/simple;
	bh=YZ4g3jD/CpH7oKapwC6bPtImPCrgdg2fjGbeogrzCeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/xUEUkFSAaO8b4DiAzAoerje0K/O5l6L7COY7IBq+CdPMIhz5T2cTRXQZo1DPo7EJ5XiXAg1nhFmflu8tR3FcCuz5rylDrq6lNYEC/NTl4/t0LLoYossEMiF9nb8G4X9DlkMc3LLvnoFq2z4Bj3nPlHonA2yj8MqSmRNbzn71o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AO2qVPCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AO2qVPCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326EFC4CECE;
	Tue, 15 Oct 2024 11:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992535;
	bh=YZ4g3jD/CpH7oKapwC6bPtImPCrgdg2fjGbeogrzCeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AO2qVPCZ4PJZtrzuD5mIiRpeKf3o6EpOUIpn5Nkb0ZCcpMACk1YUIaRlogJVhtREU
	 GKwopK1ukRDiksKTX8hH97ibm/MdFgKBJaGCTHE8MYy3pCJ0zCu0QJvGFE5S6YRFoo
	 l/szzi0y0qUEcwqeqdeqii/hzgttlrZMjJ3+jwhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/691] netfilter: nf_tables: reject expiration higher than timeout
Date: Tue, 15 Oct 2024 13:21:01 +0200
Message-ID: <20241015112444.845814100@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c0f38a8c60174368aed1d0f9965d733195f15033 ]

Report ERANGE to userspace if user specifies an expiration larger than
the timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 300926b56572d..dff7e507d03a5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6302,6 +6302,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					    &expiration);
 		if (err)
 			return err;
+
+		if (expiration > timeout)
+			return -ERANGE;
 	}
 
 	if (nla[NFTA_SET_ELEM_EXPR]) {
-- 
2.43.0



