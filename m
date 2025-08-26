Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A36352FE1;
	Tue, 26 Aug 2025 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217450; cv=none; b=hmevhD9mf5/nkTHXlHRqeSgOH200KI2MhioyAApKSyVzEfQCRPoUWOw0hHEfz+Zf7loTL1oPFhnSM4K/4W+86W1kchm9GPyF3KjsmrFGkzZK5euOc+SZNnYgnOS7+Ryu19+8NgVHBG1VyUpw/ddpDnQauWDxJ+VeKW3vNHySLys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217450; c=relaxed/simple;
	bh=ZzS+/68fUGCGxMKQrQIM4q+2YGlsUZkJBukL+cGoVUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt22ovSPb79lWNfAdxL3leSggrEXqE0vU98JVO5BRjeccF1UsQ9birEcrl41K8rq2QYwxSLWeUzO6puyq8xW2ryDu66TbQXS1Mbai4jOSx3BZXR9UGUhK+13+wCbZ+VRjhcHKPNVZfDEucjIQpwL9ddjBhjv/j994p6vQLnkU6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRvLAN4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRvLAN4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AEFC4CEF1;
	Tue, 26 Aug 2025 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217450;
	bh=ZzS+/68fUGCGxMKQrQIM4q+2YGlsUZkJBukL+cGoVUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRvLAN4xu6Hl+xW1XMNVyASaPIwthPuYGz/0+ICYdU52ZihLH49HQLl9Ot94bcKtY
	 LWTR5kcoXKZUj5hV1LHKvWhiYN7u212wT0BfBamPnz5LSVdFLut2pTilF3uCnr8thC
	 pssdGI1D9Bi+XmcI4fZ5cm5Ww8Z47Zt/hOf27010=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/523] apparmor: ensure WB_HISTORY_SIZE value is a power of 2
Date: Tue, 26 Aug 2025 13:05:58 +0200
Message-ID: <20250826110928.141127423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Lee <ryan.lee@canonical.com>

[ Upstream commit 6c055e62560b958354625604293652753d82bcae ]

WB_HISTORY_SIZE was defined to be a value not a power of 2, despite a
comment in the declaration of struct match_workbuf stating it is and a
modular arithmetic usage in the inc_wb_pos macro assuming that it is. Bump
WB_HISTORY_SIZE's value up to 32 and add a BUILD_BUG_ON_NOT_POWER_OF_2
line to ensure that any future changes to the value of WB_HISTORY_SIZE
respect this requirement.

Fixes: 136db994852a ("apparmor: increase left match history buffer size")

Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/match.h | 3 ++-
 security/apparmor/match.c         | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index 884489590588..29306ec87fd1 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -141,7 +141,8 @@ unsigned int aa_dfa_matchn_until(struct aa_dfa *dfa, unsigned int start,
 
 void aa_dfa_free_kref(struct kref *kref);
 
-#define WB_HISTORY_SIZE 24
+/* This needs to be a power of 2 */
+#define WB_HISTORY_SIZE 32
 struct match_workbuf {
 	unsigned int count;
 	unsigned int pos;
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 3e9e1eaf990e..0e683ee323e3 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -672,6 +672,7 @@ unsigned int aa_dfa_matchn_until(struct aa_dfa *dfa, unsigned int start,
 
 #define inc_wb_pos(wb)						\
 do {								\
+	BUILD_BUG_ON_NOT_POWER_OF_2(WB_HISTORY_SIZE);			\
 	wb->pos = (wb->pos + 1) & (WB_HISTORY_SIZE - 1);		\
 	wb->len = (wb->len + 1) & (WB_HISTORY_SIZE - 1);		\
 } while (0)
-- 
2.39.5



