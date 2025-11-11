Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972C34C97;
	Tue, 11 Nov 2025 00:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822229; cv=none; b=DHclDOXmbhH2W1lPXZqdTA+JwS6bX7WSeZrisxXSi8qzJKhDfopZ/SqouRkNvivy5bkfOARNBlj7ZnJPIQHAhImjLoUN1Em56lx7IuU/yliYIMXRqqFEAPU1Exi7wUN/+RdIjitsKd7vDjXj/v3OyY+iqLqrd5bjTebQAYwP25k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822229; c=relaxed/simple;
	bh=aQH/kLC0dg2EojRf8H0IM1GDWh81HFtBT+uSCTjL8/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptJ5/xJ4JkKrFrG1zn/qKvE46HAA+mduYN1nUke/G83rsPC/DjG64a4h3oSVrngicXvSuXDGO91WRL/H00dNw5lnVZR4y1Nms0JLb56Jof08kemWAOe5vHEQEDAa8ifHsZ7kv3LIrTJZOD7XDdH8NcOKgKhN7HD7GWTEqSBuSP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaZvre7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaZvre7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0D3C116B1;
	Tue, 11 Nov 2025 00:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822229;
	bh=aQH/kLC0dg2EojRf8H0IM1GDWh81HFtBT+uSCTjL8/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaZvre7xbRfgmMQ8NNjk/wU0fzXLnjhAwW6otfD3WHyfbglY55q5nV4+nxQqZnuLc
	 C6kRp6gzYE7GgJalMkzOKPsh/41gOXe+KuGZMLH3fKEyktrLXPkEN0cw+oeF+vTk8k
	 GNQ4o3LihrUGKXzjZvs/JTwpmUmMohWwWvlfmgtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 062/849] Bluetooth: ISO: Fix another instance of dst_type handling
Date: Tue, 11 Nov 2025 09:33:52 +0900
Message-ID: <20251111004537.931894668@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c403da5e98b04a2aec9cfb25cbeeb28d7ce29975 ]

Socket dst_type cannot be directly assigned to hci_conn->type since
there domain is different which may lead to the wrong address type being
used.

Fixes: 6a5ad251b7cd ("Bluetooth: ISO: Fix possible circular locking dependency")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 4351b0b794e57..6e2923b301505 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2035,7 +2035,13 @@ static void iso_conn_ready(struct iso_conn *conn)
 		}
 
 		bacpy(&iso_pi(sk)->dst, &hcon->dst);
-		iso_pi(sk)->dst_type = hcon->dst_type;
+
+		/* Convert from HCI to three-value type */
+		if (hcon->dst_type == ADDR_LE_DEV_PUBLIC)
+			iso_pi(sk)->dst_type = BDADDR_LE_PUBLIC;
+		else
+			iso_pi(sk)->dst_type = BDADDR_LE_RANDOM;
+
 		iso_pi(sk)->sync_handle = iso_pi(parent)->sync_handle;
 		memcpy(iso_pi(sk)->base, iso_pi(parent)->base, iso_pi(parent)->base_len);
 		iso_pi(sk)->base_len = iso_pi(parent)->base_len;
-- 
2.51.0



