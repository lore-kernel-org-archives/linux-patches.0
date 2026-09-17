Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FE84ABBBA;
	Thu, 17 Sep 2026 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660518; cv=none; b=qq8sfY/55YXNNct42Z10i3t0l7+eCc0yDj0Cw3v8n7WQehappWTtcFL5HMKsKG4EaMNC5qbZVMNROzDsaxdu7qjmnwaWtNxDvKOihV1JfsPDa5qMNd/BCmbRFWv/Vy8XDXItMjTfMMI1hv+7vN/o6sMJsq8V4Ie5wf3YFjRT9xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660518; c=relaxed/simple;
	bh=Jd4VA2clDBgp+i9YMgO3w+FdHjVrqujM0ueV0BqS3JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlYGHzLHfHLMS3COonidPHG9J0XT/82ZHfxB2dEKwHlWI0h56hjP+HewOIp5EQX9UnGb+hZ63X8QMXUdhINVQnLSfjh7KRJW+kVHu2ENqiOIEWcnFJhrkLuiUHb6PxFczT7kcMWyWGDZ11sKpBO8ttuAbORUzRJ8gN/QBVOWhpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Skru3oBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Skru3oBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CAD1F000FF;
	Thu, 17 Sep 2026 15:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660516;
	bh=BhCOEzr+ZyfehwUa4E5+Fe1tk884eZELoZJ523+CBvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Skru3oBPqT3VPxIJ7dbAu2g9dalNGrx3/M0WL7cNieGJNZdR+QIEAn6KlszpE/7YL
	 lhJLyn9s3VZACrTTdsX7i8w3XmdVfwmHyWN4vbjucDNnTB44WkL2yz9bth+P/IR0yo
	 p1V3rkK6FWZPMqhUUp8N2nZUu8q87rg2BpfGXBRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 616/733] mptcp: options: fix uninit-value in mptcp_write_data_fin
Date: Thu, 17 Sep 2026 16:15:24 +0100
Message-ID: <20260917151407.864954798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit b110f1dd6cb6a9930503354a01a315e0a821eaa7 upstream.

When sending a DATA_FIN without data, and because the DATA_FIN occupies
1 octet of the connection-level sequence space [1], it is then required
to add a DSS mapping with specific values.

If the checksum has been negotiated, it also needs to be computed, and
included in the outgoing packet, and thus the initial csum data needs to
be reset to 0 as well. This is no longer the case since commit
cfcceb7a39fc ("tcp: shrink per-packet memset in __tcp_transmit_skb()"),
because the whole ext_copy structure is no longer zeroed by default.

This seems to be the only case where use_map is changed and set
afterwards, so initialising the csum field only in this case, along with
other fields for this specific case.

Fixes: cfcceb7a39fc ("tcp: shrink per-packet memset in __tcp_transmit_skb()")
Cc: stable@vger.kernel.org
Link: https://datatracker.ietf.org/doc/html/rfc8684#section-3.3.3 [1]
Link: https://sashiko.dev/#/patchset/20260812-net-next-mptcp-misc-feat-7-3-v1-0-1905a818f6cb%40kernel.org?part=2
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-13-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 196a46e7467d..ce0de02f5a3a 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -612,6 +612,7 @@ static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 		ext->data_seq = data_fin_tx_seq;
 		ext->subflow_seq = 0;
 		ext->data_len = 1;
+		ext->csum = 0;
 	} else if (ext->data_seq + ext->data_len == data_fin_tx_seq) {
 		/* If there's an existing DSS mapping and it is the
 		 * final mapping, DATA_FIN consumes 1 additional byte of
-- 
2.55.0



