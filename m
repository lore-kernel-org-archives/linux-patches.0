Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319DA28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949F1C433D2;
	Mon, 30 Jan 2023 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087108;
	bh=DF3x40a0utjjNLP7HSksTDE0OBlCuTcRfBI7yH0Dslk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8SZrPiizPIS0istRvmAyI2Xu3jZDx5PcevIynTyw81zpdSNboTJQWiCWQEGqSFkW
	 oKEi99CaS+TkgICeL0IXSWQ6eKEIArB8ixdboCODTSrxTER2QQ6nC3M7mlaKo3lJFu
	 C7GAdsX3fzuYfC7kFFOyQfDA4WP+L9dJPs1AW978=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Brian Gix <brian.gix@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/313] Bluetooth: Fix a buffer overflow in mgmt_mesh_add()
Date: Mon, 30 Jan 2023 14:48:53 +0100
Message-Id: <20230130134341.197205223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 2185e0fdbb2137f22a9dd9fcbf6481400d56299b ]

Smatch Warning:
net/bluetooth/mgmt_util.c:375 mgmt_mesh_add() error: __memcpy()
'mesh_tx->param' too small (48 vs 50)

Analysis:

'mesh_tx->param' is array of size 48. This is the destination.
u8 param[sizeof(struct mgmt_cp_mesh_send) + 29]; // 19 + 29 = 48.

But in the caller 'mesh_send' we reject only when len > 50.
len > (MGMT_MESH_SEND_SIZE + 31) // 19 + 31 = 50.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Brian Gix <brian.gix@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt_util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt_util.h b/net/bluetooth/mgmt_util.h
index 6a8b7e84293d..bdf978605d5a 100644
--- a/net/bluetooth/mgmt_util.h
+++ b/net/bluetooth/mgmt_util.h
@@ -27,7 +27,7 @@ struct mgmt_mesh_tx {
 	struct sock *sk;
 	u8 handle;
 	u8 instance;
-	u8 param[sizeof(struct mgmt_cp_mesh_send) + 29];
+	u8 param[sizeof(struct mgmt_cp_mesh_send) + 31];
 };
 
 struct mgmt_pending_cmd {
-- 
2.39.0



