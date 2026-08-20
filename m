Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB437B032;
	Thu, 20 Aug 2026 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238033; cv=none; b=fvryx0Zx7CCK1UI0uvoDo8QJhV2zuhtOTzVl2p/aexyHCeLqtE+TzfVdhIAS3TYJwwY0UBRpJv//j2njuo7vRuMT94kuE49FIYxRKcSbWXF8gimEc7pJYNWKxYpjQgG4qOqSCIr1ITNf3DvECN1WWXBZwjx3YtznoedaVMQlyRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238033; c=relaxed/simple;
	bh=ywvbGXfvD/q8Yd4ulElLWO5s1adPfZRI1k92DImFE3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aM7CHnvPCrrPg06zc13gHEn9a6zrJcKqK4nJwJlIDNei+MOXeFuNxeG/I1TGeVILqwTF2F+62DclcwPgBP/0Z2zSuxBYnOKjcNC07IZ0qwAOrVzjRTgkF/9oNhRxt45EeA0oEru9lzaHlknGV32zDXjBuU47jFEAmdGdCg1tzO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h643cSR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h643cSR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC81B1F00A3D;
	Thu, 20 Aug 2026 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238032;
	bh=H+5tz3NjIe3NuWaAP0VwflceuzJp4GhRh7cxb6EBAP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h643cSR8C2tbwhcF1AR1w14Ss2DT4CkAfBdY9hfIBYd3+cnupPefq8UmJWF1WwPFp
	 5YQeFhf8wdVsvcwwOvCzeT51kIvVP3ySkF2kekQpm8bYt1g6qlnBNX82/+wtqHdYpL
	 ZsMHkDcsIl/lwA7LdV6gscQMHvkq0dUiZdxWX5m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 010/228] mptcp: options: reset DSS fields in case of unexpected size
Date: Thu, 20 Aug 2026 16:52:32 +0200
Message-ID: <20260820145244.777981757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
@@ -209,8 +209,14 @@ static void mptcp_parse_option(const str
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


