Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6738926F46F;
	Thu,  2 Jul 2026 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011074; cv=none; b=Sg+CEKzJhjcg6ZvcqleExLKtfBIZIYHNToXyEkcAeXClse95Ry/lkbeCAGhU6G9OGsqJDAEEdI9Et2SltJnbXrMOgZhwGjotnDoWezOoKu2998ZGraJ2KmP7MSGCu7hSiDfK5H0yrq+MfDUJ9pWijeFBSfuEo0dV9vWfoPkJDJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011074; c=relaxed/simple;
	bh=3a38ljGYbbtnkeg90Je20OFt8lTdrr04fGaNEQ352wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izNF4sSccaWBbAR/Gm8frCqwkuHzn2gf/uMnYm2Fa/5HSuq8NnQY3fspaI7adNKpwnkmre7MxR7nZ9IJTL+oPZ5UCyaoeBvSsHUWJ4dgT4QmlSgrRdhfcQnuyRwcB46FZ+tfVQWtHeC4IVWcCa0B0+P9JjD1sxlkNFLQSOfrnhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMSqBFGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMSqBFGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC31A1F000E9;
	Thu,  2 Jul 2026 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011073;
	bh=J/6v53wRgFAj7/pzJJeE3xHQKqtX2PDjEgVZ7Uy4Sto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMSqBFGEb+BXTLCipMbO1JotQ9ftgmOO+CuEflXliarQuZIg6IVN0Pz4WD9piBkp1
	 sbwRQs01iKbviRGhjACi+WMUrx8grLAcGrmYVo5XajcEuA8C7csDRJtMzSF/uyuVqE
	 GTHemm4ijqmG4ItTU6BPXl2fLopIwjnbyWcCb5NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/175] batman-adv: tp_meter: initialize dup_acks explicitly
Date: Thu,  2 Jul 2026 18:19:53 +0200
Message-ID: <20260702155117.716714341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit b2b68b32a715e0328662801576974aa37b942b00 upstream.

When an ack with a sequence number equal to the last_acked is received, the
dup_acks counter is increased to decide whether fast retransmit should be
performed. Only when the sequence numbers are not equal, the dup_acks is
set to the initial value (0).

But if the initial packet would have the sequence number
BATADV_TP_FIRST_SEQ, dup_acks would not be initialized and atomic_inc would
operate on an undefined starting value. It is therefore required to have it
explicitly initialized during the start of the sender session.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index f350a60e6c76b9..750e5e9d3dc9d6 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1045,6 +1045,7 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	tp_vars->icmp_uid = icmp_uid;
 
 	tp_vars->last_sent = BATADV_TP_FIRST_SEQ;
+	atomic_set(&tp_vars->dup_acks, 0);
 	atomic_set(&tp_vars->last_acked, BATADV_TP_FIRST_SEQ);
 	tp_vars->fast_recovery = false;
 	tp_vars->recover = BATADV_TP_FIRST_SEQ;
-- 
2.53.0



