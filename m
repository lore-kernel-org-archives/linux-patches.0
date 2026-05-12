Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDEA3DD844;
	Tue, 12 May 2026 17:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608116; cv=none; b=MdCZ7QaC1yW0UqAD6r7yAHfe4DyVDusCS52IpA98hubvoXSYurCIf3TF6LKlyxLAoo/Gw+G4rxSii6cs6KFHvNZPGIodR10XLb93hycLQmrmkGeyuz7vuilQ/p8fnosVR1Rk4yl1vLNmdEjBo4RtlHsOkzhyII1KdXxnSQ/loUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608116; c=relaxed/simple;
	bh=AkZFQ+NFlf8/3D3G2jxx6iCi8SHjX76Wktfonby0dJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0zaa7G111LcwSjgYVuaP+BCdUIp1OIlIGAN3wsHDLCYefkIkrkSEM0QJej2aN8mHtov9ITzlvEGSy9nYQd0HpHX+Gd4paR+w5hYNnBTaxssku8b+udRe7nTU36GtprDm2tqAiT0RLFMB5G2HN5lwh2iIBaMi48XDG+NqF8/Z6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdIwcKT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdIwcKT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E958FC2BCB0;
	Tue, 12 May 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608116;
	bh=AkZFQ+NFlf8/3D3G2jxx6iCi8SHjX76Wktfonby0dJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdIwcKT80NbLdLRY4Oj1l15lxZkgpynSUTx0ZKXfyupsam1lnAXDn8EVd7JHKbt3a
	 VdnBRUbPoNL/1wuq4LYfrwP9Ku6xTTjfmJXZkSW6sWHdMR0yukwAZzc3znBpJbkkQG
	 WhR7+7ApUocIOF28nsRDk0Xnzv1z8AcWUIOhw8bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 162/206] mptcp: sockopt: set timestamp flags on subflow socket, not msk
Date: Tue, 12 May 2026 19:40:14 +0200
Message-ID: <20260512173936.294684482@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


