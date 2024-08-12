Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C0E1494B8;
	Mon, 12 Aug 2024 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480613; cv=none; b=rqUB1oGZ2LyOBhIzpfO4dPbAYb0xpFLu/gKrR5ww/LP3bY4KSDzj7UyqAJMGNt70jJrThYGdJmCqXxPnA8OpKiNnkAANFv+xUDnKbz3kB5cTGDK4pgtxMivjJN76Cn7Ue7rYWeXvEMyJzeqAOENpy3OBKtmhr3EI5DepBrbGtuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480613; c=relaxed/simple;
	bh=RF9tHJV2k9SkjN2JhZSQ/iqYGbUsvBMOAI1Fmkzpe2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1/JyeKE3nRH7estNruV/UhlYu3cIRZMa1igplHiojFEPIhu4xpG6HuFSfztsu2vtGC9zJ7YTXdZRpV0QzMzX+kh7jss6C+TzNDA+IOkZXhaE9FfFO78w+PKaF3oRbuFrXjkLYfu6bncwC4XJEYl4MccdoB9/3aUs1A14WOv8To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHdTf0vA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHdTf0vA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C43C32782;
	Mon, 12 Aug 2024 16:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480613;
	bh=RF9tHJV2k9SkjN2JhZSQ/iqYGbUsvBMOAI1Fmkzpe2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHdTf0vANcvtT/lj/tFIlk+iA6eIdIeYz5ojvlFtWNtbvwLbJeJAww9C6RzFpj/pL
	 PCZ68XTOIfkjPd6/SoELnYqyXny2YfH/Lm6lG4lG9wwBs98sL3zdzIaN676Igd8Xy7
	 3dgIvvfxrE7Xsj/zlRUuJ3HT3HlnwwEwF4Ht3EMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 248/263] mptcp: fully established after ADD_ADDR echo on MPJ
Date: Mon, 12 Aug 2024 18:04:09 +0200
Message-ID: <20240812160156.039625391@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit d67c5649c1541dc93f202eeffc6f49220a4ed71d upstream.

Before this patch, receiving an ADD_ADDR echo on the just connected
MP_JOIN subflow -- initiator side, after the MP_JOIN 3WHS -- was
resulting in an MP_RESET. That's because only ACKs with a DSS or
ADD_ADDRs without the echo bit were allowed.

Not allowing the ADD_ADDR echo after an MP_CAPABLE 3WHS makes sense, as
we are not supposed to send an ADD_ADDR before because it requires to be
in full established mode first. For the MP_JOIN 3WHS, that's different:
the ADD_ADDR can be sent on a previous subflow, and the ADD_ADDR echo
can be received on the recently created one. The other peer will already
be in fully established, so it is allowed to send that.

We can then relax the conditions here to accept the ADD_ADDR echo for
MPJ subflows.

Fixes: 67b12f792d5e ("mptcp: full fully established support after ADD_ADDR")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240731-upstream-net-20240731-mptcp-endp-subflow-signal-v1-1-c8a9b036493b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -958,7 +958,8 @@ static bool check_fully_established(stru
 
 	if (subflow->remote_key_valid &&
 	    (((mp_opt->suboptions & OPTION_MPTCP_DSS) && mp_opt->use_ack) ||
-	     ((mp_opt->suboptions & OPTION_MPTCP_ADD_ADDR) && !mp_opt->echo))) {
+	     ((mp_opt->suboptions & OPTION_MPTCP_ADD_ADDR) &&
+	      (!mp_opt->echo || subflow->mp_join)))) {
 		/* subflows are fully established as soon as we get any
 		 * additional ack, including ADD_ADDR.
 		 */


