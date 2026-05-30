Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFE332D42B;
	Sat, 30 May 2026 17:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160664; cv=none; b=ts5eOtrZqaMoV0eShrlVSwRYZXer/e9/kH0eRc6cTiNZoxPH+BMKt0OxfaVB+LQFekLpJaZCrpJ6DKwhIVEX0nIU3pXuz7hnzkAAFr5tEyUEdfMKCHt8KrNLx+ExsBGPscWAuEWTL98u5Zrw7+Oy8vJL652Sz42Voj1EFS4l6P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160664; c=relaxed/simple;
	bh=vF/4c7SeRVfHkV6FXp0mRZNK1iHn6jZ5NT3YZSeQ7Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuGEZ3x6AkYcI2SPrp65Mb1HCoxeTO2MNyRgovtkwFfpVI/gVocyBk7HqtLIG4IWN+p1F1WFXn0zjwmFAD70XuJOb0+QxAqoOEE7GWoGaoI5eI8JiGYMN7/HFDma06X5tw9QYcS8mHWKmAcdHsuCazRLE1a+3pbtdsZMhYMWzmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HusEuBVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HusEuBVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39D51F00893;
	Sat, 30 May 2026 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160663;
	bh=qZhXLw1uXH7n0pHImRoT48gWAQ5ah7zGCy9jc1O96Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HusEuBVCr4f4TzZDA8r584Vq+NhEW/yrQff9PJs+e0DoFxmkH8t9nq2JPFU8gXJvs
	 AWNZDKKy20SqHur331qarCE7hzED5FwpmBqAPwo6B2dHiMs9qf6mAwQUh3iXSeBmav
	 fxEjj0K56MXeLKv5hAJwx8DHpy67qJg1+lIo5XsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 372/969] mptcp: use MPTCP_RST_EMPTCP for ACK HMAC validation failure
Date: Sat, 30 May 2026 17:58:16 +0200
Message-ID: <20260530160310.587893575@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

commit a6da02d4c00fdda2417e42ad2b762a9209e6cc49 upstream.

When HMAC validation fails on a received ACK + MP_JOIN in
subflow_syn_recv_sock(), the subflow is reset with reason
MPTCP_RST_EPROHIBIT ("Administratively prohibited"). This is
incorrect: HMAC validation failure is an MPTCP protocol-level
error, not an administrative policy denial.

The mirror site on the client, in subflow_finish_connect(), already
uses MPTCP_RST_EMPTCP ("MPTCP-specific error") for the same kind of
HMAC failure on the SYN/ACK + MP_JOIN. Use the same reason on the
server side for symmetry and accuracy.

Suggested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Fixes: 443041deb5ef ("mptcp: fix NULL pointer in can_accept_new_subflow")
Cc: stable@vger.kernel.org
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260501-net-mptcp-misc-fixes-7-1-rc3-v1-2-b70118df778e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -796,7 +796,7 @@ create_child:
 
 			if (!subflow_hmac_valid(req, &mp_opt)) {
 				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
-				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);
+				subflow_add_reset_reason(skb, MPTCP_RST_EMPTCP);
 				goto dispose_child;
 			}
 


