Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10B6184547;
	Sun,  1 Sep 2024 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208264; cv=none; b=rb26gGR3iTEICVIo3Oxv+tj100eHaA0hMVKb8hCLx6Vd7T+p6ilWF5Be8OHigXN9hOzrDGke0o4cwbfSl2HzW3AiPwKcza643VLKL1ZItBOgifSIRmDbI/wYIsQ7cDTi3l0ueKHA/cF0bqXvZWwMLBclt3nvqlJF7vJslPEETGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208264; c=relaxed/simple;
	bh=awLpId0UFi53ld3OiMxUx0m0vO5a3h1FLV9jHrWkutQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6ieLHFsJhjJ2xMBERNLu/m6SckOtgwmE5hpusUCObiMI6/A3aEeBWgQneR9VtiMl3QHSgl7h8Xvd7g4tM0110QSKkUT4b/H02lv99RGDHJ1MbDhlLH1xK0u9p7PYgNcaKeQz50s7xDMw3WpdKYZ2nXWPeCO365CBsse0DQzPpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTnKJvhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTnKJvhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B921FC4CEC3;
	Sun,  1 Sep 2024 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208264;
	bh=awLpId0UFi53ld3OiMxUx0m0vO5a3h1FLV9jHrWkutQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTnKJvhGl13bfDQPFlejjsYv1m4/8RXpt/NvNvuF/F9mk5cmM5tFQcEj06pl8Z8O2
	 mPGPM7rWenSLYymxGvvC8RI4dMsua+vcT7RILVyXgWLsCO1OIL/xaB39IavEwdunmn
	 Ic7ZrKl6PXUxnEW6Yt6QbMAahs9XK2rWixIpzeDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 021/149] mptcp: pm: reuse ID 0 after delete and re-add
Date: Sun,  1 Sep 2024 18:15:32 +0200
Message-ID: <20240901160818.262314959@linuxfoundation.org>
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

commit 8b8ed1b429f8fa7ebd5632555e7b047bc0620075 upstream.

When the endpoint used by the initial subflow is removed and re-added
later, the PM has to force the ID 0, it is a special case imposed by the
MPTCP specs.

Note that the endpoint should then need to be re-added reusing the same
ID.

Fixes: 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -585,6 +585,11 @@ static void mptcp_pm_create_subflow_or_s
 
 		__clear_bit(local.addr.id, msk->pm.id_avail_bitmap);
 		msk->pm.add_addr_signaled++;
+
+		/* Special case for ID0: set the correct ID */
+		if (local.addr.id == msk->mpc_endpoint_id)
+			local.addr.id = 0;
+
 		mptcp_pm_announce_addr(msk, &local.addr, false);
 		mptcp_pm_nl_addr_send_ack(msk);
 
@@ -609,6 +614,11 @@ subflow:
 
 		msk->pm.local_addr_used++;
 		__clear_bit(local.addr.id, msk->pm.id_avail_bitmap);
+
+		/* Special case for ID0: set the correct ID */
+		if (local.addr.id == msk->mpc_endpoint_id)
+			local.addr.id = 0;
+
 		nr = fill_remote_addresses_vec(msk, &local.addr, fullmesh, addrs);
 		if (nr == 0)
 			continue;


