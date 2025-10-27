Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F131D72A;
	Mon, 27 Oct 2025 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591223; cv=none; b=VLmfmWufPugIn7SzpHpQZGz2ESnEfkkRV6r7U1PfYyZicG/Yi1VCVLs9tJLm8/Q854cCNg1L40blR8Cxzz54Qi3D2GmfNQxJOOa85RaT8CXFamRUy4SR/RVoo2qGQL+qCG9yNU7AzHDGAEQ1Go0zqO2mUAa2JQ9EA+Vnc0Ft2oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591223; c=relaxed/simple;
	bh=kzgHcrKEpucPk5gmXon3peMseWnnns5OPlR8m3HRRaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3XTO8/8m5uaVplKWyad3OBbIz0OHbJrqt1bk3Ruqe4iXR4wQY6q0bhPExRaZDI2W8jP7kW4D3GnzmDy0MObUdhhrgoe24YHy5SUeomD23ooCLTkfGVOY/60uRDFXeb08IiLNf3dmByyRpoLv6qXqmbH8vwWWjGtzRgVQpM3SAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxdjKq/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxdjKq/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4954EC4CEF1;
	Mon, 27 Oct 2025 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591223;
	bh=kzgHcrKEpucPk5gmXon3peMseWnnns5OPlR8m3HRRaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxdjKq/NDmSAC0JQEjWeicN33zXfWCNA5GwZbtqU9np4QA/ARDRd2hoqsJDb4kzbB
	 QitqsmapKIj9vGl9JcVOCSAXzzIKxjjDvfGW1rd2Qi/3StwdxrAe/AyP206m+sfOgd
	 CDiTydbqhA8cYuNLFgUVw2GSRsd7CzazLnr1DA7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/332] net/sctp: fix a null dereference in sctp_disposition sctp_sf_do_5_1D_ce()
Date: Mon, 27 Oct 2025 19:32:45 +0100
Message-ID: <20251027183527.574442398@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alexandr Sapozhnikov <alsp705@gmail.com>

[ Upstream commit 2f3119686ef50319490ccaec81a575973da98815 ]

If new_asoc->peer.adaptation_ind=0 and sctp_ulpevent_make_authkey=0
and sctp_ulpevent_make_authkey() returns 0, then the variable
ai_ev remains zero and the zero will be dereferenced
in the sctp_ulpevent_free() function.

Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Fixes: 30f6ebf65bc4 ("sctp: add SCTP_AUTH_NO_AUTH type for AUTHENTICATION_EVENT")
Link: https://patch.msgid.link/20251002091448.11-1-alsp705@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 93ebd14b48ed7..2832af34216d5 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -873,7 +873,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	return SCTP_DISPOSITION_CONSUME;
 
 nomem_authev:
-	sctp_ulpevent_free(ai_ev);
+	if (ai_ev)
+		sctp_ulpevent_free(ai_ev);
 nomem_aiev:
 	sctp_ulpevent_free(ev);
 nomem_ev:
-- 
2.51.0



