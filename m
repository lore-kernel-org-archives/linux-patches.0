Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDEB13C3E0;
	Tue, 18 Jun 2024 13:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715858; cv=none; b=Ja1msm9WFoHBz1dp1kWgCgbZ3s0GlcGbCw3DWHP9yQLo5Or+GFWyUcaTJMr/m8wEzB1pj3fODTDHnbOdBfdk6Niz04QZV/D5l/7+tKrxfgMiWlHmsAJsJiSq0n8nS65DNC8Mro+JV7fR3zgyJE4inxDSandTgiPgiBlAytlAr4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715858; c=relaxed/simple;
	bh=FaJmlytR4qZceB+zCKYz8ZUgFibxhAYWgXH5FTXwX4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HihciYvrKUFbPdcKRe3b111P0eaezIxV2dh6fEXlM+sbAQP8NfALVZ6pVgwhAUs2m6ndWF0LvsQBjy57t/cyKv1AH9gRNBO49ei82afqNxpI1p4HI369YKVcgYJW+f5NfM63rNUKVy1a1uehdaZogo7le6q8F0R2OHneUHJjlxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yC2kYL/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yC2kYL/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061BEC3277B;
	Tue, 18 Jun 2024 13:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715858;
	bh=FaJmlytR4qZceB+zCKYz8ZUgFibxhAYWgXH5FTXwX4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yC2kYL/BxXpbIxFQNuOksq+GVRXB9sldtHLwFzr+5S7TMCdUi3RRdQsxa64HKoR1q
	 SS9CFL3nSKr89kGJpW8xTysDBp8iawxKZ7wmjfmAHyZZb+ZE/gFlLCLed9WwPLpCBN
	 CdF7KgB8EybNNFgGaKp1vXInlm3OvauM/M4WNdyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 419/770] NFSD: handle errors better in write_ports_addfd()
Date: Tue, 18 Jun 2024 14:34:32 +0200
Message-ID: <20240618123423.458119680@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 89b24336f03a8ba560e96b0c47a8434a7fa48e3c ]

If write_ports_add() fails, we shouldn't destroy the serv, unless we had
only just created it.  So if there are any permanent sockets already
attached, leave the serv in place.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index d0761ca8cb542..162866cfe83a2 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -742,7 +742,7 @@ static ssize_t __write_ports_addfd(char *buf, struct net *net, const struct cred
 		return err;
 
 	err = svc_addsock(nn->nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
-	if (err < 0) {
+	if (err < 0 && list_empty(&nn->nfsd_serv->sv_permsocks)) {
 		nfsd_destroy(net);
 		return err;
 	}
-- 
2.43.0



