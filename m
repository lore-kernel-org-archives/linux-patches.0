Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180FB2882C9;
	Thu, 27 Nov 2025 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255206; cv=none; b=XVvhxihS5DasaRHUvP/9TCgzUu/0WntEAUCmLApweuVpvfLiVu5rxWCfJUSw8+G0tYirgXlrQZloLShk5Q6NMSjIaBCU9PBKRXcq3z3QvPVjSGcjdu1/85HCz65YOaLK6QKvR/B0LAAd1oUz67tLYpXpwIKr9bTo5fCS3srtH28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255206; c=relaxed/simple;
	bh=Ta1xi6669fNTigz6L8qQavLt0YU/PUqu/E2gSdwp47g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvCeWcy4UTGFyUrU5+O+HyW642/GlCdp18jswLBoShgpupbmcdnEPgISGtLJGdIGaCZu6qbTw/C+yq6nkRjo/XRmu6LOvQq83B4klcJbXm3fdiYgCMR6i8DXqlMcmrsgEO9jsvbKtyMuJeTA6tmTs2I7exBGaHVA2J51f359pcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9mufY/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9mufY/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8821BC4CEF8;
	Thu, 27 Nov 2025 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255205;
	bh=Ta1xi6669fNTigz6L8qQavLt0YU/PUqu/E2gSdwp47g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9mufY/bO10ojAGH87VSPJRsbivaNL2m4CpFksCcGe7BFiq7XLFtlTKBM8ZJSBGa5
	 G6KF9nxKhlrS8M4OauhuMvwZsIwvp2/7w5pTMi8UVMn5FOAWFOOn3k4/Rf96rATyLk
	 50ZVzMyVz1W+7LvLQGZM0/96o+sZsyWgJK9lFcTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 044/112] mptcp: do not fallback when OoO is present
Date: Thu, 27 Nov 2025 15:45:46 +0100
Message-ID: <20251127144034.453818002@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 1bba3f219c5e8c29e63afa3c1fc24f875ebec119 upstream.

In case of DSS corruption, the MPTCP protocol tries to avoid the subflow
reset if fallback is possible. Such corruptions happen in the receive
path; to ensure fallback is possible the stack additionally needs to
check for OoO data, otherwise the fallback will break the data stream.

Fixes: e32d262c89e2 ("mptcp: handle consistently DSS corruption")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/598
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-4-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -906,6 +906,13 @@ static bool __mptcp_finish_join(struct m
 	if (sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
+	/* The caller possibly is not holding the msk socket lock, but
+	 * in the fallback case only the current subflow is touching
+	 * the OoO queue.
+	 */
+	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
+		return false;
+
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_subflows) {
 		spin_unlock_bh(&msk->fallback_lock);


