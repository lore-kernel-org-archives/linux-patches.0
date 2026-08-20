Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B926272E53;
	Thu, 20 Aug 2026 16:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243992; cv=none; b=hFGpqRVxGWAkXhR9HvHywytn6kMU0YIPDfIT0beFn8i/9Og5oywz7FLPaz0b3/bewBv1kaoiNN2sJkudXpblRgD8epKap384piBGv4NhXuqCNS3sxesp5lBGJxQaO5udV1PXpssy9bFrxGQL9Hhy/6+ZwN6vLv4MXg5Nhq9Buhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243992; c=relaxed/simple;
	bh=ExBlJ1785x0McshocJvlAXbm7BSgfjCLBsHSIxfy0/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOWVKn4UObgSpG66WNvT8ZP+a5FyVWPiI/xpV8LrBOX1/6OH72z7Bv7H9/nwVf3idtPK1pQGeFnB0M4buKDovhTZ1oR1a+XQhTW9JzrzMyXWRGJC4huRfU07WIQQB448VW0Upy5TZ4wblOyLrAF99AsjocQlYBtDXD3d2dQNVi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IX0BxeuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IX0BxeuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A271F000E9;
	Thu, 20 Aug 2026 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243991;
	bh=U16HTuxwEf7c2kdFJ5VQxCFbKB2igvPLn6YKgx8SkNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IX0BxeuDsHywDDz12F/3ERCGbqZDqs3EOMhouQ+nNoGODZvwJYITXm86/M8DBaeM6
	 4r5rwdd/sdR6O6kWCw7xHcB67ecKXBqnLwH67A4Q/tS+KXj+4OckpY2FPPh5GDbevp
	 OlT0KMDTSD48aMlMh6YzeScmJXOFlh93x4mtxm+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 007/235] mptcp: options: reset DSS fields in case of unexpected size
Date: Thu, 20 Aug 2026 16:54:03 +0200
Message-ID: <20260820145216.664384838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -175,8 +175,14 @@ static void mptcp_parse_option(const str
 		 * the checksum field MUST be ignored.
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
 
 		mp_opt->dss = 1;
 


