Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BDA537FF;
	Sun,  1 Sep 2024 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208356; cv=none; b=nXJXo7x0Tq7ky0ZxmAycyEtzceOarv0f5yqNGMZp9kW/Lz91dPW5Sw0cXxH/rK2m+iLKrt1CkPrhm1O381X3q57HapUkuloYdPmN3D2JVaX8nrWXezd2O5HCuroD/vy25wf78VIiJtxShcPfFRj4mxE4+ViDkzI15jsCd+EWJvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208356; c=relaxed/simple;
	bh=8VfOJJvfQKqiAq/7zqIBAgUHJd6EGOv/qiwnz3fC4o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moUfZ1oAuBaQPA4Cde6REZuZ8UqW22JwC6mZZwbEkD4/Sz+9XO0Vw93f1WlLZWOlyQxhljSYFupCY48sfaIiqsFS455xmlZ2+1fVg0k5RrQxxNik0H0NhO8/3zdIjF01WcYAD5kbV3/rKN7MS2dI33iS9iFZaTy1RVybxFvFmdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M31fH/hF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M31fH/hF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93646C4CEC3;
	Sun,  1 Sep 2024 16:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208356;
	bh=8VfOJJvfQKqiAq/7zqIBAgUHJd6EGOv/qiwnz3fC4o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M31fH/hFqw7SjIdgK8MT4VknRkXM4NTClGvlrgDnvS0XN3uztAAAqSKdlTCHK0Wy8
	 1oymT1NiCfxNPdG34u9dQK7zwMJ4lYkAn3Nxyo8RVeqi4X8jCH5XpG3mJ35+K/v3fg
	 gLUbA7VCSu1RCIPjd/8kgoGhkXRzY5MqFQvKEns8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 026/149] mptcp: pm: do not remove already closed subflows
Date: Sun,  1 Sep 2024 18:15:37 +0200
Message-ID: <20240901160818.448757922@linuxfoundation.org>
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

commit 58e1b66b4e4b8a602d3f2843e8eba00a969ecce2 upstream.

It is possible to have in the list already closed subflows, e.g. the
initial subflow has been already closed, but still in the list. No need
to try to close it again, and increments the related counters again.

Fixes: 0ee4261a3681 ("mptcp: implement mptcp_pm_remove_subflow")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -838,6 +838,8 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow_get_local_id(subflow);
 
+			if (inet_sk_state_load(ssk) == TCP_CLOSE)
+				continue;
 			if (rm_type == MPTCP_MIB_RMADDR && remote_id != rm_id)
 				continue;
 			if (rm_type == MPTCP_MIB_RMSUBFLOW && id != rm_id)


