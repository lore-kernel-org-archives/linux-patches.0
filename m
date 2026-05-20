Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A133DF59;
	Wed, 20 May 2026 18:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302068; cv=none; b=KSNeStBdKj+9dGxXUU4nn92qbMs1d4S5hhwZyOj9RPjqyVrJOU6j+a3h3QeXEAjEkaNjL+eg0hgR28mUPzQjlSdt+xdvi2A5yYFWFPtj2Xe6abrbvpnns8wQXEV/iIAkpCTsiKzaD3WRULFcK453EJ+Vxrlz4U+tUjRT5vYRgAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302068; c=relaxed/simple;
	bh=U1Uxj5FZtaOtS+qwUCvL/MS5nRNUGnLxG9gQ1Vyja8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+Ea36jQm/B38UNr5Bbn4fhfaINmpznQS7EyYNF9s6OP5ppZd8t6T/wAHi61stNDTlCqRNIlasXIqJPH1PYbwG5ALJ60X8lxZhlCOaNlVbZ2kdkxxFqZZH1u1idi2vCpL6s5VFT9z7Ha9c8z70bg9yfwyD5uzHbw0lxZ/D4y1cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INWCfKvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INWCfKvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844961F00893;
	Wed, 20 May 2026 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302067;
	bh=I2qRDacTl8wLOawBPhN/OYnnPIJFrs3uqdNCF3oTZrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INWCfKvotTW/PDc0FA3wJE5mo/VpcE351kHiXreePvEGjWZLM5ufDG54qyIl+wrrt
	 G1w3k45iv8YAbTDEGnhwGCKHUTWcHQAUoe4IV8eHFVyLWOH3Dl5Ht8j5LMhjWAMGkf
	 BgWCIV41Fm1SdBYIfRm/oxLKVwNbOuR/Qzo3qxrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/508] sctp: fix missing encap_port propagation for GSO fragments
Date: Wed, 20 May 2026 18:18:28 +0200
Message-ID: <20260520162100.451752639@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit bf6f95ae3b8b2638c0e1d6d802d50983ce5d0f45 ]

encap_port in SCTP_INPUT_CB(skb) is used by sctp_vtag_verify() for
SCTP-over-UDP processing. In the GSO case, it is only set on the head
skb, while fragment skbs leave it 0.

This results in fragment skbs seeing encap_port == 0, breaking
SCTP-over-UDP connections.

Fix it by propagating encap_port from the head skb cb when initializing
fragment skbs in sctp_inq_pop().

Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/ea65ed61b3598d8b4940f0170b9aa1762307e6c3.1776017631.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/inqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index f5a7d5a387555..a024c08432471 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -201,6 +201,7 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
 
 			cb->chunk = head_cb->chunk;
 			cb->af = head_cb->af;
+			cb->encap_port = head_cb->encap_port;
 		}
 	}
 
-- 
2.53.0



