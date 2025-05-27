Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F59F1EA91;
	Tue, 27 May 2025 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364542; cv=none; b=KBMQat+VkqbaQESNGDBFYGloG+P7h1jYO5ud9LQKSyqNK7+3jku82KR8Xgr1xl31+wU7/zHnN1uqcDSewgMPsvQzVoWE310ggAM0bvVCHZo+zWse/BYTOmf/ak9IVKvUerihCJtsg61cnegUidGNOGNHQOQ6/N7rVEdyofqsTaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364542; c=relaxed/simple;
	bh=ntsGJaC1VDYq7GMiEpY0i/DgI9vIOSKtZNKmmpvqfno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbqHhFxAyqsku4PhivN6DSBJs7iirglq1s3HFG+1/s8wwc80etniQ9VzloAyI4tw4LTvNojWbEbkzVGsy2IC86Xq1BmWsAd6+KFaIly3ACcahUOEH9P+VnSAOcsoT5ZhITOQZtluin92FIpnFca/fz0tmJXdxyU28+GEV9mlfjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvupUxpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvupUxpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C986EC4CEE9;
	Tue, 27 May 2025 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364542;
	bh=ntsGJaC1VDYq7GMiEpY0i/DgI9vIOSKtZNKmmpvqfno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvupUxpVJiy7kkcUZWcqzLHgnbMBB5dc4Cz245BVQ+JZDLE29lbKURCY06wnnrRt+
	 oXuwGyo86cQbGPSsQHNWz2c5vnw+cViEUf1ckPJ33QSusR3K4sNIINQlC2S3ZcC1+E
	 WOVL4IvZ5SfSCdLnZScxVMNRTYr8fwkYvyWh+/3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/626] pNFS/flexfiles: Report ENETDOWN as a connection error
Date: Tue, 27 May 2025 18:19:43 +0200
Message-ID: <20250527162448.700516866@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit aa42add73ce9b9e3714723d385c254b75814e335 ]

If the client should see an ENETDOWN when trying to connect to the data
server, it might still be able to talk to the metadata server through
another NIC. If so, report the error.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index a1cfe4cc60c4b..8f7ea4076653d 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1263,6 +1263,7 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		case -ECONNRESET:
 		case -EHOSTDOWN:
 		case -EHOSTUNREACH:
+		case -ENETDOWN:
 		case -ENETUNREACH:
 		case -EADDRINUSE:
 		case -ENOBUFS:
-- 
2.39.5



