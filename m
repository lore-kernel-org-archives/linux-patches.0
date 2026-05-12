Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D6433ADBA;
	Tue, 12 May 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608825; cv=none; b=LDtcgTGElsDXP57RdD3OLkFVSSTbTxBX8Nv5WSnyJR59JMi4Mp+DQrY1Blri5iTHEkH3tVjsyh5Z744a6O8RWdAdiIkyoxQ0PC2DpXrCApZHEwyPX4CFdt4mjqNvxlJDc5CS10knBIX8bl5soTBqp8nSCD/1KFTypnZkcYDfZqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608825; c=relaxed/simple;
	bh=IzfvR/2I6SJ2pQrJPnkmniwFKG1sbqYjfaUHPQ3RI3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjOL1EllqpZXDl2o+U0MWjxZ2SCKMloOFTnyEJ6+FSXMXF9JJwDP0tOO2xbhfyOf7/ORYsow/vY9NLvPucEYTW3NDeaqkSkBhIhAZ3LX4Tgz/J7IGvF16/gueze1ZP3GL2lq1Iewmq2NWjy941JTO3mzUaWHRRD8331MqDm05Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYXVfZAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYXVfZAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2442C2BCB0;
	Tue, 12 May 2026 18:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608825;
	bh=IzfvR/2I6SJ2pQrJPnkmniwFKG1sbqYjfaUHPQ3RI3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYXVfZAjweslrYNGU05gmWTcR87FcpXMxXapIIigzLdauMSva2I/0Qx4tqlCYyV4c
	 trVjG2n3mtVshZOsQvIyzoGOy8XgoQt9+9MWxI3fsk+HW6V5lD2NjDLP8IWrGvGH5p
	 HdXLzjFf13ABiE3LdAlJ6luqUxnlmz2MjCCXk7sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 212/270] mptcp: sockopt: increase seq in mptcp_setsockopt_all_sf
Date: Tue, 12 May 2026 19:40:13 +0200
Message-ID: <20260512173942.910704020@linuxfoundation.org>
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

commit 70ece9d7021c54cf40c72b31b066e9088f5f75f5 upstream.

mptcp_setsockopt_all_sf() was missing a call to sockopt_seq_inc(). This
is required not to cause missing synchronization for newer subflows
created later on.

This helper is called each time a socket option is set on subflows, and
future ones will need to inherit this option after their creation.

Fixes: 51c5fd09e1b4 ("mptcp: add TCP_MAXSEG sockopt support")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260501-net-mptcp-misc-fixes-7-1-rc3-v1-4-b70118df778e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -812,6 +812,10 @@ static int mptcp_setsockopt_all_sf(struc
 		if (ret)
 			break;
 	}
+
+	if (!ret)
+		sockopt_seq_inc(msk);
+
 	return ret;
 }
 


