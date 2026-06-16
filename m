Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C572EEE74;
	Tue, 16 Jun 2026 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625027; cv=none; b=ryfHUBhc8hHCPWUljlQ+4fUl8h+4593CG7sCoXSvAIB8OAEp04Gh1eq+09ckFKvcp1hFarTHvAGRAvneyH5Dk/J00GNTNotR0v7dgM4rmUA0Xq4B6j+2lnMsw6T3YHK0wPXLiRv1oKJL6RvHsM169jZEXy7M/PYCwalcHeC+8Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625027; c=relaxed/simple;
	bh=G8ch1l5th8N5/q4kPaf6sIuK+qr67Qv50tBcBgW7C9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbQqpIXF81S+C3kqbH6TzqGTKVfNMoeiR3pxkpd1faS+9XW2eF1NTYD7KFcNXdEc061ATiLxvy5r8FjwWTVPr+G68zZ1v85X3zqO8DHlp9+y80lV+NlFzG2skP2eLpLUd64+2SPz8hDii+v1ZWjeP6kWB+0X6osy6lfzft813GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anMXREdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anMXREdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39191F000E9;
	Tue, 16 Jun 2026 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625026;
	bh=Ov2i2n7I8CSbJGOJrUotiWizOgFKoRRGVQWoQPr2FIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anMXREdAPZQBKvgvp3EjzIqtYpbPSzSmgzyY1q+ploSVHrUUjmfMQ4ooDXg233EWA
	 n6kNm7TCWN5pBOUUxgGMUgggafQ2IYFa9qBVGHustVA9p93ngTEYm9pbAmCm6Ur27s
	 +lKkYQVEU1uJms/5Lj++8RUmEIFVUQMmzYcvwhGc=
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
Subject: [PATCH 6.18 066/325] net/802/mrp: fix vector attribute parsing in mrp_pdu_parse_vecattr
Date: Tue, 16 Jun 2026 20:27:42 +0530
Message-ID: <20260616145100.987694024@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 23a88305f900cf..cb3535523bdffa 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -703,6 +703,12 @@ static int mrp_pdu_parse_vecattr(struct mrp_applicant *app,
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
@@ -753,6 +759,9 @@ static int mrp_pdu_parse_vecattr(struct mrp_applicant *app,
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



