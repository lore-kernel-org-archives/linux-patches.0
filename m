Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0991242D73;
	Tue, 29 Apr 2025 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948814; cv=none; b=S1La5eHj5taOOb6Nqk+CHQ7b3KK/NwpRJGdYluyaC4JNsEIHXD0eVtoyIxwtSomEY4vt4Ef0Mc2RlsfuyBCO8LEedBV4Qww/SfK8VPvgkYZSykrBSEjrPGNRFdbESPpmgkrnLC9PDwetbCvYwlzfeqtmC79EKnGIHkVud1yJuYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948814; c=relaxed/simple;
	bh=yaHEEn2i4K1g1qvhumGnlzEuxloHIM3AjbI48hzsGUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge/jEUewKff7lO4Z6ZcfND7yUSkdLtHqKZPi3v42i9XXHa9nYg0V1QQi7D/2Ik/goEaNoV5mNXUo/jIpHaZTcEcCHehsau2aanzAzgHhkUVPuMpBZXRTrtGXy8TNOU/adu7XENspywLbQ5ei1zU47Uq/OPoAwrvVkeVqnMWjraE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j594By0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j594By0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625F2C4CEE3;
	Tue, 29 Apr 2025 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948814;
	bh=yaHEEn2i4K1g1qvhumGnlzEuxloHIM3AjbI48hzsGUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j594By0gNO9twKzKBNFubHBnkSFq5AFVAR8WjXa0Gla0dWzoJvI7qA7RBvVF1qzWU
	 c2bQ8z20ZAjujEOIRNGTti9IraTmHxbyl/mTmJuLlkISF5aTBvyU2bTIrzIGcx/oaD
	 b6qnsYyXAjIwzJXM8hQKMv2XIlsgfbgzMoMOXdB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 095/373] mptcp: only inc MPJoinAckHMacFailure for HMAC failures
Date: Tue, 29 Apr 2025 18:39:32 +0200
Message-ID: <20250429161127.063661466@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 21c02e8272bc95ba0dd44943665c669029b42760 upstream.

Recently, during a debugging session using local MPTCP connections, I
noticed MPJoinAckHMacFailure was not zero on the server side. The
counter was in fact incremented when the PM rejected new subflows,
because the 'subflow' limit was reached.

The fix is easy, simply dissociating the two cases: only the HMAC
validation check should increase MPTCP_MIB_JOINACKMAC counter.

Fixes: 4cf8b7e48a09 ("subflow: introduce and use mptcp_can_accept_new_subflow()")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250407-net-mptcp-hmac-failure-mib-v1-1-3c9ecd0a3a50@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -782,12 +782,16 @@ create_child:
 				goto dispose_child;
 			}
 
-			if (!subflow_hmac_valid(req, &mp_opt) ||
-			    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
+			if (!subflow_hmac_valid(req, &mp_opt)) {
 				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
 				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);
 				goto dispose_child;
 			}
+
+			if (!mptcp_can_accept_new_subflow(owner)) {
+				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);
+				goto dispose_child;
+			}
 
 			/* move the msk reference ownership to the subflow */
 			subflow_req->msk = NULL;


