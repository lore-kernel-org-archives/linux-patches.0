Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E619C1DFD1;
	Sun,  1 Sep 2024 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209732; cv=none; b=pl6L21cME8rKIKr4zAH5xcJ6ozX1uqb9cp/6PxPL6qqv2r4PBKiR7nKqp4qBN0Lw/JEM3ME4Qte+tsPFv+uj2Fk2X0vorGEECxyHyCYgr+e7CD6nLY2VgQJosLhwgT/i7uLGnJ13LWTSyCDnPv4VsaDA/1hBEB16BYKR4+H5h7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209732; c=relaxed/simple;
	bh=Fw/Zuzin8av+oWjI7rj70v3gSt/i8lkI8GslnUGDhhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYo+BGuTrrwiw/KBWJTVvAjHAnRwROS2yaBnDcFbfuRO1NSO4+HAFt6Ho5lcS9tpxmrluD3OdXez1WuQoYrkyPnwV7AEOs5rvDkMMrAc2fn7bR+xFcgseRfm+z7SSY1BMaTWfLgvXYLvrlkw2x+wtma/iryu6ciqOe8R/CDn6Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k6j7Qyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k6j7Qyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5B4C4CEC3;
	Sun,  1 Sep 2024 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209731;
	bh=Fw/Zuzin8av+oWjI7rj70v3gSt/i8lkI8GslnUGDhhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1k6j7QykOFzw8oX7uO+H7Mpx8j5Jw2sgjpZ9puSGkKJy9vl0UZ6G+P8ULLi0lPA3g
	 dPKptWZP9cwsmZm2GZJ/eZp1oPKdelnnf1rjsjeb+asNOoZB2C5aSL9QDqJ2EmpQ1Q
	 We4ielcBqNrkAu/wLcxAQXhD0mOqBVGRY3PYk7+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 126/151] mptcp: sched: check both backup in retrans
Date: Sun,  1 Sep 2024 18:18:06 +0200
Message-ID: <20240901160818.848300748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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
@@ -1664,7 +1664,7 @@ static struct sock *mptcp_subflow_get_re
 			return NULL;
 		}
 
-		if (subflow->backup) {
+		if (subflow->backup || subflow->request_bkup) {
 			if (!backup)
 				backup = ssk;
 			continue;


