Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324FBE56A;
	Fri, 15 May 2026 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862765; cv=none; b=jbcRCNQfK0DrizVnIW4r5vGm1j4HkzBE0LWk+kLFRiOXxEZy/7x9eQfXeCVkDRJCD2b7ifVpAxuLt9E98E6syLF09cr/PqfxW/TlnRpwd+Yhm+UqiMZaO/xi2NDnO6ZgPJAoIeGsPWkR8Veqfysl4usFnCgXCNDKkkPRI1gzQIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862765; c=relaxed/simple;
	bh=TjqduLrxMPOZ5pCa8dxwSasU3zph4nxMeA+XObkUd80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWxzYzuCZWhdQabeFhAQAnznninwd+Hq4TUCzAJcp3cbfLUmitAbVD5NWemT/cnw1nAaW6SFK3SHdKjN5nzDvMLxF9daTJt/KByz4Dzr9stkpYjgGG/Ua+VHJZJZozka/2Ulav4CDGGIKVwpm6nmrnpdlUVBtgCM1bILV0fT9xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6arAgXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6arAgXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC969C2BCB0;
	Fri, 15 May 2026 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862765;
	bh=TjqduLrxMPOZ5pCa8dxwSasU3zph4nxMeA+XObkUd80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6arAgXBDjDY92ieQZVtpsTXZe0c04yUeOhM7t60ZitT3Te+qfP2QeiQRVBAbnute
	 2FggBu5G677DQRDZGjlyzrkVrnZhyHPsqXwnnfP3J9+Wmhryv84SDfDp9RcbBVAVM/
	 4uXPtrr9/qnM6O1tUonMIq+IPs15xfgqPOaMtlJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Morris <bmorris@anthropic.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 172/201] sctp: revalidate list cursor after sctp_sendmsg_to_asoc() in SCTP_SENDALL
Date: Fri, 15 May 2026 17:49:50 +0200
Message-ID: <20260515154702.298607868@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Ben Morris <bmorris@anthropic.com>

commit abb5f36771cc4c05899b34000829a787572a8817 upstream.

The SCTP_SENDALL path in sctp_sendmsg() iterates ep->asocs with
list_for_each_entry_safe(), which caches the next entry in @tmp before
the loop body runs.  The body calls sctp_sendmsg_to_asoc(), which may
drop the socket lock inside sctp_wait_for_sndbuf().

While the lock is dropped, another thread can SCTP_SOCKOPT_PEELOFF the
association cached in @tmp, migrating it to a new endpoint via
sctp_sock_migrate() (list_del_init() + list_add_tail() to
newep->asocs), and optionally close the new socket which frees the
association via kfree_rcu().  The cached @tmp can also be freed by a
network ABORT for that association, processed in softirq while the
lock is dropped.

sctp_wait_for_sndbuf() revalidates @asoc (the current entry) on re-lock
via the "sk != asoc->base.sk" and "asoc->base.dead" checks, but nothing
revalidates @tmp.  After a successful return, the iterator advances to
the stale @tmp, yielding either a use-after-free (if the peeled socket
was closed) or a list-walk onto the new endpoint's list head (type
confusion of &newep->asocs as a struct sctp_association *).

Both are reachable from CapEff=0; the type-confusion path gives
controlled indirect call via the outqueue.sched->init_sid pointer.

Fix by re-deriving @tmp from @asoc after sctp_sendmsg_to_asoc()
returns.  @asoc is known to still be on ep->asocs at that point: the
only callers that list_del an association from ep->asocs are
sctp_association_free() (which sets asoc->base.dead) and
sctp_assoc_migrate() (which changes asoc->base.sk), and
sctp_wait_for_sndbuf() checks both under the lock before any
successful return; a tripped check propagates as err < 0 and the loop
bails before the re-derive.

The SCTP_ABORT path in sctp_sendmsg_check_sflags() returns 0 and the
loop hits 'continue' before sctp_sendmsg_to_asoc() is ever called, so
the @tmp cached by list_for_each_entry_safe() still covers the
lock-held free that ba59fb027307 ("sctp: walk the list of asoc
safely") was added for.

Fixes: 4910280503f3 ("sctp: add support for snd flag SCTP_SENDALL process in sendmsg")
Cc: stable@vger.kernel.org
Signed-off-by: Ben Morris <bmorris@anthropic.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260508001455.3137-1-joycathacker@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1986,6 +1986,15 @@ static int sctp_sendmsg(struct sock *sk,
 				goto out_unlock;
 
 			iov_iter_revert(&msg->msg_iter, err);
+
+			/* sctp_sendmsg_to_asoc() may have released the socket
+			 * lock (sctp_wait_for_sndbuf), during which other
+			 * associations on ep->asocs could have been peeled
+			 * off or freed.  @asoc itself is revalidated by the
+			 * base.dead and base.sk checks in sctp_wait_for_sndbuf,
+			 * so re-derive the cached cursor from it.
+			 */
+			tmp = list_next_entry(asoc, asocs);
 		}
 
 		goto out_unlock;


