Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4158343CE46;
	Mon, 17 Aug 2026 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975860; cv=none; b=NL+nAOwv5/o6wFRw/w1HzLICJR7Y+R696ULT9NG8nixgpI2/OQsbECh4tiJG1MKppmr/W8ln5hTl+J9b1mmDI3qk2yTUBHtOdJx85VFgNmMjX1wPJoGHCYdiOXqwc5SUtmOCBThc/eBR58LUIVdTgJaO6ZvVZSNX32T2epgKTpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975860; c=relaxed/simple;
	bh=GW3kCPenhVyQKe36IBGFnkzSDpj60U1zQrrDHumEii8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW5ONH6McZDdxoICXXdVcT/l6U9uOooYwsRCKXx4QS44CTFVMY1OlBfAsGswHXHILZesmxiPLCbRY6LGOv+aC+TmLgptlQkhcYeU118dkaHY7LByWhB93DUwp7zCXzngl20HZwUtCXsCV7eByMkJ51m4a0BVoEA5TQWHIARj9Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRk1i1+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRk1i1+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5232B1F000E9;
	Mon, 17 Aug 2026 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975858;
	bh=hEwWwyHBtjDAb7rW9pCj53pEfxF4mycxj83tOlu3VJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRk1i1+G3HdUWgHx5lyfP2djkkosA/BjSW3LBylJTcIe/4UfZAusyRyqgyenCME7K
	 nc5QfAAi3D5L2H568EyQ1fAf72oC88uZgvMS70Ot4vN39qy64mZojTAUYKeCyEECA+
	 7lOlLZTcow9y40uz3pR32Ixqovt8FAFneAfcbEuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 173/389] net/af_iucv: fix NULL deref in afiucv_hs_callback_syn()
Date: Mon, 17 Aug 2026 15:30:12 +0200
Message-ID: <20260817132545.924534193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidayath Khan <hidayath@linux.ibm.com>

commit 47a5116e56a6b6fe1e909f244e39cd0fc26ceee4 upstream.

afiucv_hs_callback_syn() allocates the child socket with GFP_ATOMIC.
If the allocation fails, nsk is NULL.

The connection-refused path is entered when the listen state check
fails, the accept backlog is full, or nsk is NULL. The code
unconditionally calls iucv_sock_kill(nsk) in that path.

iucv_sock_kill() does not accept a NULL socket pointer and immediately
dereferences sk via sock_flag(sk, SOCK_ZAPPED). When nsk is NULL,
calling iucv_sock_kill(nsk) results in a NULL pointer dereference.

Only call iucv_sock_kill() when a child socket was successfully
allocated.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260709191732.124092-1-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1868,7 +1868,8 @@ static int afiucv_hs_callback_syn(struct
 		afiucv_swap_src_dest(skb);
 		trans_hdr->flags = AF_IUCV_FLAG_SYN | AF_IUCV_FLAG_FIN;
 		err = dev_queue_xmit(skb);
-		iucv_sock_kill(nsk);
+		if (nsk)
+			iucv_sock_kill(nsk);
 		bh_unlock_sock(sk);
 		goto out;
 	}


