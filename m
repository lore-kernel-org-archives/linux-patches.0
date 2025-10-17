Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5191217722;
	Fri, 17 Oct 2025 15:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714175; cv=none; b=X5Euwv4/EmW0eH6mfJAxZBoiq64/mXORGte2bHwp1XEjuw4OrYaE7POCszUeppFqWvqbc9hjMzEGQ/fMtdbcGChPc9+uUXOTdQ+zlKjzM9Jr9xitkBMufxM/JNgjAGySmniqbaz6IpnNoBiJZrYVXHFuJd/PaphZdem3d32ky5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714175; c=relaxed/simple;
	bh=dpolJf5m9SOkZtsIF6eK2aQnwdMAoCJwNCsy37Xbrzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPo5MllmF1hzRdwBvX8aYBR7eSnzmSFj+fJLgbE2Klgf6k4ME2L2/l+UpOGa0FveCoEH8KpK3WHFRW02xYn1aizkCtXfk+xa0NMSbCuOjfqBa6mhB6rhh7Phl47aTB946BzybpiugONfuQJ2sqkuo8zzvGzdc7dH2T62CWB/VCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tG8nEktX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tG8nEktX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3037FC4CEE7;
	Fri, 17 Oct 2025 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714175;
	bh=dpolJf5m9SOkZtsIF6eK2aQnwdMAoCJwNCsy37Xbrzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tG8nEktXpEmJ+h7FXYDJjmI/50GWZOK5d2MJ+5qQwwxiQ8y3iYH/9P6zy0jxaM14t
	 eDb1L6mcV3y+m9fnFdz3XMK6rWRauimfJx+4dUwPBjIohztqRYVUTDhUPW93fXcvfX
	 V7DQ4Fg/OJs4SM7pM4buCSfQ8V4qWtRjD/9QQaE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/277] net/sctp: fix a null dereference in sctp_disposition sctp_sf_do_5_1D_ce()
Date: Fri, 17 Oct 2025 16:51:00 +0200
Message-ID: <20251017145149.082730939@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a0524ba8d7878..93cac73472c79 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -885,7 +885,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
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



