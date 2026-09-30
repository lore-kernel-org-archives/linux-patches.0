Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD1D372B5E;
	Wed, 30 Sep 2026 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795723; cv=none; b=q647Naw0N60zC42SElKf8qkqA5BdzM4FZ99keESxDLGaVJ9QgmoS1zz5J3bwDWHx0MZZBaOYYaOVYAlwGDuiDP4mzW+tpZoXfMIeiw1PNC9lisk/0AcAoHmcTBQds1LfM2T96g2y0xk5e+nUEyN7I2Y85wCKy7D3b0n0loYPapw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795723; c=relaxed/simple;
	bh=zCX6fLjThTlwaLvCAWRJAewiVpcynXbYK/XwJy/ZULg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQn0GDcGD1CmFA7iwkQ5zEMWoYKARLUceDUYPRRpVSmpqWPBp9lLm9RnKQwkEg1TJt8DQdzzn1IUKRXp6jWZunqSCjlKxjkTSC8EGgGL8yci54DIqeQDobBDp1kDequVsppZuDoBoNurQCQercbaoHYKlXjWbFQPwMc52H+wltk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aB/qnDVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aB/qnDVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D031F000FF;
	Wed, 30 Sep 2026 19:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795722;
	bh=BXewf9IdmYdYHfMR5dEtQJj5Dp573YLoA7yl8tQD2SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aB/qnDVjsn3u94ORSiSeLK1KEWYSAwXAJeAn4uDQxypgN1SGZEVyfI3XkTCdWc4I1
	 hN0cSI72HQLQC6IBRpo9hk/No+tR7p0qYVeZUpTbIS/GHKxPlD948/9QaoLykBB/ZV
	 qgFZFZFMNgZr7DLSt5q/vYmgl6nfDu6DN68UTvAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0659/1193] mptcp: options: handle MPC data + csum reqd + no csum
Date: Wed, 30 Sep 2026 17:22:23 +0200
Message-ID: <20260930152448.880543934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit ab36b1a80942c78ddb04d006ff38aa7ed3ec0e5e upstream.

Before this modification, a remote peer could send an MP_CAPABLE with
data, with the checksum flag set, but without adding the actual 2 bytes
of checksum. As a result, uninitialised bytes could be used for the
'csum' field.

That was not a critical issue, because this 'csum' field is only used to
compare with the expected one, if previously negotiated in the 3WHS.
Worst case, the checksum is likely wrong, a fallback is done without a
reject if the negotiation was done earlier. That's OK.

Yet, better to take the expected path with this case: only look at the
checksum flag for MP_CAPABLEs not carrying a data-len.

Such packet can be seen as a 3rd or 4th ACK. The RFC8684 mentions [1]
that the 3rd packet should have the checksum flag set. When an MPC + ACK
contains data, the checksum flag is redundant with the checksum field.
It is not clear what should be done for the 4th ACK, nor if the flag has
to be set if the checksum field is set.

Therefore, it seems fine to only look at the presence of the checksum
field, not to break the interaction with stacks that were not setting
both.

Note that linked to this checksum flag on the 3rd ACK, with the current
implementation, we can have a situation where the SYN packets have no
checksum flag, but the 3rd ACK has one, and this is the one that will be
taken into account. First, that's clearly not directly linked to this
patch, but Clashiko forced us to look at that. At the end, that seems
fine to act like that: yes that's not how the negotiation should work,
but being flexible without introducing side effects is also fine: fixing
this would mean increasing the complexity, and that's not worth it.

Fixes: 208e8f66926c ("mptcp: receive checksum for MP_CAPABLE with data")
Cc: stable@vger.kernel.org
Link: https://datatracker.ietf.org/doc/html/rfc8684#section-3.1-23 [1]
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-0-b8f496d71664%40kernel.org?part=1
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-5-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -93,7 +93,8 @@ static void mptcp_parse_option(const str
 		 * In other words, the only way for checksums not to be used
 		 * is if both hosts in their SYNs set A=0."
 		 */
-		if (flags & MPTCP_CAP_CHECKSUM_REQD)
+		if ((flags & MPTCP_CAP_CHECKSUM_REQD) &&
+		    opsize < TCPOLEN_MPTCP_MPC_ACK_DATA)
 			mp_opt->suboptions |= OPTION_MPTCP_CSUMREQD;
 
 		mp_opt->deny_join_id0 = !!(flags & MPTCP_CAP_DENY_JOIN_ID0);


