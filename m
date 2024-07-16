Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7ECF9E8;
	Tue, 16 Jul 2024 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144476; cv=none; b=PwJFZsbxpFryjn8drTYvk8FC43T+iQC9DHiFb7jYv2btMHgTMYuVlrntmKvotqabHD57IIrL92ltFFFPi0hlTyS/FkOvRI0EdtQmYY1QUCc7mqqawsC9lfSrkhxc68u/yfsjMoPNouBF4oFpQ/N4mUeX06fbKrGnlCOGM55F0xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144476; c=relaxed/simple;
	bh=abwGrbh/0o2GxIukyPO7V7iItAu9dd7e7YwYiJNO+sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4TNcupZ9GA9C81SRRTM5rRXUDD4QHdI8+U7+TCA0L5BOmZNqA8E3N7mZmF4q1L7N9QkDABv9W5bgOX+rgf2g5pvHQxtjS7gUhYfJQO8l+/RINtGJB6lD3+3Jf5+ze/mpgkdpgw9uYCfNjTLkL3Xo7wxauoY9IvCrWuGcoimh34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7jPilCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7jPilCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C64C116B1;
	Tue, 16 Jul 2024 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144476;
	bh=abwGrbh/0o2GxIukyPO7V7iItAu9dd7e7YwYiJNO+sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7jPilCr6phm4AygBeVevkwejq7Kv4Xo3xDJ1sR00TP+20uJSQAdcGEsnHxFROcog
	 suQahLMEjK1UaMOLiDVUINsUGb2fjIxV+SeLujZdpURujN8ItbUXR79rLIOStGlqr/
	 xfsfrV0tYD4oqsjzt6OxY0V6VxgrMM4wHXXjSoIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Mazur <mmazur2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 58/78] octeontx2-af: fix detection of IP layer
Date: Tue, 16 Jul 2024 17:31:30 +0200
Message-ID: <20240716152742.888487029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Mazur <mmazur2@marvell.com>

[ Upstream commit 404dc0fd6fb0bb942b18008c6f8c0320b80aca20 ]

Checksum and length checks are not enabled for IPv4 header with
options and IPv6 with extension headers.
To fix this a change in enum npc_kpu_lc_ltype is required which will
allow adjustment of LTYPE_MASK to detect all types of IP headers.

Fixes: 21e6699e5cd6 ("octeontx2-af: Add NPC KPU profile")
Signed-off-by: Michal Mazur <mmazur2@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 5d4df315a0e19..86d5bda2c0bff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -38,14 +38,18 @@ enum npc_kpu_lb_ltype {
 	NPC_LT_LB_ITAG,
 };
 
+/* Don't modify ltypes up to IP6_EXT, otherwise length and checksum of IP
+ * headers may not be checked correctly. IPv4 ltypes and IPv6 ltypes must
+ * differ only at bit 0 so mask 0xE can be used to detect extended headers.
+ */
 enum npc_kpu_lc_ltype {
-	NPC_LT_LC_IP = 1,
+	NPC_LT_LC_PTP = 1,
+	NPC_LT_LC_IP,
 	NPC_LT_LC_IP6,
 	NPC_LT_LC_ARP,
 	NPC_LT_LC_RARP,
 	NPC_LT_LC_MPLS,
 	NPC_LT_LC_NSH,
-	NPC_LT_LC_PTP,
 	NPC_LT_LC_FCOE,
 };
 
-- 
2.43.0



