Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829053;
	b=RKiujyGExMvyPdmqOIcP1kss/CkIT9m8Zb7zOMUK/kYT1+UnHyzy6mnE1dLDl9DleqxC
	 O4+viNZV89OMEH8d2byr/hOtNK2sn0yweHjTExAtDTDyLl67ZUFo5mS+TcgLL4AFvXDIS
	 gV6X6MW4sStgQjEV82dqfW1YYWrhN8lAr/oqhruDdB6P9gJtEzm9VySNnKsTzt4BjPo+B
	 LdEKlwKn3a6L9TsEl1HOuyItfQEnbS2grl9tCtqSXJ5iZthJPpO2HWixnkY8t51ywjIs0
	 9Vr/dYETKbFVaJZC5InL015j72byEu/p9kVX45mvEdMKYD6qTqEXLwiAt/Cmr7EqAng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oCAMnKvUmgdsosIluuGDHnpWIkOT3NTgDSg7VjxkTy8=;
	b=PC3YvIymMoa7kTrPvMwbArYV/INXgP4kbYhZrar+XN9OvNpqTo8aGKNJy9lMNrnP6aeY
	 1iUoKXBfHxQ0EwN23C/vSR38LXZTKuLGapitkaSKlqxkNx1qnWqtc6es0phU++e+jFHLQ
	 b4lgjRgWWAu2LdbuOGjO0hVv5YDSWuW/q9xDlrozTEXX8aO/0lqKqDfERAtUgLqaTsJEp
	 T792dBxGrHaIKm53YPxJoAd08yJs8aH/JvWJtTmSZZvq5lHlL03vKx3OscgANH9M9nlLj
	 3VhcS5dritrnNMpokQ5BKIEcvnr3krDB3TeCkY9OnHaTD+CdNrIMkYWEXoZCz1yAiig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDyMzqTK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4010260807B1;
	Wed,  4 Nov 2026 21:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDyMzqTK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9161F00A02;
	Wed,  4 Nov 2026 21:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829053;
	bh=oCAMnKvUmgdsosIluuGDHnpWIkOT3NTgDSg7VjxkTy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDyMzqTKulNd7zpm/VJjgDRv/vh/5sx66gy0qefkYmPluhk+na05TdjhPV0Pu3zuO
	 b6WQaGciTwhbIs4WDqmARWqXMCGZ8WtAStvhGgurpgF2m7F3T0OFR09O23Txy0kS9Z
	 tull+A2/DftY/mjdDQGtNDU1sDxH7vQdlF202rpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 414/547] NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients
Date: Wed,  4 Nov 2026 16:09:58 -0500
Message-ID: <20261104211050.082508101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 95ff0c079b9cab91f2327beb4197a3bc48c71f55 upstream.

deleg_reaper() sends CB_RECALL_ANY to every ACTIVE client holding
delegations, but CB_RECALL_ANY is an NFSv4.1 operation. An NFSv4.0
client's callback service accepts only CB_GETATTR and CB_RECALL, so it
replies OP_ILLEGAL. The decoder maps the unexpected opnum to -EIO, and
nfsd4_cb_done() marks the client's callback channel down.

Nothing brings the channel back. nfsd4_run_cb_work() sets NFSD4_CB_UP
only for a minor version above zero, and the only nfsd4_probe_callback()
call site an NFSv4.0 client reaches is nfsd4_setclientid_confirm(). One
visit from the reaper therefore leaves the channel marked down until the
client re-establishes its clientid. RENEW then returns
NFS4ERR_CB_PATH_DOWN for as long as the client holds delegations.
nfsd4_cb_channel_good() stops returning true, so the client is granted
no further delegations.

Skip clients at minor version zero.

Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260817-recall-any-keep-count-v5-1-3b2cffce701e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7915,6 +7915,8 @@ deleg_reaper(struct nfsd_net *nn)
 	list_for_each_safe(pos, next, &nn->client_lru) {
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
 
+		if (clp->cl_minorversion == 0)
+			continue;
 		if (clp->cl_state != NFSD4_ACTIVE)
 			continue;
 		if (list_empty(&clp->cl_delegations))


