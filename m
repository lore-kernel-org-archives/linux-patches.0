Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969672D73A1;
	Tue, 12 May 2026 18:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608804; cv=none; b=U4yVOVL6cbqDWGLTg48SoKkDgqs6wbkCBdMc+gFCljcLDIDc3QX8UoP6EhlJCrSHDdgjAs1AMsCr+XV8CgA23nXm2RL2NymE+ePEAqfKl4MsRgdwLtEYLpJTMhi35rFUyGyWbF9Vm3Yw4XlC+iQcvV09QaplQoEK77zxQKoyCTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608804; c=relaxed/simple;
	bh=IjY9ceJN5/vaKkmSrVbGNO7vx021nB6+DuKnq8ctjOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2ImiKeVRcYCNx0JOhmmPSNw0eo+M4vJLq7hs2+yKc2XizSevduVp4bERqwbACODRxCTiZzVzwwfHpMzpz4fdY+9tyu1+m/AjQK/fxgXFdYns2xHbF673aK+xoQyeFE/QJS2rx+Ytz1wi9i73qUC6gBJyme9JZb9tUo6mFqwID0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbWJVHmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbWJVHmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C150C2BCB0;
	Tue, 12 May 2026 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608804;
	bh=IjY9ceJN5/vaKkmSrVbGNO7vx021nB6+DuKnq8ctjOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbWJVHmNV/dD17GFyTWq+OCbgLq4FfvVYE3fV5ti9Q7XEBfahu8PZNW3ONswpOyAL
	 Hbv+6VNxD+D6jP7prmGpNirZW95p8zZ9Ij0J3VpgvHfVulZhTN1FiLWb3NJO3yPjYz
	 KPC1yUvAqpavbxSEYleS9GGnYIs2dCQCR5fYZK0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 222/270] mptcp: pm: ADD_ADDR rtx: return early if no retrans
Date: Tue, 12 May 2026 19:40:23 +0200
Message-ID: <20260512173943.118806176@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 62a9b19dce77e72426f049fb99b9d1d032b9a8ea upstream.

No need to iterate over all subflows if there is no retransmission
needed.

Exit early in this case then.

Fixes: 30549eebc4d8 ("mptcp: make ADD_ADDR retransmission timeout adaptive")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-8-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -311,6 +311,9 @@ static unsigned int mptcp_adjust_add_add
 	struct mptcp_subflow_context *subflow;
 	unsigned int max = 0, max_stale = 0;
 
+	if (!rto)
+		return 0;
+
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct inet_connection_sock *icsk = inet_csk(ssk);


