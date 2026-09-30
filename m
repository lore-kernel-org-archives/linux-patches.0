Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225684D1787;
	Wed, 30 Sep 2026 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783741; cv=none; b=brd8bbRf0lhPDINJd6Sfgxpbwwgw8xyu2kqG/JVVKE+pwlpnZTxSnmMPrZ8rdN0cnUd4fvFFr+tIPqdfxWhtWv+9VlvjbM52ban+7yBNyqBVGq0w8K28D1j6epIMA4l/S9nuejllFcm/J0rcUOweAjeLceQg8GUUaBlSOBroTLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783741; c=relaxed/simple;
	bh=LfF5Pkj7MAcxBFc2eacVCFMAedi6cNVq7DL3b9/21rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvkO3R8emx3L9xCIYdOntsWX2Nl4Dr60p4VtZL6uz7SQmeW19Hw6SNY+qf0E6WRw4PfeooZc60KaJuaVovSb3Hzrltg4QoYRlYVGnGFfvAeGsztHLA/ZVj9vZmdthnoU6qUTsdCAzKw4MdEs1E0hkEFmZnLbyVRXMU3QKEau6Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csnz5eFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csnz5eFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EA51F00898;
	Wed, 30 Sep 2026 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783736;
	bh=kjJ52cNpi0VRfKNqVFE1pCCKbvGgmtUIRLff10h659I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csnz5eFGholFewVqHeoDhVC19du7g2y1hxlUTzSYGPF1BCftPFLTdoo4t/Tw4+UQd
	 EUsfwxrgB5kyMgD2KfC3dNrEDiYrpv2T5/rap4c+mmepCOeNE1agef+Zt5jGPQQ8uD
	 WRNZshE4tfCcjEdrvLIy51Lv8m9fn+PxBPxMonZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 505/595] sctp: avoid livelock while updating retransmit path
Date: Wed, 30 Sep 2026 17:26:38 +0200
Message-ID: <20260930152358.561772935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Yiqi Sun <sunyiqixm@gmail.com>

[ Upstream commit d2c31b837406395e576afeb25958c98e9938f3f6 ]

sctp_assoc_update_retran_path() can loop forever when every remaining
transport, including retran_path, is SCTP_UNCONFIRMED: the state check
runs before the wraparound test, so the loop cannot observe that it has
completed a full pass.

Fix this by considering a transport only when it is not UNCONFIRMED,
then checking whether the walk has returned to retran_path. This makes
the full-pass termination independent of the transport state while
preserving the existing fallback selection semantics.

Also restore the NULL guard around the retran_path assignment. In the
all-UNCONFIRMED case there is no eligible replacement transport, and
installing NULL would leave later retransmit-path users and the debug
print with a NULL path.

Fixes: 4c47af4d5eb2 ("net: sctp: rework multihoming retransmission path selection to rfc4960")
Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260915095017.942213-1-sunyiqixm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/associola.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 8fc11f06ab238..ad1a7368f6ab0 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1295,18 +1295,19 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 		/* Manually skip the head element. */
 		if (&trans->transports == &asoc->peer.transport_addr_list)
 			continue;
-		if (trans->state == SCTP_UNCONFIRMED)
-			continue;
-		trans_next = sctp_trans_elect_best(trans, trans_next);
-		/* Active is good enough for immediate return. */
-		if (trans_next->state == SCTP_ACTIVE)
-			break;
+		if (trans->state != SCTP_UNCONFIRMED) {
+			trans_next = sctp_trans_elect_best(trans, trans_next);
+			/* Active is good enough for immediate return. */
+			if (trans_next->state == SCTP_ACTIVE)
+				break;
+		}
 		/* We've reached the end, time to update path. */
 		if (trans == asoc->peer.retran_path)
 			break;
 	}
 
-	asoc->peer.retran_path = trans_next;
+	if (trans_next)
+		asoc->peer.retran_path = trans_next;
 
 	pr_debug("%s: association:%p updated new path to addr:%pISpc\n",
 		 __func__, asoc, &asoc->peer.retran_path->ipaddr.sa);
-- 
2.53.0



