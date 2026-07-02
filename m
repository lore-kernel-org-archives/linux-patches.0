Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F56022D7B9;
	Thu,  2 Jul 2026 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011573; cv=none; b=E+Oq493Du8YVyglPTROPsALSJLH8bEhjjPKVAdHz2EaLjotlw5PsNbBQCBvcSXB30Pkgt2noDKBOinLmTpWohspGTFKTx67CEHUx8V9e6Cpf+r8A2479RBPelnGMLyJKjQaYODduIADQ4zalsX95j3wxgcIlTl6+2m+rWwh8ndc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011573; c=relaxed/simple;
	bh=7oP+D2Fd7m/zG9wAvxbeEK5xW+N+TIBpg20222STCZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHE0VuDPbhT7z6D3y12OR5DA+/2x9BDbmO/aeJYVoJJ4zIuZww0EB/oJifwTk31M2g0g0Mu+FhYC76K1N8GkdtCQ4+JpKdC2X+383H4vjuID7hnzxnAJoCBbwyof3GMNUU7l2bpCBEsEUij+WHykyc1RmuB45LQkruqoA+bB8Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXJcDLsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXJcDLsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1063B1F00A3D;
	Thu,  2 Jul 2026 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011572;
	bh=nRUs6cxs4Cnipv3oFJQkOA7pHIGcSfT/DXEs44NcCeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXJcDLsjgUBYg5W49inqeh8aL4jhx8VVgCQ1b03CWAgJshsDcyY2hSYSWVX2kAMjP
	 yjTbCWY9eSCR8HABBchs27W75r69mC/gJSVH5U/RpBg81xQRfO+urWKIn6IMptiNqo
	 41wZWpP2qDFhaGMWvCEKuTr8eLAelpNIPM6xw644=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 007/120] batman-adv: tp_meter: fix fast recovery precondition
Date: Thu,  2 Jul 2026 18:20:03 +0200
Message-ID: <20260702155113.116810278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 2b0d08f08ed3b2174f05c43089ec65f3543a025b upstream.

The fast recovery precondition checks if the recover (initialized to
BATADV_TP_FIRST_SEQ) is bigger than the received ack. But since recover is
only updated when this check is successful, it will never enter the fast
recovery mode.

According to RFC6582 Section 3.2 step 2, the check should actually be
different:

> When the third duplicate ACK is received, the TCP sender first
> checks the value of recover to see if the Cumulative
> Acknowledgment field covers more than recover

The precondition must therefore check if recover is smaller than the
received ack - basically swapping the operands of the current check.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index e4f76c141af3e2..77bc69573a5624 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -733,7 +733,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (recv_ack >= tp_vars->recover)
+		if (tp_vars->recover >= recv_ack)
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



