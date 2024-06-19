Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EEA12FB31;
	Wed, 19 Jun 2024 13:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802456; cv=none; b=TYalX75EIbcer5hFR97fda7YPHaWvHeAYzzqOUe9cto6ueZYUZdSia/qJd3Sqnwq1W4xAmTz7RdUKZ1tN0J2WXsIqHVy7Dc0hqzoETCFbdFlR4+elMaAsF6OZstiQv5rCtxhlW2NSg8M4eeE7dp/Adb1CDEpLxFhgcAMGzxygME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802456; c=relaxed/simple;
	bh=yQc88MsKZKWTydGpELv+NDZRg4Mzbdr18yUlzvz4qTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFDmLVeBjmktp3sgAyh1hrdG5hgpIEsjv9nu1y1HSWXHnoDwIPxM0B90NdIdEnTCLMgwf3KoK46tzNpk5jb+al8kV8E1+3d6oaq6fVnkUMYOyt2MKhZebbP6V3EmXdxfD2NGe36yb0SvC9S7cYNR1ccgr9eMIMXn2EGgSz4nJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMcWXl+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMcWXl+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1BDC2BBFC;
	Wed, 19 Jun 2024 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802456;
	bh=yQc88MsKZKWTydGpELv+NDZRg4Mzbdr18yUlzvz4qTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMcWXl+ridqeS2514HmSMV2Ij3bXkMIcf+D2AbZG/NZMu8eJm86+al+8CIIrzXVjs
	 UUjXYSOHzmRCStVbRtfuZOpvbJwXWJkgbmHVjR8IHNCcttaStfbCF/KzLIWNBtiXIT
	 wLJ6DTPcgrZQFWqcwAdsgsdF3F60mqu0FbGun2jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 185/267] mptcp: ensure snd_una is properly initialized on connect
Date: Wed, 19 Jun 2024 14:55:36 +0200
Message-ID: <20240619125613.444159669@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 8031b58c3a9b1db3ef68b3bd749fbee2e1e1aaa3 upstream.

This is strictly related to commit fb7a0d334894 ("mptcp: ensure snd_nxt
is properly initialized on connect"). It turns out that syzkaller can
trigger the retransmit after fallback and before processing any other
incoming packet - so that snd_una is still left uninitialized.

Address the issue explicitly initializing snd_una together with snd_nxt
and write_seq.

Suggested-by: Mat Martineau <martineau@kernel.org>
Fixes: 8fd738049ac3 ("mptcp: fallback in case of simultaneous connect")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/485
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240607-upstream-net-20240607-misc-fixes-v1-1-1ab9ddfa3d00@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3706,6 +3706,7 @@ static int mptcp_connect(struct sock *sk
 
 	WRITE_ONCE(msk->write_seq, subflow->idsn);
 	WRITE_ONCE(msk->snd_nxt, subflow->idsn);
+	WRITE_ONCE(msk->snd_una, subflow->idsn);
 	if (likely(!__mptcp_check_fallback(msk)))
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEACTIVE);
 


