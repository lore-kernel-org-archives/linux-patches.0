Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D1E2459D1;
	Thu, 28 May 2026 20:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999403; cv=none; b=Nk7zhiZU4StW1VLM4zC2KN6+JhmbyYynF1n+VcBMlb/z7cjtzs2wXB03yR4OnX8MSuM84QckWuz+aT5B7nffsWxhIGSj/fijPDHtsysg43NWp0s0f7xilTOAyGPTNH2E1jiDexVFU0hYiIn3iffNkyeHOflwpATtswi3btS+WtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999403; c=relaxed/simple;
	bh=YsZaaikrlzPIFVWwvhD923QWJ6JiCcKXLUzkrmaeH6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeIVE0VOWPBPgrmyqdaTMLjFVshpyv1ddzfHipBT6VWupQjWqncj4vNLujgZMcSIaGw+2rXH4TyMPHzkhMLwoJm2JGSrEnKtVEnQtXhyTCB020Y6LgYxtcmqLVz+KtauGCtwzOkZh2vnTb2i+Ky0QUEit3KweNsLul1nOFhTKoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZb2iLjn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZb2iLjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015751F000E9;
	Thu, 28 May 2026 20:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999402;
	bh=tx0neAyvPK7qJ3OVIaoaxL9IdJSPZS9d6h3AoexxnLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZb2iLjn0pgXcgmPdfnKakf6YXnPgMstqQAgkpsTlm0vuHM/UcFGEofqH9qUdSE2+
	 eQeQKWgNIm7M7ejZcr9E1YnusXdAW5hxTr56T5toKuRVz6ZEMZ4l2R1o0LuVLmCoyP
	 C/Xd4PjLJeRKJJyyFRBLF3emJmCzifyHA7e40sdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 054/377] Bluetooth: bnep: Fix UAF read of dev->name
Date: Thu, 28 May 2026 21:44:52 +0200
Message-ID: <20260528194639.934925367@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 59e932ded949fa6f0340bf7c6d7818f962fa4fd2 upstream.

bnep_add_connection() needs to keep holding the bnep_session_sem while
reading dev->name (just like bnep_get_connlist() does); otherwise the
bnep_session() thread can concurrently free the net_device, which can for
example be triggered by a concurrent bnep_del_connection().

(This UAF is fairly uninteresting from a security perspective;
calling bnep_add_connection() requires passing a capable(CAP_NET_ADMIN)
check. It also requires completely tearing down a netdev during a fairly
tight race window.)

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/bnep/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -638,8 +638,8 @@ int bnep_add_connection(struct bnep_conn
 		goto failed;
 	}
 
-	up_write(&bnep_session_sem);
 	strcpy(req->device, dev->name);
+	up_write(&bnep_session_sem);
 	return 0;
 
 failed:


