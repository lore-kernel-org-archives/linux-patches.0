Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC98420472;
	Mon, 17 Aug 2026 14:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977586; cv=none; b=NaYgf/wd+x3rGGPG9dHmSJ/zEVKVGoOXBMM2llrSLP+JIODPoNq2VTpzApbLoVPyZ7efknP0j4ETkl+OSUZkHGs5ivPT6IUKyIHuFgGRCjofTjCA1ALnjbLthpnikoPI84e2vOKSJb9pSZnp/Uxvd2zsPD+LPA+H6QUMNokcvlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977586; c=relaxed/simple;
	bh=1ap6hs7L5AlVTgadpuNkST29W1JrBPzyxe10+z5syS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g+TYnyFGMGv8GhmFwCNMm5P8sAHghLOUhGtv/tWvJN9UJu0IVV9oOCmB2pbSjIJ6snkLsoZ+NXRwMPbRgsyUll5Qk1sitR8iglFUYDSwESCfU6DDtcubnYybcTF+Vd/QIShx4hKZyRtk6yJIog0/Ks/wsO/uusqUj6RLHV4Fr+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzzNaLtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzzNaLtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA51B1F000E9;
	Mon, 17 Aug 2026 14:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977585;
	bh=XkEVfQpZsJlbyFg5vnDYPwBSmrsFsePlpALGYp7prJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzzNaLtHtMzW352tjVNL0uxPlaiXmPeC86OwMzh1IHgNcKVK/vPD9Ml6NLXUO/tW5
	 9C6JlprPerjFCuvo4ni/waObL11NpGtVGvhTmknS+qn9aIJZJPHJOe+6eNt9WHRcT/
	 NCqP8CRPsod7Ngb1AwWVtmCruhZkXSeZnCuMA8i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 380/456] net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter
Date: Mon, 17 Aug 2026 15:32:50 +0200
Message-ID: <20260817132554.334691183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit 2a33516f9ef59ad11844d4fc152f889449b5daf3 ]

The sch_cake ACK filter parses packets to find the TCP header and filter
duplicated ACKs if the flow is backlogged. The parsing code contains a
WARN_ON(1) which can be triggered by a malformed IP header in certain
cases. Depending on the system configuration, this leads either to
either spamming dmesg with warnings, or a panic if panic_on_warn is set.

The code already correctly skips the offending packet in the branch that
triggers the warning, so the WARN_ON itself doesn't really serve any
purpose. So just drop it altogether to avoid the inconvenient side
effects.

Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
Reported-by: Zhiling Zou <zhilinz@nebusec.ai>
Reported-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260729191417.45665-1-toke@toke.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index ad2597deebab6..d94c9c11ac1e2 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1281,7 +1281,6 @@ static struct sk_buff *cake_ack_filter(struct cake_sched_data *q,
 
 			seglen = ntohs(ipv6h_check->payload_len);
 		} else {
-			WARN_ON(1);  /* shouldn't happen */
 			continue;
 		}
 
-- 
2.53.0



