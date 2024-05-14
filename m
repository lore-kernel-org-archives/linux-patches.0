Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3B660BB6;
	Tue, 14 May 2024 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686384; cv=none; b=ZbtE6Ic0BVmWNgRzUS0Oo1X/+QYtCbFXo5gt1TITj1IfJcWpsqPVL3+pjaBIJMUS/4H1lYWBt0tleJdSttNHmlCtTTcfJSPxcR2LyIdhoMYby+1a2+8H/FVJa3IagXPO1ZqQ+O5JcyrrJBpoAwEJvIf3Qos149jgKTEuR4fV7bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686384; c=relaxed/simple;
	bh=hXjFJSsvxPgTG2WqCk4RBqCvEjFMlQk48mTnXHpDebs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qz1rmHncb8QDGCzAj3wfPZu9ioK4OnMCMHZ5d8agBIHW4I1gBJlt97ZBa8Y75EDmJZVi129oUNvMAzvmaC4PyKqNh1T7fE0VuOl7CRjhUR0FtNaJrCY8Fz7YDQwrEojeAVMsj3Ve0Zc5ecW9X4RcH9W8UkFh8CcQZBESx3T+lEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIVdEUVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIVdEUVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD37C2BD10;
	Tue, 14 May 2024 11:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686384;
	bh=hXjFJSsvxPgTG2WqCk4RBqCvEjFMlQk48mTnXHpDebs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIVdEUVnnLtXpnBpplzxk8zTOyyNmGrSc04ga8zeyDTv8ERgoTya1v+WHew2ChIzW
	 rGX1mfwEbvzk+og5FWienqbmlR6JgqGiNmk/uZX1rNucOTTCzJlGMRlU+P1OzZkuK2
	 wag8WO5VLlBIatNtpwAqE7en4MefBc8yjdLs758k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/236] tipc: fix a possible memleak in tipc_buf_append
Date: Tue, 14 May 2024 12:17:21 +0200
Message-ID: <20240514101023.370360938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 97bf6f81b29a8efaf5d0983251a7450e5794370d ]

__skb_linearize() doesn't free the skb when it fails, so move
'*buf = NULL' after __skb_linearize(), so that the skb can be
freed on the err path.

Fixes: b7df21cf1b79 ("tipc: skb_linearize the head skb when reassembling msgs")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Link: https://lore.kernel.org/r/90710748c29a1521efac4f75ea01b3b7e61414cf.1714485818.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 5c9fd4791c4ba..c52ab423082cd 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -142,9 +142,9 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		*buf = NULL;
 		if (skb_has_frag_list(frag) && __skb_linearize(frag))
 			goto err;
+		*buf = NULL;
 		frag = skb_unshare(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
-- 
2.43.0



