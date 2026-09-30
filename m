Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B61D4E36F5;
	Wed, 30 Sep 2026 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784274; cv=none; b=owPR01iGh0QSYjgsFLssN/J3o8ctGoJfSGYYPJiqiLlL8/l8DxjScPZlssWuV4wiI4pK6Fm89X68juW73N0WKk5CPn4mxvVDVByQT0aCXTYs8/bzFrjG7cDVJaHK8M9RO4cQEmbG6qPjr4ZdbtztldvSqpEanF14g8bB5VMiGIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784274; c=relaxed/simple;
	bh=n8RF8V9elbMW1bnUnM5NlInb6wQZxtgga6atpbM1g08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1+2allj+tQ8xSfO+o4MrQbc+C95Wl6bWsq2utH8bLfSKUqGl23rUi67EjvMFQ92Su8hoVDkmnXjIoio+XR+0Pqb086fuTMTbNLPjznHHY0xLFlvDbFkIAm7cL3zVr11wjoIazUhs6phqShNcLKvcQiBPJiHC4nQlIloSO9C01E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKZHhsGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKZHhsGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1620F1F000FF;
	Wed, 30 Sep 2026 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784269;
	bh=LFv2I/tmRbllPIUQM7Wy3bTiq95lbtSL7on4RCqvSAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKZHhsGwGzz0DWrN7FBwa3eBpu1KBgoXUIbzBlHA1wWlcYzNkimnSx/5JenBNt+tf
	 W6kJ1vZ0zWg+vrvRFSaFNYUS/KXMxzDGv5i7LsfZxITZxQBIMOG/qckNkBYgygKfuX
	 yptxmIqSkFAHlDu/oRiXqLrCbreonGval9d657Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/982] net: hsr: require valid EOT supervision TLV
Date: Wed, 30 Sep 2026 17:13:52 +0200
Message-ID: <20260930152418.874557372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



