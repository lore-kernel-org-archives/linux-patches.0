Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE3746AEE1;
	Tue, 16 Jun 2026 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635960; cv=none; b=VkIdeAJCgsha85vCe0mFZLSZpzB5nOQA/OOn831mGyJZi6ISKjvhu4Fy3BqC5Xt2JNAKNQ2hpmHwIoLJXna1Zo74K1p+dpZ0MgJNMfIk4+VeXx96V81iSn3s7CNwvZa9pg7cN1+Q0gDWxCpVBERRv79IBsZLqyXwJXDeqhYJrfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635960; c=relaxed/simple;
	bh=3hv2XPksymUnRZCokGumVkp6B/K8ga4eXjjWObxLip0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2tPPgd9v6S28v0OZo/i86MubFjn+MlmDAP7mjxvKHuwzQbeozWfC6MtPhH2d6OnsYfIdQlPT56cxjrM/MqB9Vheg4G2tlmwamLIHjbV9YtRG5vctYXVE5JruBz7Sjhi9J/gepGyd7XljS/Iap8fu+E02RDMpltCj8nJppby+Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9laFdW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9laFdW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8BD1F000E9;
	Tue, 16 Jun 2026 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635959;
	bh=vBcWKKZNwBfcGjgir53woF0eyU5h3Wxpyn35lX7MtoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9laFdW/LtpDPDx57BMxFKKcPadNVTqm+pw24sk+/VVI+UTEcDovwtp8Tqf+KDZfx
	 9gbL5lR/MYgl9NQns2bcr3zG+UPA2aaxbZkljWnPU03bxeFXOhDwGj8Mclm24FanDK
	 lFlBiznf1OaXWhkSqxmxy8jaECB9IgoPMRra1elA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/342] net/802/mrp: fix vector attribute parsing in mrp_pdu_parse_vecattr
Date: Tue, 16 Jun 2026 20:27:24 +0530
Message-ID: <20260616145055.065952993@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 7561c7fbc694308da73300f036719e63e42bf0b4 ]

In mrp_pdu_parse_vecattr(), vector attribute events are encoded three
per byte and valen tracks the number of events left to process.

The parser decrements valen after processing the first and second events
from each event byte, but not after processing the third one. When valen
is exactly a multiple of three, the loop continues after the last valid
event and consumes the next byte as a new event byte, applying a
spurious event to the MRP applicant state.

Additionally, when valen is zero the parser unconditionally consumes
attrlen bytes as FirstValue and advances the offset, even though per
IEEE 802.1ak a VectorAttribute with only a LeaveAllEvent has valen of
zero and no FirstValue or Vector fields. This corrupts the offset for
subsequent PDU parsing.

Also, when valen exceeds three the loop crosses byte boundaries but
the attribute value is not incremented between the last event of one
byte and the first event of the next. This causes the first event of
the next byte to use the same attribute value as the third event
rather than the next consecutive value.

Decrement valen after processing the third event, skip FirstValue
consumption when valen is zero, and increment the attribute value at
the end of each loop iteration.

Fixes: febf018d2234 ("net/802: Implement Multiple Registration Protocol (MRP)")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Link: https://patch.msgid.link/20260603060016.21522-1-zhaoyz24@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/802/mrp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/802/mrp.c b/net/802/mrp.c
index c10a432a5b4351..017839c141841f 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -702,6 +702,12 @@ static int mrp_pdu_parse_vecattr(struct mrp_applicant *app,
 	valen = be16_to_cpu(get_unaligned(&mrp_cb(skb)->vah->lenflags) &
 			    MRP_VECATTR_HDR_LEN_MASK);
 
+	/* If valen is 0, only a LeaveAllEvent is present; FirstValue and
+	 * Vector fields are absent per IEEE 802.1ak.
+	 */
+	if (valen == 0)
+		return 0;
+
 	/* The VectorAttribute structure in a PDU carries event information
 	 * about one or more attributes having consecutive values. Only the
 	 * value for the first attribute is contained in the structure. So
@@ -752,6 +758,9 @@ static int mrp_pdu_parse_vecattr(struct mrp_applicant *app,
 		vaevents %= __MRP_VECATTR_EVENT_MAX;
 		vaevent = vaevents;
 		mrp_pdu_parse_vecattr_event(app, skb, vaevent);
+		valen--;
+		mrp_attrvalue_inc(mrp_cb(skb)->attrvalue,
+				  mrp_cb(skb)->mh->attrlen);
 	}
 	return 0;
 }
-- 
2.53.0



