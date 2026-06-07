Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7573254A9;
	Sun,  7 Jun 2026 10:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828819; cv=none; b=BqxzITGNDPOq3BY+eLKpbNqQ4fGPluX9h+Bo6NAowvofgyVToRMTijEBxAjVA7aaMfd9saIfE+FQWrvJGFm4pnHfraSUbrTL9uzkiXi9oCcVfUrruQiEp0MXWOXHIc6QPWa78MdRJxF7ks619WvHcj/Kr5nt2QKX6NpVFIcw2WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828819; c=relaxed/simple;
	bh=W0jFBz4KgfZBhOlHUepPeF43MdbynhvGpHrtUtcVfLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tB/MFJNuJ3EMGjG4PX7uaCtfb+TQfzfER0hhn34a5W2JCbYC6uzUsQBBLs7rgqLQ5589UOZLzETjIBVMFXvsKkcu7PlxJQx8cqb1n25Z4xhr9xtohzajgSzl1ili9PJzosFGdpJ6F6kvolrHfQ2W7SV0TR/o8BShlswVuJaVhvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVlUNiSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVlUNiSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7B91F00893;
	Sun,  7 Jun 2026 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828818;
	bh=sS6QyzqFWffcGaZpS+fl/V4KGhUtVRZQtzOBTpNsr44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVlUNiSznSn3U/6SiPkP/jpwZn/mO61DMP4aUh+D6LtH57x+wRCHuPGAZLAuznk8a
	 54N/jiYh4NIHotkE4TAjNV4qXkTX62ii8OOdq6ncC3jrS730VQ87hV+zEKh9FlFaaz
	 7OciJ3gn0h5dXRDVeHjOpQafvBf6uYy5Hw/QzoKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	James Chapman <jchapman@katalix.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 218/332] l2tp: use refcount_inc_not_zero in l2tp_session_get_by_ifname
Date: Sun,  7 Jun 2026 11:59:47 +0200
Message-ID: <20260607095736.069649533@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 05f95729ca844704d15e49ce14868af4b403b32b upstream.

A reader in l2tp_session_get_by_ifname() can return a pointer to a
session whose refcount has reached zero. The getter takes its
reference with plain refcount_inc(), but every other session getter
in the same file (l2tp_v2_session_get, l2tp_v3_session_get, and the
corresponding _get_next variants) uses refcount_inc_not_zero()
because the IDR/RCU lookup can race with refcount_dec_and_test() ->
l2tp_session_free() -> kfree_rcu(). The ifname getter is the only
outlier; the inconsistency was raised on-list after 979c017803c4
("l2tp: use list_del_rcu in l2tp_session_unhash").

A reader inside rcu_read_lock_bh() that matches session->ifname can
be preempted between the strcmp() and the refcount_inc(). If the
last reference drops on another CPU in that window, the reader's
refcount_inc() runs on a counter that has reached zero. refcount_t
catches the addition-on-zero, prints "refcount_t: addition on 0;
use-after-free", saturates the counter, and returns the saturated
pointer to the caller. Session memory is held live by the in-flight
RCU read section, but the kfree_rcu() callback queued from
l2tp_session_free() will free it once the grace period closes; a
caller that dereferences the returned session past that point hits
a slab-use-after-free. On PREEMPT_RT local_bh_disable() is a per-CPU
sleeping lock and the preemption window is real; on stock PREEMPT
kernels local_bh_disable() is a preempt_count increment that closes
the cross-CPU race in practice (see below).

Use refcount_inc_not_zero() and continue the list walk on failure,
matching the other session getters in the file. The ifname getter
is the only session getter in net/l2tp/ that still uses the bare
refcount_inc() pattern; this change restores file-internal
consistency. The success path is unchanged.

Fixes: abe7a1a7d0b6 ("l2tp: improve tunnel/session refcount helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: James Chapman <jchapman@katalix.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260523023423.2568972-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -441,12 +441,13 @@ struct l2tp_session *l2tp_session_get_by
 	idr_for_each_entry_ul(&pn->l2tp_tunnel_idr, tunnel, tmp, tunnel_id) {
 		if (tunnel) {
 			list_for_each_entry_rcu(session, &tunnel->session_list, list) {
-				if (!strcmp(session->ifname, ifname)) {
-					refcount_inc(&session->ref_count);
-					rcu_read_unlock_bh();
+				if (strcmp(session->ifname, ifname))
+					continue;
+				if (!refcount_inc_not_zero(&session->ref_count))
+					continue;
+				rcu_read_unlock_bh();
 
-					return session;
-				}
+				return session;
 			}
 		}
 	}


