Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981E62D0602;
	Thu,  2 Jul 2026 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011431; cv=none; b=tFAGvzkJ9rFv7iaXGzN/25tDfUvVuD49fw7Xt4MIJjGvr7Adrpgju/2bHyTn1xd3iZJuOTCkMSrFW+pLBykx4QuaWkTWRO0JYIGJvXn37U+jvxVdA+d49yobdd2pMRj1TLYvpS4VTbDoi77S66GN/6VHSTxBEz8pCg0sWZLX3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011431; c=relaxed/simple;
	bh=cpxSxlFD1Rpa5ZrYUof6RTpaLpApMx8U6m7nrqM5ZNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZ0xLEKxpxrzPvazZuAGF7mdQjsgzD3axvcnWG/zcdB+iOtxUZltrQb1Kkntz7iBqZ0Kg6+ZIMDH02hJglaSomlSsei30oXwfyM+Hy+4WVaaWs/ykzVCJ4PtHc2MA3zevB8W3BX7DOMqdNcqx35ShwOmZVhAlaiEhBWSPD4A/wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/jpkZGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/jpkZGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0960B1F00A3D;
	Thu,  2 Jul 2026 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011430;
	bh=ZSzgdRCn+DcmQ/PhHpZo6lBNcRC5JA/ITHbXSoNF/Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/jpkZGH17jj5VqQK7pG/U67SnyaF74fX1p2CA2+UibPgGFjX+Bf06YfmhdiNwkLF
	 GBX7L0fEi4ktgJKwAjEYjIgj1GS6zf+9WrGfzTssOKUa7LZZdbqYRIlSV/g+Pt/OxZ
	 WRYEr7c2/LVTR3Y6Si8CXO5a39g9DAhzrJH/VYdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 107/108] net/tcp-ao: fix use-after-free of key in del_async path
Date: Thu,  2 Jul 2026 18:21:44 +0200
Message-ID: <20260702155114.330730971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: HanQuan <eilaimemedsnaimel@gmail.com>

commit 5ba9950bc9078e19b69cca1e56d1553b125c6857 upstream.

In tcp_ao_delete_key(), the del_async path skips the current_key
and rnext_key validity checks present in the synchronous path,
assuming these pointers are always NULL on LISTEN sockets.  However,
if a key was added with set_current=1/set_rnext=1 while the socket
was in CLOSE state, current_key and rnext_key will be non-NULL
after listen() transitions the socket to LISTEN.

When such a key is deleted with del_async=1, hlist_del_rcu() and
call_rcu() free the key without clearing the dangling pointers.
After the RCU grace period, getsockopt(TCP_AO_INFO) dereferences
current_key->sndid and rnext_key->rcvid from freed slab memory.

Clear current_key and rnext_key in the del_async path when they
reference the key being deleted.

Fixes: d6732b95b6fb ("net/tcp: Allow asynchronous delete for TCP-AO keys (MKTs)")
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260623015208.1191687-1-eilaimemedsnaimel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1776,6 +1776,10 @@ static int tcp_ao_delete_key(struct sock
 	 * them and we can just free all resources in RCU fashion.
 	 */
 	if (del_async) {
+		if (ao_info->current_key == key)
+			WRITE_ONCE(ao_info->current_key, NULL);
+		if (ao_info->rnext_key == key)
+			WRITE_ONCE(ao_info->rnext_key, NULL);
 		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
 		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
 		return 0;


