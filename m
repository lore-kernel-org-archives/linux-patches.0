Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FAE188A28;
	Tue, 10 Sep 2024 10:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963558; cv=none; b=bimNAnyBihX1GNwtu6xCoJi2xL3z7/EaohlDHr2osTrKmJCzdyID3kQCJcuaTcxdgD7+6od6rnxlw1vNX7XuALxHs4+NmQ2RGo9nH/4Zf+QqTqHCl3zIlxiPja/oMKdQUM19zMM5eD68S3DVMwotT33xnufWe8S1a332IcwbGSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963558; c=relaxed/simple;
	bh=lyMOJYo40ct3soyuxGzw1SZl66zuIVk44BboJa+frbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv04hRObMGY19fH5HA/3XkyNeAvEapnHnxyT/l44vzYchq0dxd+MAs2F4XdyGruFoydEJ0APFD+gIbfkytk567HP4y1JHpKtAdLc4ITID1YyGgj0mBE7lixpBq3Sf3VPk5QvupHBXT5sFE+jNJKJczBzvnOP2rNfras4zUOmKmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZgqKh+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZgqKh+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD1FC4CEC3;
	Tue, 10 Sep 2024 10:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963558;
	bh=lyMOJYo40ct3soyuxGzw1SZl66zuIVk44BboJa+frbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZgqKh+IOv6cAUMhaqpgJNfEb7y7FyjuYs2NW/R1x4q2gAqYXac3Lf9KfEMoxZg9g
	 Uk133Mb9p55K6/S+1LSI8xBf7IK0CYZSVtu+bZbOAZp2Exx4KZvuNdoUoyoFDgeuoe
	 FiPWE9lUqA/zIi3tsiRJSS8KqpfoMu+f2v99hMus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 099/214] mptcp: pm: do not remove already closed subflows
Date: Tue, 10 Sep 2024 11:32:01 +0200
Message-ID: <20240910092602.844169875@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 58e1b66b4e4b8a602d3f2843e8eba00a969ecce2 upstream.

It is possible to have in the list already closed subflows, e.g. the
initial subflow has been already closed, but still in the list. No need
to try to close it again, and increments the related counters again.

Fixes: 0ee4261a3681 ("mptcp: implement mptcp_pm_remove_subflow")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in pm_netlink.c, due to commit 3ad14f54bd74 ("mptcp: more
  accurate MPC endpoint tracking") which is not in this version, and
  changes the context. The same fix can be applied here by adding the
  new check at the same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -767,6 +767,9 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow->local_id;
 
+			if (inet_sk_state_load(ssk) == TCP_CLOSE)
+				continue;
+
 			if (rm_type == MPTCP_MIB_RMADDR)
 				id = subflow->remote_id;
 


