Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A544C1E87B;
	Sun,  1 Sep 2024 16:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209280; cv=none; b=SR4j7vJqG3c3DsNdffsG07ZrRCFRKxZH7N9DdpFezITIogyt9iA+OwFWfUzcy1Ab7vcqINVOZ8ky7rR+NXR5P4Xq57YDx4iKD6N43vEXGE60cwrDEzLdg6yqzPCLf40n8K6A2jDi681a9tsOPJ4xaqre74plieNT70K/RbKKyhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209280; c=relaxed/simple;
	bh=aFNpwhOz5P9rc0Fxe4zQDQzB4A0Nrs2byH/MYVGwb6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBBn4BXm51RktHndNur14QSA8YeFfAaL5JzFlk1pY8fY3dgD500AoafeJ64DLFoL3Qwn7fF6HdqDSWUFs5mxax1v5D+5d2XowO6A26MOqk1VwObUDbs5vFimOrmnNEim4b/hyArcHs/MbyAuQR9HJyQaOXWoDnCkjQXHMTs/V+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuQh+fV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuQh+fV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A227C4CEC3;
	Sun,  1 Sep 2024 16:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209280;
	bh=aFNpwhOz5P9rc0Fxe4zQDQzB4A0Nrs2byH/MYVGwb6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuQh+fV1g89CsT8iAkdkdG6k5fcTP8SQlHJOfplQsB7Ic4FfkUEBQWQvzRYv74Xr7
	 00dvfB0MENNW3fHqJn/gXvulOTpHKAD9WitjftY/Qh6XzCz9gUzaklYgzZzmfGDE6H
	 35vUvRTejjNtEKldkT/HIxVH79+IqzLO65KddTDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 16/71] mptcp: pm: do not remove already closed subflows
Date: Sun,  1 Sep 2024 18:17:21 +0200
Message-ID: <20240901160802.502821644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -825,6 +825,8 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow_get_local_id(subflow);
 
+			if (inet_sk_state_load(ssk) == TCP_CLOSE)
+				continue;
 			if (rm_type == MPTCP_MIB_RMADDR && remote_id != rm_id)
 				continue;
 			if (rm_type == MPTCP_MIB_RMSUBFLOW && !mptcp_local_id_match(msk, id, rm_id))


