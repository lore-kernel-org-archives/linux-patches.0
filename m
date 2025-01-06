Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2947154C04;
	Mon,  6 Jan 2025 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177632; cv=none; b=DyvxqRvLqYpLeF3R+PfY484oRH2FKSeutAEfb5+gefsKS+fQElcLPYC/+8oaO+Uarsgx774dmnInloyMSzB7V3esuOgwk1viwMuIgbN/eH9Z1Yqi7P2UGknaK8oo/CFTXZaP7jyz4NY2AAVeu/6yu2aTc16/X8oqr70Av+3pB1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177632; c=relaxed/simple;
	bh=p9HzfPGosFV51kq8VxxETRi2SQZzEN5xWCVBCgitc4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfdYLeecndUNJF35X7U6D1H6gepk/YBf5SMFwdufwHvteMviPVLvU/11XLWzdK49rtuQg/sg5ce3RLS9RPEgzwDj/e4MPB2YtMDNT0vqedTRa+mPVDFHA6/pLsFmvbedIbUMVMNqdP2zFRgqJzeSD6GVAvt8txXk9qOeyIpyfqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzecytRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzecytRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD14BC4CED2;
	Mon,  6 Jan 2025 15:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177632;
	bh=p9HzfPGosFV51kq8VxxETRi2SQZzEN5xWCVBCgitc4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzecytRtAPT+K2Rm8MRpaTzK3+Fh1+kansLLwswvfTc4YKjauzIFxvWocOOn+4aNO
	 w0AzomzFTBSUN4ozZ75rzsKW8gv7/wCtk5SPl9ihvniuLZd+Lx3/P/hAFRdHqi9jy/
	 TgXxy+5kBru3VP60LrAqJZJTcrnkkrlc3lbmD6sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/222] modpost: fix the missed iteration for the max bit in do_input()
Date: Mon,  6 Jan 2025 16:16:41 +0100
Message-ID: <20250106151158.218014082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit bf36b4bf1b9a7a0015610e2f038ee84ddb085de2 ]

This loop should iterate over the range from 'min' to 'max' inclusively.
The last interation is missed.

Fixes: 1d8f430c15b3 ("[PATCH] Input: add modalias support")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/file2alias.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 96f37fe1b992..ea498eff1f2a 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -742,7 +742,7 @@ static void do_input(char *alias,
 
 	for (i = min / BITS_PER_LONG; i < max / BITS_PER_LONG + 1; i++)
 		arr[i] = TO_NATIVE(arr[i]);
-	for (i = min; i < max; i++)
+	for (i = min; i <= max; i++)
 		if (arr[i / BITS_PER_LONG] & (1ULL << (i%BITS_PER_LONG)))
 			sprintf(alias + strlen(alias), "%X,*", i);
 }
-- 
2.39.5



