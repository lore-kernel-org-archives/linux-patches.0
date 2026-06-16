Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830523370EA;
	Tue, 16 Jun 2026 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622462; cv=none; b=S7lnEAW8eI6t8PFcfORRNQ/eDUfOeHZrlV8qWUXu3FXG/416xZhZnMGqt5FYbcSj1L2uFLsjaZBw6qaoRZr9L14CfoSk/Z+Ls1vo7drOaINK2xXc72s2Ptwtxx2F5UGnv3ZXWZknETyLd/Mk/8NC3ztL5W39QLnCVCyg2aLMM1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622462; c=relaxed/simple;
	bh=lrZ+Kn/+VhRkid+I9QanFBIAdJ5aFyz+RVgQqokZXxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvrKrtQWgufVL05LtN9OFIXgOhTx0AFWXljDtmA/DKPrCW4iOB76Q1wYSr0SWhCtVqldp+0maJ0u3lSSpUShP29VqI444UUO+ZqF/Ow9e07vt5hQSmWb1Bv4B1cYtdFhaTkD5hQtDlLQ7J94LADuQGVIcxJNzh6qUCtWMrHSqOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqoBVob/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqoBVob/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926391F000E9;
	Tue, 16 Jun 2026 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622461;
	bh=W40Lt21LYl3DZYtIrY76gmCLFvFqTYEh2hPV4mRHjkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqoBVob/aa+JE/wuzc1jr9K8SkXXYLZZv1lD0njgZiaGzBPREX0auOZe9UA4pOQYU
	 b0naA/nnmLJoNtfIMhhgJ3Fs+kKNs/IFNemQ01oDyAi4Mf5w+aDXO3C0Nm7uBgpykc
	 hVnyV5TGixxxoRyovd+AI0r40hcQkZ002aGouGIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 004/378] Bluetooth: ISO: Fix a use-after-free of the hci_conn pointer
Date: Tue, 16 Jun 2026 20:23:55 +0530
Message-ID: <20260616145109.990458131@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit f50331f2a1441ec49988832c3a95f2edacc47322 upstream.

In iso_sock_rebind_bc(), the bis pointer is cached, then the socket lock is
dropped:
	bis = iso_pi(sk)->conn->hcon;
	/* Release the socket before lookups since that requires hci_dev_lock
	 * which shall not be acquired while holding sock_lock for proper
	 * ordering.
	 */
	release_sock(sk);
	hci_dev_lock(bis->hdev);

During the unlocked window, could a concurrent close() destroy the connection
and free the bis structure, causing hci_dev_lock(bis->hdev) to access memory
after it is freed, fix this by using the hdev reference which was safely
acquired via iso_conn_get_hdev().

Fixes: d3413703d5f8 ("Bluetooth: ISO: Add support to bind to trigger PAST")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1090,7 +1090,7 @@ static int iso_sock_rebind_bc(struct soc
 	 * ordering.
 	 */
 	release_sock(sk);
-	hci_dev_lock(bis->hdev);
+	hci_dev_lock(hdev);
 	lock_sock(sk);
 
 	if (!iso_pi(sk)->conn || iso_pi(sk)->conn->hcon != bis) {


