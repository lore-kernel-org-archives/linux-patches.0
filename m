Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABFE281369;
	Fri,  7 Aug 2026 15:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115921; cv=none; b=fGacoIE2lir4mLGnLwTgDpd3FR3iPfqEmd/SHNnwiAM0DILLenhRWijh+nG40jZy7xLEb71YZjoSFVYWVjmSJC4kbQrPetgBKZsnD8mtNnOrJ6Tey0eEl++9WU31BZAsw1E+CIr9LE2jN3nl3geyQRC7vq2IpM2K/PmW2Q5GfaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115921; c=relaxed/simple;
	bh=jkKeJFlUsHZ7m0PbLtVVBJLuyOu021ZINjcJc/DdgTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eaz6OpSpegAAGT/UCidOa9lzzG5x/XueJ1suK+lQJVZ+QGVfQTY6OheISMT9uRSlTpuBHmGn+dOBWmScy8B54UPwjRvUVOI6FdsTQfsvS/rlXeC10ftItPH+8IlaiAuVFZmYT4a6fnpHhQGSzh5b0JzoF59suPUr88mr/7loNOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1r/iLk8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1r/iLk8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDDD1F000E9;
	Fri,  7 Aug 2026 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115920;
	bh=GbWAQ78A4JMHPlfHDsbZ4gL/yh+7VtDy4nrcqNP6ozk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1r/iLk8q7lE1ufrkj5cV/18wWMOtNCYL50QmiQi2BfW4sIKXAQPCofUA20evZj8fG
	 PyTct+iE9jCNLdmUGVGCLzRCNGsIb4j4m00eZNElMQvyLaYw2j/RPbIyQvwlAYuFa+
	 BhTXmOdy0ASuRQ/KWXFmmpaFyNnpd/cbSo5w4inE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Corvaglia <david@corvaglia.dev>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/261] net: bridge: mrp: fix Option TLV length in MRP_Test frames
Date: Fri,  7 Aug 2026 16:36:45 +0200
Message-ID: <20260807143416.422428120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: David Corvaglia <david@corvaglia.dev>

[ Upstream commit 5546da86894d5906f131b05890705a7abf949d84 ]

oui is a pointer, so sizeof(oui) is the pointer size. The MRA
Option TLV thus advertises a wrong length (15 vs 10 on x86_64),
causing misparsing of the frame on peers. Fix is to replace
with sizeof(*oui).

Fixes: f7458934b079 ("net: bridge: mrp: Update the Test frames for MRA")
Signed-off-by: David Corvaglia <david@corvaglia.dev>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260726062605.2746-1-david@corvaglia.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index fd2de35ffb3cf..5fd22bb4f5b60 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -215,7 +215,7 @@ static struct sk_buff *br_mrp_alloc_test_skb(struct br_mrp *mrp,
 		struct br_mrp_oui_hdr *oui = NULL;
 		u8 length;
 
-		length = sizeof(*sub_opt) + sizeof(*sub_tlv) + sizeof(oui) +
+		length = sizeof(*sub_opt) + sizeof(*sub_tlv) + sizeof(*oui) +
 			MRP_OPT_PADDING;
 		br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_OPTION, length);
 
-- 
2.53.0



