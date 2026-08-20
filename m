Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51EE37DE9B;
	Thu, 20 Aug 2026 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247821; cv=none; b=irUuASAxgpzhj0Pm2pGbI+DNsWZaWJQtj8ujnx0IL7xQzGS23P3vZy6XepRlAmoP99T7m/ipR6Q05xPnNgl/hfRCQ8JPQ5ZlmlJYLBb9WklHyrqdmyxcmV53G9rhdHuOayRmsVPcEL+cHhobMaPybiVjFJFZqFnwWfOkCHjKi1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247821; c=relaxed/simple;
	bh=RSVBGxavIAJlEC6sjcJVqvWxcBzIQ2Vm8FDw5IJo+ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkGrvClo/Y7LFRXycA8qVXebnlFJcfyoaqR8qoLFL/cNRCyxyiLL0Qmgpv1+ugPpOx1gyJOtHsw/bpYiDKxGwio2ddP6+20CT/a5XFD9oMUQfOWmGyARgEv9oOZaIdUAtdo35ciWpIi+mO5YvAP+uNu1oHzI7sP4SbfRlU2wBmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEn7YuIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEn7YuIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2FD1F000E9;
	Thu, 20 Aug 2026 17:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247820;
	bh=drDDo4G73hho8i65qGUFZzqEUA77wnIcQ/oEPAQ/z4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEn7YuIyIT3XlH7LgEMMkKLpO9WK5HhflaLpn2D67lRH3Bhmp4OoEWne+P/D9e1tm
	 Q4+NHlCBQUhv7ASkEMfan8kOigeFGpePxzIOWdNC/GxPcY4IxzHWRE9Gb2KF/JM4fq
	 dVzHUXvxZGZdfChMqHlkiK+/FEDDGx2TT2aOyI9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 014/303] mptcp: options: reset DSS fields in case of unexpected size
Date: Thu, 20 Aug 2026 16:52:30 +0200
Message-ID: <20260820145253.617192870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 35772b4981f38ba8059372cde8753e8e477e98ec upstream.

A remote peer could send a malformed DSS with a wrong size, followed by
another DSS or MPC + Data. In this case, the first suboption will be
ignored, but leaving some fields written, which could lead to
inconsistency or access uninitialized data.

Explicitly reset the fields that could have been modified in case of
unexpected size.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260728-net-mptcp-misc-fixes-7-2-rc6-v1-0-f7e2d229159d%40kernel.org?part=1
Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-1-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -183,8 +183,14 @@ static void mptcp_parse_option(const str
 		 * RFC 8684 Section 3.3.0 checks later in subflow_data_ready
 		 */
 		if (opsize != expected_opsize &&
-		    opsize != expected_opsize + TCPOLEN_MPTCP_DSS_CHECKSUM)
+		    opsize != expected_opsize + TCPOLEN_MPTCP_DSS_CHECKSUM) {
+			mp_opt->dsn64 = 0;
+			mp_opt->use_map = 0;
+			mp_opt->ack64 = 0;
+			mp_opt->use_ack = 0;
+			mp_opt->data_fin = 0;
 			break;
+		}
 
 		mp_opt->suboptions |= OPTION_MPTCP_DSS;
 		if (mp_opt->use_ack) {


