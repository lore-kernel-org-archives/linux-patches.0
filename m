Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E022C11CD;
	Wed, 25 Feb 2026 06:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002570; cv=none; b=YVfrdvEzONgxxHNkdy3oSukFBxbE5QexpcGAB7kPNLR3kHwuPKivLqPlYrpoYCjgSMame0uv5Zg6TeyUR6xilyTrMy8mTOZdN7/iCdktKXa2vHJP0dcgczx5aKkc0Wh/iMYplp49dNtATrKFvILD8dxe0f6CpmP577AAZUE2ylo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002570; c=relaxed/simple;
	bh=nESeSyYF8tk5gCcr6tqKEDO3ToDdQP4kBTxXyLQGXf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTGpp+M1h0/rpqUaV/AEEZWB5spvYYXJ+6eX6lxFJhOk4EqUe0jNnKdsndxb5WbqLBHbE5lG/M7uNFGNTt3ptLF6RZawn8N+cQrDgubo/zh+gohgEldapPmE8zX96GEVWp+FpIXo+RRc8KhOB4v3D0Wm3L0goasJDKyr3Z+3EfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUVW5ofF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUVW5ofF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D967FC2BC86;
	Wed, 25 Feb 2026 06:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002569;
	bh=nESeSyYF8tk5gCcr6tqKEDO3ToDdQP4kBTxXyLQGXf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUVW5ofF5QwEJdtlvIBz2hTcebKgPLjEXlNbfCgCpVl2RxsfFb5sHd3xzVrt2lvog
	 UlG42g4HiqjiRbLLLqip7HZQyHIlwodnrXG7DZakbOoRVyne5JbklIkvdB1Dlui5kq
	 ahI5ajY9j/icA3XjNwoUUbaaE5UCxaJzIQa3Uudo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Votokina Victoria <Victoria.Votokina@kaspersky.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 303/641] nfc: hci: shdlc: Stop timers and work before freeing context
Date: Tue, 24 Feb 2026 17:20:29 -0800
Message-ID: <20260225012356.084900523@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Votokina Victoria <Victoria.Votokina@kaspersky.com>

[ Upstream commit c9efde1e537baed7648a94022b43836a348a074f ]

llc_shdlc_deinit() purges SHDLC skb queues and frees the llc_shdlc
structure while its timers and state machine work may still be active.

Timer callbacks can schedule sm_work, and sm_work accesses SHDLC state
and the skb queues. If teardown happens in parallel with a queued/running
work item, it can lead to UAF and other shutdown races.

Stop all SHDLC timers and cancel sm_work synchronously before purging the
queues and freeing the context.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4a61cd6687fc ("NFC: Add an shdlc llc module to llc core")
Signed-off-by: Votokina Victoria <Victoria.Votokina@kaspersky.com>
Link: https://patch.msgid.link/20260203113158.2008723-1-Victoria.Votokina@kaspersky.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/hci/llc_shdlc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 4fc37894860c9..08c8aa1530d8a 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -762,6 +762,14 @@ static void llc_shdlc_deinit(struct nfc_llc *llc)
 {
 	struct llc_shdlc *shdlc = nfc_llc_get_data(llc);
 
+	timer_shutdown_sync(&shdlc->connect_timer);
+	timer_shutdown_sync(&shdlc->t1_timer);
+	timer_shutdown_sync(&shdlc->t2_timer);
+	shdlc->t1_active = false;
+	shdlc->t2_active = false;
+
+	cancel_work_sync(&shdlc->sm_work);
+
 	skb_queue_purge(&shdlc->rcv_q);
 	skb_queue_purge(&shdlc->send_q);
 	skb_queue_purge(&shdlc->ack_pending_q);
-- 
2.51.0



