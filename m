Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D553EDE4A;
	Tue, 12 May 2026 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608899; cv=none; b=d17tg9554fLntD1RU2nU7Nh4I650pLKFfP35ucyA/0e0l1Qf30I3o+0N5Cx7kZl2NgVzTCpj4czbFApQoSyU9wdw+QpH5wjcexeJSd1n1KRdxQrMdOePtpVjbeCEG7xSo+xNTviLmNPLI9o7QfOLrdDVS9QKip+oyCz3jHLDwn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608899; c=relaxed/simple;
	bh=Y/04fqsYb/xee1rxiM756EG5jUpPdkslMQ6iPbTR/P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMRNXXwMqHsijFy5Qll4F6FfA8IrgnTxASIQET7bvE3cteYbj2ItmsN3fkzMn6bbiRDQVR+5JFvSuidKgsP1XiJyoPCvjfQ6TFXJAuOuBv+ZqN+fxmH5BH8g4+C13+NCnfvXWCxKmRp50vOgHOJldfzqi4OHHqz4UCX/en4vov8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrfviqbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrfviqbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F71FC2BCB0;
	Tue, 12 May 2026 18:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608899;
	bh=Y/04fqsYb/xee1rxiM756EG5jUpPdkslMQ6iPbTR/P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrfviqbUrm/o4NaUD3Fjoyn68NptyxG68OItAapFst6821Aa8PKmC2laHy5zx5IM1
	 ppKV4Abdb51wkQBL7A27ePkKq2yYTuaGdm5XqyuyK46vLB+iBLPBHprf6CZ1XTeSxi
	 yATyp2K3HROYoegQUjJqy0rpu4Vdx2h51rMiVBqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 217/270] mptcp: pm: ADD_ADDR rtx: allow ID 0
Date: Tue, 12 May 2026 19:40:18 +0200
Message-ID: <20260512173943.013483444@linuxfoundation.org>
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

commit 03f324f3f1f7619a47b9c91282cb12775ab0a2f1 upstream.

ADD_ADDR can be sent for the ID 0, which corresponds to the local
address and port linked to the initial subflow.

Indeed, this address could be removed, and re-added later on, e.g. what
is done in the "delete re-add signal" MPTCP Join selftests. So no reason
to ignore it.

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-2-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -350,9 +350,6 @@ static void mptcp_pm_add_timer(struct ti
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
 		return;
 
-	if (!entry->addr.id)
-		return;
-
 	if (mptcp_pm_should_add_signal_addr(msk)) {
 		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
 		goto out;


