Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A24341AB8;
	Sat, 30 May 2026 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162498; cv=none; b=BXz9F6bXuYLcpjSF9di0WK/Ue6B4WQemYgfb3ACCoTRHWovn4ojItTbDunkJF0flKIFzjpoIV34/iVBkTQr78VuOtTu3Au2s/BWStErCS+MBAjlraKYwbgSk0SxLv4i/QM3IrH4oMzEeVWNLgoCZTXbaatUH3BmVjxtu6B+guWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162498; c=relaxed/simple;
	bh=k8OO6IXo+kL3DkEX6M1aUCv66CCobWqwXjcGjYJMzs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e+7nxp62R9hvIMsStESZDLoyWPV7FtCfX7gkSFm0SyXrI1UuPWUaLUKkLnblqQ5Y2/+o6ih5wbEDq6diwIxw/HXm7Rv8/CkkR3iTjS2zfbc83zSPcch92+qF20miksdWhL1OgX4MTQQHjYCFt7yOV+wQVb+2Wx9EwrKYWuSjOCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2qwg+yP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2qwg+yP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEED1F00893;
	Sat, 30 May 2026 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162497;
	bh=mjKp4T3V5hP8UNz/WJKlUkLRW910UB4a1WAUnZOeUAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2qwg+yPt1Llbn7D7dGBT3klGyyq5kKkH+8btfOabjW+YwCb9kia2DxR8D5c1rNdi
	 uMo2oz9d6gZN1SGsX/AA3kp4auwkFG8NXyFH53lWaFoUAD9byEpo+R20Qduddf/noH
	 gLVgQQ6n8yba+ohctusDss2VvfN4sKd99acp43LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E9=92=B1=E4=B8=80=E9=93=AD?= <yimingqian591@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 938/969] net: tls: fix off-by-one in sg_chain entry count for wrapped sk_msg ring
Date: Sat, 30 May 2026 18:07:42 +0200
Message-ID: <20260530160326.655077321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ef7dda0915d33..a46f3cc4b3f14 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -801,11 +801,9 @@ static int tls_push_record(struct sock *sk, int flags,
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



