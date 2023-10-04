Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613B81D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGUjjpnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BA1C433C8;
	Wed,  4 Oct 2023 18:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443608;
	bh=dLqSnKyXXc4x0M6ayJ4x1qhVW/mVr81Hfgb2yi6Rg48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGUjjpnBUrXyKtgt4/OtkkKs/WxbpeNJBytAC5Yt/cxv1EVmlcw3Bu+jFhiAAi4HL
	 r1Ic7R6yXDKnZ7pgLkn9k3AmCuoENcmBwwo7XzrOiTFecGAZYkbMWmvEMTnVw3s7EA
	 dFww5uPFBGfhucgkbvIaFgV1EOnIHZcxunEap/mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 215/259] mptcp: fix bogus receive window shrinkage with multiple subflows
Date: Wed,  4 Oct 2023 19:56:28 +0200
Message-ID: <20231004175227.189337069@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 6bec041147a2a64a490d1f813e8a004443061b38 upstream.

In case multiple subflows race to update the mptcp-level receive
window, the subflow losing the race should use the window value
provided by the "winning" subflow to update it's own tcp-level
rcv_wnd.

To such goal, the current code bogusly uses the mptcp-level rcv_wnd
value as observed before the update attempt. On unlucky circumstances
that may lead to TCP-level window shrinkage, and stall the other end.

Address the issue feeding to the rcv wnd update the correct value.

Fixes: f3589be0c420 ("mptcp: never shrink offered window")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/427
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1248,12 +1248,13 @@ static void mptcp_set_rwin(struct tcp_so
 
 			if (rcv_wnd == rcv_wnd_old)
 				break;
-			if (before64(rcv_wnd_new, rcv_wnd)) {
+
+			rcv_wnd_old = rcv_wnd;
+			if (before64(rcv_wnd_new, rcv_wnd_old)) {
 				MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDCONFLICTUPDATE);
 				goto raise_win;
 			}
 			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDCONFLICT);
-			rcv_wnd_old = rcv_wnd;
 		}
 		return;
 	}


