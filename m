Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFF63FD137;
	Wed, 30 Sep 2026 19:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796739; cv=none; b=Q4dYZq3AifqtuKLENG4conjWYhAOwxchL3ok2ppsaO72SJ8LBBFRbboHapCcj+jpLxxqfDAS1s4JtVGIUOBgD54bRwCRN69EJSAS8TaPzj5wF9WFkmuIzW43jwc8869GVi/X1wi576dkKzCZ+Klab7aZpSSvOwrhdislZH/y/kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796739; c=relaxed/simple;
	bh=DoscHxveYmAadIKGggxBKCPBcN6fGR11eiPzQqXDsLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRxuq6gaV4CpMKbNgCiw0+3VGme6t+uMkoEB+2GkHGNyk4oJpt/xjAK4VRY+m0PVtUo1wgykl4GKfww21JTW3QyEBSJX1XFyW3pHYk65kIy84upErVdIpi790vck+aIzPtigwAaedqEi0t9/N9JXrK54/7RhAEZBV+aYyO5ue30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7KjKx7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7KjKx7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A24E1F000FF;
	Wed, 30 Sep 2026 19:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796737;
	bh=zgp2M4GbCUNT8jRvk4pHj/j56Bk8gjYuLmFUnr3DDgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7KjKx7jOKWuql5tuovZvErCu2EW0gkbbajEdppvwoqA62lFc2xr+ioT2cotr82Tq
	 VdddqSmXZvRdLokH0oc54sQOaS9fZ2Nh3lAcjD83o4xBXvZ+rMXr3JQu7yivm+Y4PM
	 57TiHS2eKuIWP3CwCQsXusMgV0sj+YqBWOGSR9dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1019/1193] Bluetooth: RFCOMM: Reject short EA=0 frames in rfcomm_recv_frame()
Date: Wed, 30 Sep 2026 17:28:23 +0200
Message-ID: <20260930152456.877958825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 6d91041bb38b97e2feb625123cc0529d7b83a0e1 ]

While rfcomm_recv_frame() verifies that skb->len is at least
sizeof(*hdr) + 1 (4 bytes: 3-byte header + 1-byte FCS), an RFCOMM frame
with an extended 2-byte length field (!__test_ea(hdr->len)) has a 4-byte
header plus a 1-byte FCS (5 bytes minimum, sizeof(*hdr) + 2).

When a 4-byte RFCOMM frame with EA == 0 arrives:
1. The initial skb->len < sizeof(*hdr) + 1 check passes (4 < 4 is false).
2. Trimming the FCS byte decrements skb->len to 3.
3. If __check_fcs() succeeds, skb_pull(skb, 4) fails (4 > 3) and returns
   NULL without advancing skb->data.
4. Because the return value of skb_pull() is ignored, the un-pulled
   3-byte struct rfcomm_hdr remains at skb->data and is either queued as
   application payload via rfcomm_recv_data() or parsed as a multiplexer
   control command via rfcomm_recv_mcc() on DLCI 0.

Fix this by extending the length check in rfcomm_recv_frame() to also
require skb->len >= sizeof(*hdr) + 2 when !__test_ea(hdr->len).

Fixes: b230e5bf501c ("Bluetooth: RFCOMM: validate skb length in rfcomm_recv_frame")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 9801e236c307f..791283d1c1f7e 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1817,7 +1817,8 @@ static struct rfcomm_session *rfcomm_recv_frame(struct rfcomm_session *s,
 		return s;
 	}
 
-	if (skb->len < sizeof(*hdr) + 1) {
+	if (skb->len < sizeof(*hdr) + 1 ||
+	    (!__test_ea(hdr->len) && skb->len < sizeof(*hdr) + 2)) {
 		kfree_skb(skb);
 		return s;
 	}
-- 
2.53.0



