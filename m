Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E9D1474CF;
	Thu,  5 Sep 2024 10:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530411; cv=none; b=A0y9N9Js4vnZZySifwBU7wa79lSmnV0JJGNAa32E1Ofl4dwZmDowuQzUAcaBSnPig86bisH01pBd7WMhqpYj0fUFD5/KKcvNYcAaJFiFOx18PjD7Bg13dtjCzPjV9qrrwj8jMuRwqgqOTBBakkl0ReA1K3/5Ad1clmGmZgga1kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530411; c=relaxed/simple;
	bh=t9ftBeONuJUod3K3KPzVdhfi0b43OqZT9Y4yOk88Bag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rCe2jy99v3qSp3a1UgbHRCrxXJCEi12YBLwH31acGFnGwX2qJ/K6SfbTVKl5Mag4tSxCtH0VAKlJkGzDrajWF1hguR2ZlVsDPlouGELTlc6gKhc5XuxlON62VsQnCaAsr4YkL4NqkkwKhL1g9coQUJAlshWCQuXmxsRn4oNvJEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N62m0m7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N62m0m7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB89C4CEC3;
	Thu,  5 Sep 2024 10:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530410;
	bh=t9ftBeONuJUod3K3KPzVdhfi0b43OqZT9Y4yOk88Bag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N62m0m7L0mBp4dK9NxwTyRvUfKsDPY38N3qVgwkhuOPVAGlwvvU0NR8p/JD4kx9+k
	 b9QwQAeHtzNUnBFySnj5DHaJClQcL5103sq4Ao75YN9x9YNUDLNfSu4Ca16hiAsZJd
	 rIsBH8ChSvYKnoWRIr7+0a8sB0hCodusULMjU+fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	syzbot+455d38ecd5f655fc45cf@syzkaller.appspotmail.com,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 016/101] mptcp: pm: fix ID 0 endp usage after multiple re-creations
Date: Thu,  5 Sep 2024 11:40:48 +0200
Message-ID: <20240905093716.733236661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 9366922adc6a71378ca01f898c41be295309f044 upstream.

'local_addr_used' and 'add_addr_accepted' are decremented for addresses
not related to the initial subflow (ID0), because the source and
destination addresses of the initial subflows are known from the
beginning: they don't count as "additional local address being used" or
"ADD_ADDR being accepted".

It is then required not to increment them when the entrypoint used by
the initial subflow is removed and re-added during a connection. Without
this modification, this entrypoint cannot be removed and re-added more
than once.

Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/512
Fixes: 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking")
Reported-by: syzbot+455d38ecd5f655fc45cf@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/00000000000049861306209237f4@google.com
Cc: stable@vger.kernel.org
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -627,12 +627,13 @@ subflow:
 
 		fullmesh = !!(local.flags & MPTCP_PM_ADDR_FLAG_FULLMESH);
 
-		msk->pm.local_addr_used++;
 		__clear_bit(local.addr.id, msk->pm.id_avail_bitmap);
 
 		/* Special case for ID0: set the correct ID */
 		if (local.addr.id == msk->mpc_endpoint_id)
 			local.addr.id = 0;
+		else /* local_addr_used is not decr for ID 0 */
+			msk->pm.local_addr_used++;
 
 		nr = fill_remote_addresses_vec(msk, &local.addr, fullmesh, addrs);
 		if (nr == 0)
@@ -758,7 +759,9 @@ static void mptcp_pm_nl_add_addr_receive
 	spin_lock_bh(&msk->pm.lock);
 
 	if (sf_created) {
-		msk->pm.add_addr_accepted++;
+		/* add_addr_accepted is not decr for ID 0 */
+		if (remote.id)
+			msk->pm.add_addr_accepted++;
 		if (msk->pm.add_addr_accepted >= add_addr_accept_max ||
 		    msk->pm.subflows >= subflows_max)
 			WRITE_ONCE(msk->pm.accept_addr, false);


