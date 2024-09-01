Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDB91C68C;
	Sun,  1 Sep 2024 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208231; cv=none; b=WgKppgKkgAs4Qcwwc3JFrZBsDDrqOnOL7aDPlcfpxChrBV100ovC7FOKYKAB0yychy6m60i4Ji8WN3VATg+KqJP7zsoRIPiYBHh84jYsnLyQ//h/H6WnrSgqLwLx5w8cNCtiJsLmV4hq6iPX3zb6oiAZSs2hPMtbh5lGK372Kwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208231; c=relaxed/simple;
	bh=FOyWnVectQqT4+ANLEWVaps+UsIZUaIAWCGV0qBOOsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnBQHMzFyvA8GqtJ4uLljJYYHTS53NXAsXngZcmUYaPoYnELe1pANVvRLS0J5c+rnFkW+AkqpPfUdH71Y8cYJgT9RbMsvSGDTh/pGvVT9mWqFqY+XNmBlll0TyIbdEur+j6h8YsvY42lqSfl6+Vs1+TAL9C0o/2kx/NXODcbbgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEs9D+Xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEs9D+Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69DCC4CEC3;
	Sun,  1 Sep 2024 16:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208231;
	bh=FOyWnVectQqT4+ANLEWVaps+UsIZUaIAWCGV0qBOOsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEs9D+XnaQPqLYwkj0/UiARbnSstkWzQqKGKbBpmjzLqfwg1aDqlMWtgnSCyBz7kv
	 gCDxdnEVWq4ZCROlNU0ME6SkyndEWN5fgP/WzujvRbJK2FsIWmYZTs2raPOMqWKacP
	 GIxvB+hnKpXgw3zHJjWg6bviSiin6ntRmtjKzE8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 019/149] mptcp: sched: check both backup in retrans
Date: Sun,  1 Sep 2024 18:15:30 +0200
Message-ID: <20240901160818.188675394@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2326,7 +2326,7 @@ struct sock *mptcp_subflow_get_retrans(s
 			continue;
 		}
 
-		if (subflow->backup) {
+		if (subflow->backup || subflow->request_bkup) {
 			if (!backup)
 				backup = ssk;
 			continue;


