Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758E84071DA;
	Sun,  7 Jun 2026 10:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827407; cv=none; b=P8TJ/8Ix9pcHjqHVkd9JVsFGHrDRkMW005NihdymLiOLzNVmOP356L18vwDjNOs4RwQIIFhyo82NlFOIk9NhlKvOkmRfFgf1sewKWUnqYKWB0MzRUkEIMXcJINIHlez41D+BQq33ig7DwiAFR5mJoTD+modenQSOi9t+5b47YU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827407; c=relaxed/simple;
	bh=fIZ2Wforgy3uyd7hGsmPsy2SUBWMYLOcL4td0dwb9go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TV/mjXvQj3TLg5SpYbHcWQbnv+NQEGWBCRfd50dyTj0EMqtbucFyxcaTELvxWo5OdSBz8J6i9m3r48SZ2IIYCG2b8IiE63DIiobzUGmO75Roz/cQ3/KOOEkLuTqZl8uHMAVm5L0hotlEGaZt6Xq4EJPPP4yxiPBFntvwxo8YxP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETkoDPSV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETkoDPSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC581F00893;
	Sun,  7 Jun 2026 10:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827406;
	bh=44CYx6w1M6MwefD5Nbx+6BbZ6rzY0dKZYtn7tdKQct8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETkoDPSVFR9msZ//tC60Y8XSZ+4ro8pra4Gdte/X71/Ybj/VBp7GoPnxI1i27VhHX
	 mPAhnU1POeBbaboEtNqG7denC2doJwrtexRT4Mpgitw27Rujn3vqqeIjW8Mm67PpQa
	 E+Sln9h64bvze3EGXLGtn9TGVvbd2fHoDSYbbx+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/315] ethtool: strset: fix header attribute index in ethnl_req_get_phydev()
Date: Sun,  7 Jun 2026 11:57:38 +0200
Message-ID: <20260607095730.221629254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a8d8bef6b45bf7cc0b1f6110c5cd8d0160a9bad7 ]

strset_prepare_data() passes ETHTOOL_A_HEADER_FLAGS (3) as the header
attribute to ethnl_req_get_phydev(). This is incorrect, in the main
attr space 3 is ETHTOOL_A_STRSET_COUNTS_ONLY, not the request
header attr. The correct constant is ETHTOOL_A_STRSET_HEADER (1).

ethnl_req_get_phydev() only uses this value for the extack,
so this is not a "functionally visible"(?) bug.

Fixes: e96c93aa4be9 ("net: ethtool: strset: Allow querying phy stats by index")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-9-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/strset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index f6a67109beda1b..872ca593b97668 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -309,7 +309,7 @@ static int strset_prepare_data(const struct ethnl_req_info *req_base,
 		return 0;
 	}
 
-	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_HEADER_FLAGS,
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_STRSET_HEADER,
 				      info->extack);
 
 	/* phydev can be NULL, check for errors only */
-- 
2.53.0



