Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738333EDE4A;
	Tue, 12 May 2026 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608907; cv=none; b=A+1wQrqvAfcfPaYqpHqydctHBj2ZHNG15kDYGLMoBRtxDvhI+VFY0Ua6IHzF0AnoyD25qN804gBRlJJYxmqYW7HswrpgbBULFow3fR81xGvHiwp8QlOQF7k+F1P0rKuFZ7OJbSb1D/OcsrYNrbu1MZ39kj6ddUriVWtampIK5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608907; c=relaxed/simple;
	bh=R1TT+KQQLG3oszjvNuhYu0MSylmboVcl7JcriNrxNdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giaYtWqL/1V6fQCHraePue5ULKdb42i4KaqzwFRZnt3WU4UX25WBZjgywW/DxHlvAzT+8UYoxVAbJrFYhJkTfNo8Tk44sdhPC4AImgqbwZq2zbcRoAXCyyYayQwNZZDZtcdQpqFImOss1BK2Q/bwDI2kkVO/FtSrhgL6K/S6wfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjlj+aOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjlj+aOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8DDC2BCB0;
	Tue, 12 May 2026 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608907;
	bh=R1TT+KQQLG3oszjvNuhYu0MSylmboVcl7JcriNrxNdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjlj+aOV0zO9EwHsOT5dbmfICfKAOQKivy7c2O8FweEk6YQEU8rkbLnUyBkCkfZeC
	 3NQh/0+90cIVB0iLV24E2QGLvGeZ+0r7EGfsc/cMN/SMPhtT4Sy5+IyHkYKw4iLNXd
	 8TwgoC9sTCvuWDx8kmYEKGYy6N1gQkDNETovcbPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 210/270] mptcp: use MPTCP_RST_EMPTCP for ACK HMAC validation failure
Date: Tue, 12 May 2026 19:40:11 +0200
Message-ID: <20260512173942.868517331@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -907,7 +907,7 @@ create_child:
 
 			if (!subflow_hmac_valid(subflow_req, &mp_opt)) {
 				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
-				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);
+				subflow_add_reset_reason(skb, MPTCP_RST_EMPTCP);
 				goto dispose_child;
 			}
 


