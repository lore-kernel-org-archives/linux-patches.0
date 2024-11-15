Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1B9188A18;
	Fri, 15 Nov 2024 06:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653055; cv=none; b=KyGoq3Kp1pIdZvjfHevHo+po7WoVf9HEAhtweMZYD35xfY2lfqMRo+w3S2N8iNzXObrWmMAe9jrCcQlkCTVNIzJ/RlOsCqX/sMk/qJhOjQ6fBVWsosCbNvD/9gq0UD3ucd+oYGkDC7EvjMhe38KNkfuLEH/EWMfFuQ5PcJ/ZXco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653055; c=relaxed/simple;
	bh=5RmG8YwQN25fGfdsFIESKorNL/a6Demz+sJPUFbGkJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M62DknLInPuy6zDZaF5EH5TNPOD79yWaxKpBR/RGD5v5l0czSuagzSDD+8PwOWFr2zIjnBetNodxNyPzXm3QWQ0+CrfKVD77o0OyDjZ5VPe2dJ2uaulZuRNxG38djVYYMFR5MvTguBtWtfruMVJC8Nyi1TVyO21HVCkFd29JkrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfjiuD3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfjiuD3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8421AC4CED0;
	Fri, 15 Nov 2024 06:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653055;
	bh=5RmG8YwQN25fGfdsFIESKorNL/a6Demz+sJPUFbGkJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfjiuD3tDDwVajmQ+MWbQQsn2x/8sapmj6+9izmCujPMIk7veuHC6U70+j431pitH
	 SdhFBQ453ditad80IC8lJbndcJvP+/bNtNEKrPCuq9fzGJekz/ZQinbhMvc4PzZuPM
	 JEPU3AxUIL/FTTNdb1XeLb7oSnZQWnkN878cboi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f0cbb34d39392f2746ca@syzkaller.appspotmail.com,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/66] sctp: properly validate chunk size in sctp_sf_ootb()
Date: Fri, 15 Nov 2024 07:37:22 +0100
Message-ID: <20241115063723.321937404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 67df4022853ba..6b613569372a0 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3637,7 +3637,7 @@ enum sctp_disposition sctp_sf_ootb(struct net *net,
 		}
 
 		ch = (struct sctp_chunkhdr *)ch_end;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	if (ootb_shut_ack)
 		return sctp_sf_shut_8_4_5(net, ep, asoc, type, arg, commands);
-- 
2.43.0



