Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089F616EB4B;
	Sun,  1 Sep 2024 16:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207919; cv=none; b=C30h65lyLtYN239nV8l14Ohw/GMbf31pUkIZkuf69kxvcyfgnLleSEGIKKfdHkq/8+zJww+KdEr6oAVCRgXZ7Posra6yVapxifpbtJ4ol2YqvTjCrfx0PN5AUmLaUdGqHxy+KqFm7hag9LSVMtqFiW24rDu0Ifkqj9kBrasWBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207919; c=relaxed/simple;
	bh=czUmFwjIu6cywCytCVBLpU5EZLOdinsVhnYw+1FyqLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVNcoYou1aC6hkCRm8xyMoIRIlcM943wDO5ePAS8LZYIhIFNzYi+EA3mCR8rW2nF6SL5E8It6HktmFV+o0Mf5VO1MMatrZyGZ+tIwFov9pzy2nNG+B4k6XyemGRHu/wvEG96U1r76RspilpUO8XIPBlstna1TC3tO8xvwrCJWXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcL/p5nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcL/p5nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26531C4CEC3;
	Sun,  1 Sep 2024 16:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207918;
	bh=czUmFwjIu6cywCytCVBLpU5EZLOdinsVhnYw+1FyqLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcL/p5nuR8zPNwKulmMON7cX0WH62L6gw3SgG1VrTUjvfMDXM9iOoYVQzSxRFsNei
	 AgG41waP4BaYgmYsi/iFwD/cW/PX2NDIrz0exMY2OMfzqC8Jd1AyOxuNuSpthpD5m2
	 tVdQsIjeJttEIx2steOqRGqz3gBucT8nunhfoGtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 18/93] mptcp: pm: do not remove already closed subflows
Date: Sun,  1 Sep 2024 18:16:05 +0200
Message-ID: <20240901160808.047757651@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -851,6 +851,8 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow_get_local_id(subflow);
 
+			if (inet_sk_state_load(ssk) == TCP_CLOSE)
+				continue;
 			if (rm_type == MPTCP_MIB_RMADDR && remote_id != rm_id)
 				continue;
 			if (rm_type == MPTCP_MIB_RMSUBFLOW && !mptcp_local_id_match(msk, id, rm_id))


