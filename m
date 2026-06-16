Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCEA477E57;
	Tue, 16 Jun 2026 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631881; cv=none; b=hl986cWOjiGTaveyA2U3juRgsvLDD/gMSUB4w3pEsnTL66DS8XpPzJw53D7hHhaIoUf63X5I3dFISig0qi1dzwfAHklfIAQEUq8k3j96gSXUT1fJuoWneshszewmkrotxwCBCS0T3tFri4DwcLrfGl5A+CBt3Avy7ZpDuQp4VSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631881; c=relaxed/simple;
	bh=aBSoF3xVNtdr92G32w4ao0y0W7mm1HNio68qc3VHsGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5zAUq3CzVTF0Ru2qcPqVdQqW4wXyahGgSuoCLTRSPtbD7GwqDQJRa9Op6ro2nA60vWCKDJi/kPSOZ1NuhA3KwlZYyf3Bk6OunSP+cSbOK2N7bBPqvlMmgzn2NZGFOHS5fd94b1jXbaGYEwuA0PuwxZrKMzCKqyT4fnErH2TeDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fokWOVF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fokWOVF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42461F000E9;
	Tue, 16 Jun 2026 17:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631879;
	bh=IA8H7MMDqbCui7LYInnB39LYEhcJtd6D+UrH6xHu1t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fokWOVF5ixZDBRlQTvsdARvOB7xobkuVFfnCjE9oUG9sHX5jU+2iXXtalAw2PnnQx
	 rxpv6zVe14h2bshQsO6f/WQnNDz8z2XJI6KN51LAQL0hBW7oE+M97k7cUYDMm1xxS7
	 lDKkg8Ld/20S5g+ma+yA0lXdq1yzJaXARlVEnnWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 285/522] mptcp: fix retransmission loop when csum is enabled
Date: Tue, 16 Jun 2026 20:27:12 +0530
Message-ID: <20260616145139.277181300@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit d1918b36edcaed0ec4ef6888b2358c6b1ddcff47 upstream.

Sashiko noted that retransmission with csum enabled can actually
transmit new data, but currently the relevant code does not update
accordingly snd_nxt.

The may cause incoming ack drop and an endless retransmission loop.

Address the issue incrementing snd_nxt as needed.

Fixes: 4e14867d5e91 ("mptcp: tune re-injections for csum enabled mode")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-2-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2752,6 +2752,10 @@ static void __mptcp_retrans(struct sock
 
 	release_sock(ssk);
 
+	/* With csum enabled retransmission can send new data. */
+	if (after64(dfrag->already_sent + dfrag->data_seq, msk->snd_nxt))
+		WRITE_ONCE(msk->snd_nxt, dfrag->already_sent + dfrag->data_seq);
+
 reset_timer:
 	mptcp_check_and_set_pending(sk);
 


