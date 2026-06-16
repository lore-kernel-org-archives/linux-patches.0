Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CF3449EAB;
	Tue, 16 Jun 2026 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623897; cv=none; b=PbusA/JlkCJt0kTU7VCoav7JyPKMiBO1YWV3k0rQ+DyTRamcQXGA5RPYByU8udhVyy9h0SvVMlLPjlhfltpUokSe1+ZKN8A2R5tMqAVjpnffbym5rLFvSa40uPesKzVOHbSgmToIOF9GI8iCmu1C4MrFqRtO7dxAx4b0ce5bKo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623897; c=relaxed/simple;
	bh=yUV+HHTO8Rseyr7Tr777DfFKIJc926VZs8EYkfv74u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ki/Yf/ZRM4gfTJMIoiyKQ3M+3ke5I69Jry1jHrTpcyTRyYx530pSWvjS8g9u+fY9fiVzwxOUyJu4+llW2UyX04AsSbhq90RPif3pgGwQkSCjCoYmRWqpbc4mdhpba60naFwo9w60PiK3++FzW10hY3SMn9T9rEfQ3RqTfBUCyts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k72VoVJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k72VoVJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F191F000E9;
	Tue, 16 Jun 2026 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623896;
	bh=BR9mM1k+GrbSjfTYaJqUEAxtiBUYb6JxF822Bao7vG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k72VoVJYtL358niKVA8X1CGQ6wGDJELnveGAPS55PP+ELhp7qdNjShsEUNUD/ji0d
	 SorMUDp2VQBh+d6zC2cmMcv1hyA0vvZXx4PbYtlt7LKktmVpVWOn0mQxOMYCK+rUCU
	 keWy3E/g/DNTOIJUL+2+x9BPqfa6H5Fna+IM0vEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 237/378] mptcp: sockopt: set sockopt on all subflows
Date: Tue, 16 Jun 2026 20:27:48 +0530
Message-ID: <20260616145122.710509630@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 7690137e70ab0fb1f8b5a30e6f087f8ee908b680 upstream.

The mptcp_setsockopt_all_sf(), currently used only with TCP_MAXSEG,
stopped when one subflow returned an error.

Even if it is not wrong, this is different from the other helpers trying
to set the option on all subflows, and then returning an error if at
least one of them had an issue.

Follow this behaviour, for a question of uniformity.

Fixes: 51c5fd09e1b4 ("mptcp: add TCP_MAXSEG sockopt support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-8-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -811,10 +811,11 @@ static int mptcp_setsockopt_all_sf(struc
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int err;
 
-		ret = tcp_setsockopt(ssk, level, optname, optval, optlen);
-		if (ret)
-			break;
+		err = tcp_setsockopt(ssk, level, optname, optval, optlen);
+		if (err < 0 && ret == 0)
+			ret = err;
 	}
 
 	if (!ret)


