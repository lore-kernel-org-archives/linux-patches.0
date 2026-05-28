Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F348733291F;
	Thu, 28 May 2026 20:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001617; cv=none; b=sZoPmQq53tM9EcahA5AYCH8vRYjXkACa9MEQ9+kQmmkG4AXIasFCTZ6/UgXM9BX9R8C+tZEvVYAWkVtQKSSNXbQXGG/ZdtHt1BGmPHRcnfUd2ddroRSksWM4XCrl09KbQzp8NsZU99vk0MBgs5pUxOOIhkYdNKNXSEGlM1PLmn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001617; c=relaxed/simple;
	bh=DdpuxpjuqH7MXT7lLGcCUmqHxuNnVBQ6nUN7pwgmvFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bUpJ8nXm/967Mr3PtbY84RpRoSn1tjL98pAVhgCIPaLmgVxHr8h4Tg+ATfLd8d0fRyDZGQwu4UW9IIgihEL3IwikPXOsS3IKCCsttvZoSsFIbF13AGWV4j16QsbXcS4r+smtPqToel1AWbuNRhH7FMxN5SduMf8Yh0xxX45gLck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyoEGuZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyoEGuZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0B41F000E9;
	Thu, 28 May 2026 20:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001615;
	bh=VvfHc6cqqQeuYCBoihXWWSc5PhoKUetLTxliskvL17c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyoEGuZtMiwDxmqWOpznlCFZSmpyr2j/ipulEm4FJdBEYtsfWCpXVkNfKetwNni/Z
	 6zkFQRMLawua1CpjssFp8yJcQpzOGG73ZWpyrBwJMndIfBzXalU8MvcGbquN2FQZZS
	 G77GL7YbBu4zg+n6xtZnQ6mrwAe8GW7mkZ+O1P9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E9=92=B1=E4=B8=80=E9=93=AD?= <yimingqian591@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/186] net: tls: fix off-by-one in sg_chain entry count for wrapped sk_msg ring
Date: Thu, 28 May 2026 21:50:24 +0200
Message-ID: <20260528194932.839888867@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 285943c6e7ca309bbea84b253745154241d9788a ]

When an sk_msg scatterlist ring wraps (sg.end < sg.start),
tls_push_record() chains the tail portion of the ring to the head
using sg_chain(). An extra entry in the sg array is reserved for
this:

  struct sk_msg_sg {
        [...]
        /* The extra two elements:
         * 1) used for chaining the front and sections when the list becomes
         *    partitioned (e.g. end < start). The crypto APIs require the
         *    chaining;
         * 2) to chain tailer SG entries after the message.
         */
        struct scatterlist              data[MAX_MSG_FRAGS + 2];

The current code uses MAX_SKB_FRAGS + 1 as the ring size:

    sg_chain(&msg_pl->sg.data[msg_pl->sg.start],
             MAX_SKB_FRAGS - msg_pl->sg.start + 1,
             msg_pl->sg.data);

This places the chain pointer at

  sg_chain(data[start], (MAX_SKB_FRAGS - msg_start + 1) .. =
  &data[start] + (MAX_SKB_FRAGS - msg_start + 1) - 1 =
  data[start + (MAX_SKB_FRAGS - start + 1) - 1] =
  data[MAX_SKB_FRAGS]

instead of the true last entry. This is likely due to a "race" of
the commit under Fixes landing close to
commit 031097d9e079 ("bpf: sk_msg, zap ingress queue on psock down")

Convert to ARRAY_SIZE and drop the data[start] / - start (as suggested
by Sabrina).

Reported-by: 钱一铭 <yimingqian591@gmail.com>
Fixes: 9aaaa56845a0 ("bpf: Sockmap/tls, skmsg can have wrapped skmsg that needs extra chaining")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260511174920.433155-2-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 937aa78eed0e4..5ada6e54fb328 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -800,11 +800,9 @@ static int tls_push_record(struct sock *sk, int flags,
 		sg_mark_end(sk_msg_elem(msg_pl, i));
 	}
 
-	if (msg_pl->sg.end < msg_pl->sg.start) {
-		sg_chain(&msg_pl->sg.data[msg_pl->sg.start],
-			 MAX_SKB_FRAGS - msg_pl->sg.start + 1,
+	if (msg_pl->sg.end < msg_pl->sg.start)
+		sg_chain(msg_pl->sg.data, ARRAY_SIZE(msg_pl->sg.data),
 			 msg_pl->sg.data);
-	}
 
 	i = msg_pl->sg.start;
 	sg_chain(rec->sg_aead_in, 2, &msg_pl->sg.data[i]);
-- 
2.53.0



