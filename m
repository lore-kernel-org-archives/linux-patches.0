Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3251EF923;
	Tue, 15 Oct 2024 12:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994338; cv=none; b=QxLNg2YDLjzDmw7TcGJUY6YX9avr0vTiLRjnaFzzJwhyfP/EB9v/RSHSSnB0Z+StcjLyXLUlnqks4UCc3u+x22oTPOqVTg0cR0PFeiVj8PL/QSR85aCMSTx2rvsTbvCVzKfuxtge6QrbTOidzu//6tVGNq0iRuViYojFi6HtpCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994338; c=relaxed/simple;
	bh=lKiTWZ2Mu+y9s5bfigyFTlkwt14bJVbJX383leWVGxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB0lkmUN5EAPRjTUICl2P91N32SzlVEdLyzbVALAthr3qXEelkEkAF0j1Xhtnhv/KjggJldGePP4oQAXikdV2BLDepOt8lQExaRsNLv4CrbJ+IO8bq40RKrBNumx40LRsJQ86J2ASIvrBk5dcfy5WMmZ0+ZAs9RiLwsfnjIHDF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTLEU5li; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTLEU5li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71E1C4CECF;
	Tue, 15 Oct 2024 12:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994338;
	bh=lKiTWZ2Mu+y9s5bfigyFTlkwt14bJVbJX383leWVGxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTLEU5liEc18L2elmwrn4vXi92RWuZoJOaNHzqMofuvDx0dgyG/q93mfgMsishNe+
	 Ooj1vG57zkd760IxjPPylWV26pBFAtp0eOcngPzcz3zmd2GNNAFIkKx3KRsHSLs0jQ
	 ecNvvcL47c6jvslRatnXmeukf98M0kuUh6xKyQKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 676/691] mptcp: pm: do not remove closing subflows
Date: Tue, 15 Oct 2024 13:30:24 +0200
Message-ID: <20241015112507.153814787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit db0a37b7ac27d8ca27d3dc676a16d081c16ec7b9 upstream.

In a previous fix, the in-kernel path-manager has been modified not to
retrigger the removal of a subflow if it was already closed, e.g. when
the initial subflow is removed, but kept in the subflows list.

To be complete, this fix should also skip the subflows that are in any
closing state: mptcp_close_ssk() will initiate the closure, but the
switch to the TCP_CLOSE state depends on the other peer.

Fixes: 58e1b66b4e4b ("mptcp: pm: do not remove already closed subflows")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241008-net-mptcp-fallback-fixes-v1-4-c6fb8e93e551@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -778,7 +778,8 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow->local_id;
 
-			if (inet_sk_state_load(ssk) == TCP_CLOSE)
+			if ((1 << inet_sk_state_load(ssk)) &
+			    (TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | TCPF_CLOSING | TCPF_CLOSE))
 				continue;
 
 			if (rm_type == MPTCP_MIB_RMADDR)


