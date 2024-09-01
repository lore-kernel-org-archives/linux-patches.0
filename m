Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283EB14290C;
	Sun,  1 Sep 2024 16:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207902; cv=none; b=d/aazEM4hs7rkYaFZk11vLOgqlUAoz5wDWzb7mfU+s/Mw/BqwqTDyVrtAxfGFHSZ5DETB2N8UveZ0JmYfNl4Ow/CiW1CTw/09CfRAVUH+MrP0C0FBdy6T4239+ndt3PtW3EgNrgejUJmgkmbSzLcNegLJ3RAQgw1OwF9/Qqcy2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207902; c=relaxed/simple;
	bh=Wqr4nrmj2A1X+oZCCwAz5uJaAiz+sdf9J4Q/Tr571fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dX0GIuAGFylsnrDgD+HB3xpC2AR5yEmmcBspkfL7rKWE41cwV+Ug9C4O1D4NXaevjJwd9U6VL7XZmraMyocoC0ISCq8PGJ3NCbJzXUYVoeCSZnf5qd1dBAeBxQv5pNGPrfZo8TT402D+n1FqiZ+faUi2J8kd6SWr8EwEcknCAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOuF4mN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOuF4mN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A43C4CEC3;
	Sun,  1 Sep 2024 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207902;
	bh=Wqr4nrmj2A1X+oZCCwAz5uJaAiz+sdf9J4Q/Tr571fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOuF4mN1ZY0219Yo/fcD5X9zLneg9T+V5wCKcB3KkyXV6n3Y2OfvFQZM004AWu1L2
	 L/HzXVSyu/PJV8blpvWekBT9DECDpZGMxkWc1A7jzItoaLn13UxRbtniEn+7QJcIhx
	 FKw6mQxu0nTHcllDMDnHWlzF6IKeuMDSeWwh75JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 13/93] mptcp: sched: check both backup in retrans
Date: Sun,  1 Sep 2024 18:16:00 +0200
Message-ID: <20240901160807.858156085@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 2a1f596ebb23eadc0f9b95a8012e18ef76295fc8 upstream.

The 'mptcp_subflow_context' structure has two items related to the
backup flags:

 - 'backup': the subflow has been marked as backup by the other peer

 - 'request_bkup': the backup flag has been set by the host

Looking only at the 'backup' flag can make sense in some cases, but it
is not the behaviour of the default packet scheduler when selecting
paths.

As explained in the commit b6a66e521a20 ("mptcp: sched: check both
directions for backup"), the packet scheduler should look at both flags,
because that was the behaviour from the beginning: the 'backup' flag was
set by accident instead of the 'request_bkup' one. Now that the latter
has been fixed, get_retrans() needs to be adapted as well.

Fixes: b6a66e521a20 ("mptcp: sched: check both directions for backup")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240826-net-mptcp-close-extra-sf-fin-v1-3-905199fe1172@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2289,7 +2289,7 @@ struct sock *mptcp_subflow_get_retrans(s
 			continue;
 		}
 
-		if (subflow->backup) {
+		if (subflow->backup || subflow->request_bkup) {
 			if (!backup)
 				backup = ssk;
 			continue;


