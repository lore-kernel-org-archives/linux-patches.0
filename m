Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F341C68C;
	Sun,  1 Sep 2024 16:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208350; cv=none; b=LH6ra+I5IlX3GIL7n+Q4/k8ItCG5uz+hl8IJrHg1TDvOX6C6t29xJOlzO7zyrAoZfuRB4Y52Qfw3GoHnI1wl5rBwDu2m/iUIzVkV43p/U8jq4Ne6EW6/jxkuaRKxoejel+QhxtefE9iJBK5lzvmAQthtVB08DTfWjpkLItc1fd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208350; c=relaxed/simple;
	bh=AoXcWgJaVorGI0eR6WJaBpSTa1gZ86YC8eMtj8+yEC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BodYK0SzlDVDZ58XDJ0T8Jy0zds1rMC+HtpA5RM67PH9lE4wgknBjTd3Cuh6pcRP7btYO6LjDvIjIbU28cv0M4roQAmHVLdMJpXC/wRKdotCdkUc0Gw0oqVhHKfesP/puFK7y9cSDJI1YtrdxnzzOlNaYiulJEoNMPjWY6Mj0lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgyqfKZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgyqfKZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7FDC4CEC3;
	Sun,  1 Sep 2024 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208349;
	bh=AoXcWgJaVorGI0eR6WJaBpSTa1gZ86YC8eMtj8+yEC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgyqfKZ/AWTj2RoCaazxEcjU06VnsJJks4gVO/mzF9cQlRKHH6g29Galemy8guo+l
	 eAU7KT59TDQ/48ib8eQ/b6BHoAh447LWGBU2yayd2dg57r1vdAlDh6V2tUQajgVQsO
	 fTf1aP+g6H0U5CB3PU0WI4+SglQBP12FhIM5H73c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 024/149] mptcp: pm: send ACK on an active subflow
Date: Sun,  1 Sep 2024 18:15:35 +0200
Message-ID: <20240901160818.374598747@linuxfoundation.org>
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

commit c07cc3ed895f9bfe0c53b5ed6be710c133b4271c upstream.

Taking the first one on the list doesn't work in some cases, e.g. if the
initial subflow is being removed. Pick another one instead of not
sending anything.

Fixes: 84dfe3677a6f ("mptcp: send out dedicated ADD_ADDR packet")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -768,9 +768,12 @@ void mptcp_pm_nl_addr_send_ack(struct mp
 	    !mptcp_pm_should_rm_signal(msk))
 		return;
 
-	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
-	if (subflow)
-		mptcp_pm_send_ack(msk, subflow, false, false);
+	mptcp_for_each_subflow(msk, subflow) {
+		if (__mptcp_subflow_active(subflow)) {
+			mptcp_pm_send_ack(msk, subflow, false, false);
+			break;
+		}
+	}
 }
 
 int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,


