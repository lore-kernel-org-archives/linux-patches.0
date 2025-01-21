Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3838C1F5404;
	Tue, 21 Jan 2025 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482446; cv=none; b=cKLlDHD3M32YIu7aSKePHekGXnti/5qbNzm4305t3/2KmLRxSu+TBE2MdgHYVK1DBZweZ8ZfAog12KGw0mPJx/1NG8mXx5C2+riL1T9/3ZF/QBPXzCd3/cdf5XfhTp7Y4pbk598TP7g9ld2FBl1lTDbgOS3zOqVWg2Z0xfScjXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482446; c=relaxed/simple;
	bh=w795/pLBuCiK3GV9JSaW8mk2ULbW39xhHYYOQ9ohT8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAvplD0RtFSwKxPpibT9WlkFSnSRnHyj0v4I2UIAfA6lzdtD5GnBZkBBgrSG5Or79tUwubsiTvUNmV7T86+9Yo00X4pXKbo88+dTCW8YY5znUMmdBqia5HOgwYzhiUUARPxBoE95m4BidPb386nfvtiYznndZRbzlXtl5kmYwug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRV02tea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRV02tea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B172AC4CEE0;
	Tue, 21 Jan 2025 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482446;
	bh=w795/pLBuCiK3GV9JSaW8mk2ULbW39xhHYYOQ9ohT8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRV02teaSJ24DRDec+K4KCRLPT8W4k3NvjBVmAQpdXScjyCQUaStBS8Ht9sR2YoxS
	 jgHfUXvjYDJCPcFHrY9wDUlMskXSYeDn7452qSXUC4cUBV2ip2QRNQFSc09W4m3M8b
	 CHIWMdObzv8QPkpTkUVdnRh4gruz2W0HNaKVA5i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.12 080/122] mptcp: be sure to send ack when mptcp-level window re-opens
Date: Tue, 21 Jan 2025 18:52:08 +0100
Message-ID: <20250121174536.096130717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 2ca06a2f65310aeef30bb69b7405437a14766e4d upstream.

mptcp_cleanup_rbuf() is responsible to send acks when the user-space
reads enough data to update the receive windows significantly.

It tries hard to avoid acquiring the subflow sockets locks by checking
conditions similar to the ones implemented at the TCP level.

To avoid too much code duplication - the MPTCP protocol can't reuse the
TCP helpers as part of the relevant status is maintained into the msk
socket - and multiple costly window size computation, mptcp_cleanup_rbuf
uses a rough estimate for the most recently advertised window size:
the MPTCP receive free space, as recorded as at last-ack time.

Unfortunately the above does not allow mptcp_cleanup_rbuf() to detect
a zero to non-zero win change in some corner cases, skipping the
tcp_cleanup_rbuf call and leaving the peer stuck.

After commit ea66758c1795 ("tcp: allow MPTCP to update the announced
window"), MPTCP has actually cheap access to the announced window value.
Use it in mptcp_cleanup_rbuf() for a more accurate ack generation.

Fixes: e3859603ba13 ("mptcp: better msk receive window updates")
Cc: stable@vger.kernel.org
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/20250107131845.5e5de3c5@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250113-net-mptcp-connect-st-flakes-v1-1-0d986ee7b1b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -607,7 +607,6 @@ static bool mptcp_established_options_ds
 	}
 	opts->ext_copy.use_ack = 1;
 	opts->suboptions = OPTION_MPTCP_DSS;
-	WRITE_ONCE(msk->old_wspace, __mptcp_space((struct sock *)msk));
 
 	/* Add kind/length/subtype/flag overhead if mapping is not populated */
 	if (dss_size == 0)
@@ -1288,7 +1287,7 @@ static void mptcp_set_rwin(struct tcp_so
 			}
 			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDCONFLICT);
 		}
-		return;
+		goto update_wspace;
 	}
 
 	if (rcv_wnd_new != rcv_wnd_old) {
@@ -1313,6 +1312,9 @@ raise_win:
 		th->window = htons(new_win);
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDSHARED);
 	}
+
+update_wspace:
+	WRITE_ONCE(msk->old_wspace, tp->rcv_wnd);
 }
 
 __sum16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)


