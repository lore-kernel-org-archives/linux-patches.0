Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095082141AC;
	Tue, 12 Nov 2024 10:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407626; cv=none; b=Ltso4gpDbAStD7TO4npdXKg0lnIJXNR7P37TtgpUAGO2NqhTGPXkHa3B9HGsdJ4220CcZwgl3HGwtrV20Nly/mmVHvjx7/zUoOfCVqHONf4awCF8qubfXaoT6v+0ixmz7ecIXeRbT2mqRIEmFCp4kJzTWscwN9iMfBXhdJ/iJng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407626; c=relaxed/simple;
	bh=cWuwgj3Tq3k4aTNNQveMQ2OUBF8rqDE8MfQdwUl4uU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0s3pCpOKJt2UatIbt+KsHAH4+NBoYlpVD4ejdAiN1ekRcblpVsUMmTYkE8qWyq7x6dyNFKoyLzJaC8imMAgl2JE15x3V1mk9fqtGETiYnDf/9lGdmHpf3HdjUA5JCBTxAdnfTUAaYbixfeMiqeZquJLgBmEzov8Io1gz/7DG2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFTKMXZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFTKMXZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C603C4CED8;
	Tue, 12 Nov 2024 10:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407625;
	bh=cWuwgj3Tq3k4aTNNQveMQ2OUBF8rqDE8MfQdwUl4uU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFTKMXZ6xs8lRN8LEZ9/efEOMxkyp89Cd95964LcZTSsvveyx8tQiIAiB1tdRpU2s
	 qyaPqZaeLUaBbIvKcs7KVyhg464jmE6k3NbDQSdEDdteVqiqkL15nBCizkAXijlqiy
	 1McqQjrvFxUy/Wy2274ItNrZTnKbewOaRaBgg/pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f0cbb34d39392f2746ca@syzkaller.appspotmail.com,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/119] sctp: properly validate chunk size in sctp_sf_ootb()
Date: Tue, 12 Nov 2024 11:20:41 +0100
Message-ID: <20241112101849.978273515@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 0ead60804b64f5bd6999eec88e503c6a1a242d41 ]

A size validation fix similar to that in Commit 50619dbf8db7 ("sctp: add
size validation when walking chunks") is also required in sctp_sf_ootb()
to address a crash reported by syzbot:

  BUG: KMSAN: uninit-value in sctp_sf_ootb+0x7f5/0xce0 net/sctp/sm_statefuns.c:3712
  sctp_sf_ootb+0x7f5/0xce0 net/sctp/sm_statefuns.c:3712
  sctp_do_sm+0x181/0x93d0 net/sctp/sm_sideeffect.c:1166
  sctp_endpoint_bh_rcv+0xc38/0xf90 net/sctp/endpointola.c:407
  sctp_inq_push+0x2ef/0x380 net/sctp/inqueue.c:88
  sctp_rcv+0x3831/0x3b20 net/sctp/input.c:243
  sctp4_rcv+0x42/0x50 net/sctp/protocol.c:1159
  ip_protocol_deliver_rcu+0xb51/0x13d0 net/ipv4/ip_input.c:205
  ip_local_deliver_finish+0x336/0x500 net/ipv4/ip_input.c:233

Reported-by: syzbot+f0cbb34d39392f2746ca@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/a29ebb6d8b9f8affd0f9abb296faafafe10c17d8.1730223981.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 3649a4e1eb9de..808863e047e0c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3750,7 +3750,7 @@ enum sctp_disposition sctp_sf_ootb(struct net *net,
 		}
 
 		ch = (struct sctp_chunkhdr *)ch_end;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	if (ootb_shut_ack)
 		return sctp_sf_shut_8_4_5(net, ep, asoc, type, arg, commands);
-- 
2.43.0



