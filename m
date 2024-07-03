Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB6B18628F;
	Wed,  3 Jul 2024 11:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004959; cv=none; b=QuGHMnfzm3NYh8YdH6owJoVwzqmOE22ibfsIZPSfyvg/qVwoeIg4iI1m8G1IoNEJNLm25v4lInNvP6p2ftCZf4Ly5cqZarMe/FK1uGZIbaJAShZuuxw9g+vVIH1yVtY1xy/fRY9uSvOlr2434fpWF9Fi6v85Qyvd7c1FSnoX6/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004959; c=relaxed/simple;
	bh=T9MyIWion/8FwmppxqNJU/jFVXBDAlBtPdhghZRMslk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3SGRympf3Sxxbn6dzScCALgIx5w24AnCH/X8nm9lzoLp5TcQ0gc9W0zKf6C1bDh2SrJ1yhDNeP7VF5xbHxASaqtK0M/tPWTO6l3lU0HatuOpcx3egOoiuzLGHDdaCICNFIUpTpnygT6m4nGWmTQZ+peZcTCPQpbuN8v2X+f2Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aqu3yzF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aqu3yzF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CEFC2BD10;
	Wed,  3 Jul 2024 11:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004959;
	bh=T9MyIWion/8FwmppxqNJU/jFVXBDAlBtPdhghZRMslk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aqu3yzF02oJV1EBmSrAb1fJnLhNrGslpwHrug6HeO4/GQ+rF1cpQty/rJOGLX+KuJ
	 JoyuNHynkTMgbC5tfViflxNEUcBlFs7qAHdFxDd2j4zcGuQ7/v0x/72gbnd5BeFcOP
	 fWnA/m25Ohl/SUhfg/Q9sLMNkz2vks7+Rh6Mf6vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/290] SUNRPC: Fix null pointer dereference in svc_rqst_free()
Date: Wed,  3 Jul 2024 12:39:54 +0200
Message-ID: <20240703102912.204786275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit b9f83ffaa0c096b4c832a43964fe6bff3acffe10 ]

When alloc_pages_node() returns null in svc_rqst_alloc(), the
null rq_scratch_page pointer will be dereferenced when calling
put_page() in svc_rqst_free(). Fix it by adding a null check.

Addresses-Coverity: ("Dereference after null check")
Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on the server-side")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 26d972c54a593..ac7b3a93d9920 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -845,7 +845,8 @@ void
 svc_rqst_free(struct svc_rqst *rqstp)
 {
 	svc_release_buffer(rqstp);
-	put_page(rqstp->rq_scratch_page);
+	if (rqstp->rq_scratch_page)
+		put_page(rqstp->rq_scratch_page);
 	kfree(rqstp->rq_resp);
 	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
-- 
2.43.0



