Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217300;
	b=v8Dm23zvc+BEUQhnDMLWSvzvYj7pRStnTXa0QsHb5VbCqR0eNIHwOgR75Nqu5bTo9ETT
	 EEy/ErPawdAgPPLLxyvF55WsnnEr3Dr8JxApqGKSGM6laBSOPL+N3H50HV8mdVTV/xg3b
	 hKSt5k25dk+akHJd1ftPgYIG9zLTvgv46vYWPkQF6wr0aAPm+fZWaKaLI3UgCPBv1nGx9
	 Hbl/R+X1EmmeLyRHw3IgMRS6/rsI6EEVT9yq8fDZn5UQQQeF+TsBLPnvyLSR0TOPPf1Af
	 RI3qIDptgFXH22jBQ7J4gxJ84KC6/eQJ6HXHtVZE1666kk/4zBelFO5bZmviU5WlS+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o4Oavpg/yutk+knFatUpuOrI0wv0THTSilBrEb/vmeI=;
	b=UGD+/0P7WEHBQyNnZJbQ4/BfhNZnT2rYj7BhQjS97gy0B6EX6N5Oghz4M9dvjd5XUsyJ
	 AqelRNirP97zkEcnHXDR8rGWi3W8AstigVokW/NkPGSSZXY6Ivm8NtF/isu6EqEvUgvAb
	 HFXXER4FWdbmw5RN6fsblH9SUG5H9wM6VEXa0m1kdFhv3irzzmYkBJQARZX2907L2785R
	 xli/25D3jRRW7xEPV+Rk6G6l9NwS3/k4by32c3fDfYEE0JW10osgEQjK5LNUhmiOjvRzl
	 KqCUO6OV/fRO1MSNNrhGCFHBKoxM0kqVyqm7GGI2DFR4qj5Q+lzOlR4Fu0FOMhJuKHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1FFde42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F092C606A336;
	Wed, 28 Oct 2026 19:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1FFde42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F38C1F031E3;
	Wed, 28 Oct 2026 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217299;
	bh=o4Oavpg/yutk+knFatUpuOrI0wv0THTSilBrEb/vmeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1FFde42KJbz1dr26LgCaPasWIfz5Wt1JTOrfD89NkLe+VP5Om3mcnLCo62wLbR6W
	 +B0cfI4hiL2etNsWc646HNxoH2XBCN3Mqq2sPP8rss0y9szrQi36Nxazjw76rUDExS
	 YAX4fICoe5RzbDfEaBe02utyPv5EYckVPBr/137Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1856/1887] Bluetooth: MGMT: Fix memory leak in set_ssp_complete
Date: Wed, 28 Oct 2026 18:05:52 +0100
Message-ID: <20261028170541.687428668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

[ Upstream commit 4db19bfd320f2124c820d3456aeae3953095ea8e ]

Fix memory leak in set_ssp_complete() where mgmt_pending_cmd structures
are not freed after being removed from the pending list.

Commit 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs") replaced
mgmt_pending_foreach() calls with individual command handling but missed
adding mgmt_pending_free() calls in both error and success paths of
set_ssp_complete(). Other completion functions like set_le_complete()
were fixed correctly in the same commit.

This causes a memory leak of the mgmt_pending_cmd structure and its
associated parameter data for each SSP command that completes.

Add the missing mgmt_pending_free(cmd) calls in both code paths to fix
the memory leak. Also fix the same issue in set_advertising_complete().

Fixes: 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 99226fe3648dc..655b260c5bb06 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1928,6 +1928,7 @@ static void set_ssp_complete(struct hci_dev *hdev, void *data, int err)
 		}
 
 		mgmt_cmd_status(cmd->sk, cmd->hdev->id, cmd->opcode, mgmt_err);
+		mgmt_pending_free(cmd);
 		return;
 	}
 
@@ -1946,6 +1947,7 @@ static void set_ssp_complete(struct hci_dev *hdev, void *data, int err)
 		sock_put(match.sk);
 
 	hci_update_eir_sync(hdev);
+	mgmt_pending_free(cmd);
 }
 
 static int set_ssp_sync(struct hci_dev *hdev, void *data)
@@ -6537,6 +6539,7 @@ static void set_advertising_complete(struct hci_dev *hdev, void *data, int err)
 		hci_dev_clear_flag(hdev, HCI_ADVERTISING);
 
 	settings_rsp(cmd, &match);
+	mgmt_pending_free(cmd);
 
 	new_settings(hdev, match.sk);
 
-- 
2.53.0



