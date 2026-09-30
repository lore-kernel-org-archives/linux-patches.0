Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EF73DB328;
	Wed, 30 Sep 2026 18:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794158; cv=none; b=F2nGGm5F+7Q0jod82F4ivvs3KFrdSzGx+OAImA0IY0D0Y0HkR3R5Zr6UallBRllqFLPDB5lNECsURg0iwrTbfQ1Lx9M0nmAtkySR3icWWbJ9ls5vs7jt57dPu1b/XcwcPvAml5tUuNjXs/fbyB+pvpe7c5xvEjcTKdzSI8tkPKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794158; c=relaxed/simple;
	bh=pn4Yr8eN1UykFr/hLULnQVk869FofN6lc7lehENabIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOIhm4nr3+LwcZV0QoyqM5ULrFEhOpHsUpL9AJOS72zds2egXv+e2GQuQUk2V/OXPs4oggl4Mm45ooWUJo9fVurK637PG3bXRevOjEioA5LJr1sRg3Ewgb3JXZllZiAmEKzSCq/mx2L1DEtOBDP7k9OttCs4YgXJhZDJEoaybts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzyfRygx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzyfRygx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E7D1F000FF;
	Wed, 30 Sep 2026 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794157;
	bh=Wl8oSkNI69pp7tQHtvj1wMkCeocqx768IgRjd8Whp5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JzyfRygx5bCyP4XGHh8yD7AHy9d4HA4HC/AMlK6kecVUsh2KODEHf+YDh695kU8n2
	 p8JrEUXYnCgZX9kum5fMgaeBcTNmlvAl0ElCPrgu2WUkZr/nJY5hUjO/SJvMdxUCoh
	 ESb2XAsmW/q3TyU6iOBJberjF48jLg54BHo8cWao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0113/1193] net: hsr: require valid EOT supervision TLV
Date: Wed, 30 Sep 2026 17:13:17 +0200
Message-ID: <20260930152436.736102063@linuxfoundation.org>
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

From: Luka Gejak <luka.gejak@linux.dev>

[ Upstream commit 46d111a3ef3b5972804dcdce0833767143a12192 ]

Supervision frames are only valid if terminated with a zero-length EOT
TLV. The current check fails to reject non-EOT entries as the terminal
TLV, potentially allowing malformed supervision traffic.

Fix this by strictly requiring the terminal TLV to be HSR_TLV_EOT with
a length of zero.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260523130420.62144-1-luka.gejak@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 2a6df958292c8..c66728d7d285e 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -110,7 +110,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 	}
 
 	/* end of tlvs must follow at the end */
-	if (hsr_sup_tlv->HSR_TLV_type == HSR_TLV_EOT &&
+	if (hsr_sup_tlv->HSR_TLV_type != HSR_TLV_EOT ||
 	    hsr_sup_tlv->HSR_TLV_length != 0)
 		return false;
 
-- 
2.53.0



