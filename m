Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3183D3F0A86;
	Mon, 17 Aug 2026 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979498; cv=none; b=aBQq77k9DCZQNdDqEh70qVHLVbsMP/JWDBBoztU4u5d+xZ1M9nUTN69XxJSIcJGJfQRwUT26Z1NvNb9NqUIDpHr0OQEAU3At6lNQXBSgpI8aoafP5r6oP6dy4Diuh2R7CoJ8zYB4gpTbPhXsVeU+dWulSe/4K2HssRRQly+dR/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979498; c=relaxed/simple;
	bh=STAYc2mwUhn6VXLMF6socgi8WPNFwGIH+4CLYfxjrRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L95H2zEEfqkiCZqJPV58jpv3Knx/ZC3a6dc/3igbZZO7NbI0weJC7l8YAedPywFXXD4y6lsNraWOvaL7J8yfp+sSqOfx2diw+2LcCpJIHhTfNao+WL7LacwA/mmwz9wY1peZtrvirDNRKzKT6jJ0/wUbGq+eoKsnnflrvl2Gf3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcImssP+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcImssP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403961F000E9;
	Mon, 17 Aug 2026 15:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979496;
	bh=oUqUsroRpNi0ZLb+wpZaQHyXsVD5p/yuw59h7z9D5uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcImssP+68an8mO1YhQg+0gMIK5uYKON2Lf7+59w+TFpgT8XcSmZk7xRjWpPDHU6+
	 NB7jeZ+7Y4cvW6C6IBE3dt2Bwb1TwhQ0LBk2rQ4ebrqfm17rw+FSnQKNw9YeLkg14z
	 J45/i3Y/IUVhYHauThCToaY80u3eTR0yfWnj1nvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 247/609] mptcp: only set DATA_FIN when a mapping is present
Date: Mon, 17 Aug 2026 15:29:03 +0200
Message-ID: <20260817132552.351435459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit b2ff91b752b0d85e8815e7f44fd85205c4268094 upstream.

mptcp_get_options() clears only the status group of struct
mptcp_options_received; data_seq, subflow_seq and data_len are filled in
by mptcp_parse_option() exclusively inside the DSS mapping block, which
runs only when the DSS M (mapping present) bit is set.

A peer can send a DSS option with the DATA_FIN flag set but the mapping
bit clear. The parser then records mp_opt->data_fin while leaving
data_len and data_seq uninitialized. For a zero-length segment
mptcp_incoming_options() evaluates

	if (mp_opt.data_fin && mp_opt.data_len == 1 &&
	    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq, mp_opt.dsn64))

which reads the uninitialized data_len and data_seq; KMSAN reports an
uninit-value in mptcp_incoming_options(). The stale data_seq can also be
fed into the receive-side DATA_FIN sequence tracking.

Record the DATA_FIN flag only when the DSS option carries a mapping, so
data_fin is never set without data_seq and data_len also being present.
data_fin is part of the status group that mptcp_get_options() clears up
front, so on the no-map path it stays zero and the zero-length DATA_FIN
branch is simply skipped. A DATA_FIN is always transmitted together with
a mapping (mptcp_write_data_fin() sets use_map along with data_seq and
data_len), so legitimate DATA_FIN handling is unaffected.

Move the pr_debug() that logs the parsed DSS flags below the mapping
block, so it reports the final data_fin value instead of the stale one
it would otherwise print before the assignment.

Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260709191925.2811195-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -152,17 +152,11 @@ static void mptcp_parse_option(const str
 		ptr++;
 
 		flags = (*ptr++) & MPTCP_DSS_FLAG_MASK;
-		mp_opt->data_fin = (flags & MPTCP_DSS_DATA_FIN) != 0;
 		mp_opt->dsn64 = (flags & MPTCP_DSS_DSN64) != 0;
 		mp_opt->use_map = (flags & MPTCP_DSS_HAS_MAP) != 0;
 		mp_opt->ack64 = (flags & MPTCP_DSS_ACK64) != 0;
 		mp_opt->use_ack = (flags & MPTCP_DSS_HAS_ACK);
 
-		pr_debug("data_fin=%d dsn64=%d use_map=%d ack64=%d use_ack=%d\n",
-			 mp_opt->data_fin, mp_opt->dsn64,
-			 mp_opt->use_map, mp_opt->ack64,
-			 mp_opt->use_ack);
-
 		expected_opsize = TCPOLEN_MPTCP_DSS_BASE;
 
 		if (mp_opt->use_ack) {
@@ -173,12 +167,18 @@ static void mptcp_parse_option(const str
 		}
 
 		if (mp_opt->use_map) {
+			mp_opt->data_fin = (flags & MPTCP_DSS_DATA_FIN) != 0;
 			if (mp_opt->dsn64)
 				expected_opsize += TCPOLEN_MPTCP_DSS_MAP64;
 			else
 				expected_opsize += TCPOLEN_MPTCP_DSS_MAP32;
 		}
 
+		pr_debug("data_fin=%d dsn64=%d use_map=%d ack64=%d use_ack=%d\n",
+			 mp_opt->data_fin, mp_opt->dsn64,
+			 mp_opt->use_map, mp_opt->ack64,
+			 mp_opt->use_ack);
+
 		/* Always parse any csum presence combination, we will enforce
 		 * RFC 8684 Section 3.3.0 checks later in subflow_data_ready
 		 */


