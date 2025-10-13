Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B60530DD2A;
	Mon, 13 Oct 2025 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369987; cv=none; b=saoVVpOLFR/bfsJP6i93YROrmySSwOzeuXIPovpsnTg9B1r9/ixOav8HRQlC185sMeK87Y8jsI3pcQ57ay3K3syJcZASpSQ/uy+H23lQ3R2cI9UM+wUipg7vwXw0mmaIGAXbv9CIbNXpAmWGzPTtJHpk1fWRdezB/IEN8Z6dg4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369987; c=relaxed/simple;
	bh=8rmKOmo5WcIEYD7s3MluxSpq7sg0G9embvmyOj9Ugxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwapywO1vzLyldRFt3t0Z21biMIXEe8jtxvKOfbit4sYum/6zjV/jgiGRI5ubipSfTkZCPrzj6La7DALrdAW4GRchYmml/LjMrYnH3fxQ1DUjmKBDDHQLYNelDcz2SWFyU7LCwMAxLm0W4g5gHX+d0VW/GV16KoPHT6jIrLn9J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ucl6YnTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ucl6YnTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB719C4CEE7;
	Mon, 13 Oct 2025 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369987;
	bh=8rmKOmo5WcIEYD7s3MluxSpq7sg0G9embvmyOj9Ugxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ucl6YnTSFhEUeQ+Pc6uro69jVp7h3iL75sYftqzZcOCVMBTHKMjKrJ5O6RtNRVLTO
	 /0VZd9tZv3kzb83k4GfRmv76uWM7mIvVK2mNhunpJs9cS8iA7Og/zfwnpxZENqho0o
	 ZnIkV8P/VdHTORYiaLv7tSxGWUvlVMRka+ub66V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 438/563] netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack
Date: Mon, 13 Oct 2025 16:44:59 +0200
Message-ID: <20251013144427.150961155@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c5ba345b2d358b07cc4f07253ba1ada73e77d586 ]

ct_seq_show() has an opportunistic garbage collector :

if (nf_ct_should_gc(ct)) {
    nf_ct_kill(ct);
    goto release;
}

So if one nf_conn is killed there, next time ct_get_next() runs,
we skip the following item in the bucket, even if it should have
been displayed if gc did not take place.

We can decrement st->skip_elems to tell ct_get_next() one of the items
was removed from the chain.

Fixes: 58e207e4983d ("netfilter: evict stale entries when user reads /proc/net/nf_conntrack")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_standalone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 1f14ef0436c65..708b79380f047 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -317,6 +317,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	smp_acquire__after_ctrl_dep();
 
 	if (nf_ct_should_gc(ct)) {
+		struct ct_iter_state *st = s->private;
+
+		st->skip_elems--;
 		nf_ct_kill(ct);
 		goto release;
 	}
-- 
2.51.0



