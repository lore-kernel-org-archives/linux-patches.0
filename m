Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D13AEC4;
	Tue, 20 May 2025 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749503; cv=none; b=h/wxXnHmi4jt98fNYH2Nu9jBgvqwDX48CY2eYQXKbhM6hv0kcQ6JjNKL9usdn5AufwVjWbFz+dffCgv1DF+jbrNydgBJwZ8ezMI+X+GIO/fp84YKBbRTBAMSI3J/S0VgzBb3QfYy0mU/xNXjq8OjL17haCOv1XPzWXln48N7h8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749503; c=relaxed/simple;
	bh=6EGn5U4JfgfczSaG02sjgyR2U7TefjPE7WtBEhqb06k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4bGyLTX1zEV6Fuho/eVhgEObwfzWqny464Fi96q2KqezrKZw2R85WJfTFSSLoa0k6NhuU2ebWkgQHKlJpoQ5Ir+uD3h55AtGu+vmsxSPOHfO1l9HiifFLKGvaymNDhGeDIpHp9xxLXmM1Wi6J7lNhYiAF5n65DikTAWBXe5mYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCyGfK8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCyGfK8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF625C4CEE9;
	Tue, 20 May 2025 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749503;
	bh=6EGn5U4JfgfczSaG02sjgyR2U7TefjPE7WtBEhqb06k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCyGfK8CFjbcsn9HR36Pu/QvpKxT7hPYZf4ISFmOdVwj7qjbWufyjPr7F48S0EpSz
	 GV/DFswG+WSIKNHFkykkOx9aK/5UwOQ6oRoiCe5gH9vP285lucvftPQjruc8zNpDsr
	 U0nHhRzQAgsqIMb2d81rKa4kHU7Q1rwTrA4LSPec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 35/97] qlcnic: fix memory leak in qlcnic_sriov_channel_cfg_cmd()
Date: Tue, 20 May 2025 15:50:00 +0200
Message-ID: <20250520125802.035823781@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 9d8a99c5a7c7f4f7eca2c168a4ec254409670035 ]

In one of the error paths in qlcnic_sriov_channel_cfg_cmd(), the memory
allocated in qlcnic_sriov_alloc_bc_mbx_args() for mailbox arguments is
not freed. Fix that by jumping to the error path that frees them, by
calling qlcnic_free_mbx_args(). This was found using static analysis.

Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250512044829.36400-1-abdun.nihaal@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 28d24d59efb84..d57b976b90409 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -1484,8 +1484,11 @@ static int qlcnic_sriov_channel_cfg_cmd(struct qlcnic_adapter *adapter, u8 cmd_o
 	}
 
 	cmd_op = (cmd.rsp.arg[0] & 0xff);
-	if (cmd.rsp.arg[0] >> 25 == 2)
-		return 2;
+	if (cmd.rsp.arg[0] >> 25 == 2) {
+		ret = 2;
+		goto out;
+	}
+
 	if (cmd_op == QLCNIC_BC_CMD_CHANNEL_INIT)
 		set_bit(QLC_BC_VF_STATE, &vf->state);
 	else
-- 
2.39.5



