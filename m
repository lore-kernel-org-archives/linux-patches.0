Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE493E00A1;
	Fri, 15 May 2026 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861332; cv=none; b=fHhLKef/65SD0l7FfL31fDqu4Pt7LnwT1IpPjmg7Ht/gnf6kYwg11BPTgCZFP7pSe73B8NxoCLMGweOl/v2hUzevzTWOAsIQubap0pp9GnW78M8t/AI36EL4/m/L57dwmnkRMPq5lz0xalqJ2WvT4lqvuHSYD2YYl5fKpOPKZzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861332; c=relaxed/simple;
	bh=Fm124Ss+ajrzIb9K5GKTibScl0F0XLMo2RVZ72RJkgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZP2StbYftyre/pdSh0Kj5S0oX+d4LGUD+g996HARw84Zn/Sur2Lwy0gtDAr2Gm5n0BryPFT4Ov6H4O4/FjmlUuwj65upWu7bBfdq8p97Z4e03oFSZ/4suMmCwHTJINDjgVttT6bbo45ClPNj4fC2fLWm4QnTJEpLgot1Kn+nkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dai+Nv0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dai+Nv0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2739EC2BCB0;
	Fri, 15 May 2026 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861332;
	bh=Fm124Ss+ajrzIb9K5GKTibScl0F0XLMo2RVZ72RJkgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dai+Nv0DnXo/TyaGPBWt+5CHFrmzcHo4hum3sU+E14w20mTlzX7EW24FCI9FWbGx5
	 POiL6S451eiXDkNdis2BSF2RptYa43uWWX+c4eX/0fB+r0K67wfuj30xI8xU4kO53l
	 vmNTSkNBEtUGekD0jxmO21XG4RpMAILBc5kd8dMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 286/474] mptcp: sockopt: set timestamp flags on subflow socket, not msk
Date: Fri, 15 May 2026 17:46:35 +0200
Message-ID: <20260515154721.189361879@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Yan <yangang@kylinos.cn>

commit 5f95c21fc23a7ef22b4d27d1ed9bb55557ffb926 upstream.

Both mptcp_setsockopt_sol_socket_tstamp() and
mptcp_setsockopt_sol_socket_timestamping() iterate over subflows,
acquire the subflow socket lock, but then erroneously pass the MPTCP
msk socket to sock_set_timestamp() / sock_set_timestamping() instead
of the subflow ssk. As a result, the timestamp flags are set on the
wrong socket and have no effect on the actual subflows.

Pass ssk instead of sk to both helpers.

Fixes: 9061f24bf82e ("mptcp: sockopt: propagate timestamp request to subflows")
Cc: stable@vger.kernel.org
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260427-net-mptcp-misc-fixes-7-1-rc2-v1-1-7432b7f279fa@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -161,7 +161,7 @@ static int mptcp_setsockopt_sol_socket_t
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast(ssk);
 
-		sock_set_timestamp(sk, optname, !!val);
+		sock_set_timestamp(ssk, optname, !!val);
 		unlock_sock_fast(ssk, slow);
 	}
 
@@ -237,7 +237,7 @@ static int mptcp_setsockopt_sol_socket_t
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast(ssk);
 
-		sock_set_timestamping(sk, optname, timestamping);
+		sock_set_timestamping(ssk, optname, timestamping);
 		unlock_sock_fast(ssk, slow);
 	}
 


