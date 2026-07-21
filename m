Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CF729CE9;
	Tue, 21 Jul 2026 21:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669097; cv=none; b=fy2ikxWJN1ss8mPJsKpp7mpFSiLG1+kExft2W0oI3JOgKk6NsehCu4FeozzDhfL6lQJGwft1nGWQycNh97S9J5DtU6Mp2K1XbhPM9G5EcEVHVWZ7RKiprqitrhrXHawTQGOWmD7bTSWJaGAPnDRxDrU96whVCOIRz/Q3ocuEDLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669097; c=relaxed/simple;
	bh=bf7gjjn+kRx1IfAEegETkfHSZ8wzPfusjuK9qF/aP10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZaxkQJHcYRF561mACKFuzvJKm4PMn0WXMuBKbP7xJseUOZMJdktQ3MPrkRQBgN1II4eIje1aMO1OFgnqVvU3VpQT/M5csUIm+t6VVJqO2B4HOnT1hADAEldSmsrdYrPu4HHF+TjEZGA6EpTHjSOch2EHiWhDA4NFpRqE1Ianms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpHRtwH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpHRtwH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C741F000E9;
	Tue, 21 Jul 2026 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669095;
	bh=B23fKGrKJ5eqSGqKOzSgU1FzflSBdBFhvlDVcTWtwko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpHRtwH59y3xjrkZEjof3oxfUypeYlu9QQfahD4YcTlBhKPBeXly2u3LnBWPBCHR2
	 w5VC1+HPWsneMU2/r6E7NYQx5eRDkXJoeqMRiboVWOOQHFp7+JBaHNW+n9A9qQocki
	 iuNqJUBSnhH/e5pM4EjKclBekQEyB4nx9a+y/eOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0382/1067] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
Date: Tue, 21 Jul 2026 17:16:23 +0200
Message-ID: <20260721152433.177107445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 9e37388b8070afe73d4ab2d973b28593ed65f3ad ]

nf_ct_seqadj_init() is called without holding the ct lock. This can race
with nf_ct_seq_adjust() when a connection is in CLOSE state due to an
RST or connection reopening. In addition for SYN_RECV state, concurrent
processing of packets can trigger nf_ct_seq_adjust() too. These
situations create a read/write data race.

As synproxy is the only user of nf_ct_seqadj_init() at the moment, fix
this by holding ct->lock inside nf_ct_seqadj_init() until all is done.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_seqadj.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 7ab2b25b57bcc0..b7e99f34dfce86 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -17,12 +17,14 @@ int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	if (off == 0)
 		return 0;
 
+	spin_lock_bh(&ct->lock);
 	set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
 
 	seqadj = nfct_seqadj(ct);
 	this_way = &seqadj->seq[dir];
 	this_way->offset_before	 = off;
 	this_way->offset_after	 = off;
+	spin_unlock_bh(&ct->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
-- 
2.53.0



