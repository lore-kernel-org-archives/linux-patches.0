Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0B224AF9;
	Mon, 18 Aug 2025 13:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523882; cv=none; b=cigRMGvQouxUnx2CfLO2HlNwZtwl4T5cdGG+qAVbxmmqWLWoBZ+KcH6VxMTah2AI4/7ZnRAy2DfL3EFBz39l7B1+E+HeK/ndgX7GBOvxDYvuz5paXpFHu51Ta5x3yOlkanoyNY5mh1BGIHzH7y3w8yEw8r9GIhMs+QLOSDaa9xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523882; c=relaxed/simple;
	bh=5+tjLzFlkbzeywd09XtkDNJFc9TRCTvAXX6N3glXdbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9GTavdhyL89LFZtAfPrj8wXmLDjL6yt9+cM2m6HZf5f7q2nvgDQEEoTQyJLsBTU2kK4Dp/x6YtJEJfIzdwqmECdo4GQMd03EFanX/coKlDkWkKCV12Jk0t8TvjgxqTBMBGujQlvT/ctHjmJrukEUbndb+2HYW23JtO+YmV9h0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdtkz/ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdtkz/ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721E3C113D0;
	Mon, 18 Aug 2025 13:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523881;
	bh=5+tjLzFlkbzeywd09XtkDNJFc9TRCTvAXX6N3glXdbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdtkz/eyjoqMHprgAmQXr59UmCGRB6dWS4K0CttOK198S/huK3EvxwQKf1HXub1NO
	 JeSTtiuNSdKotjZoB5/sXCJ3vG4Yh2gOGNgLZTwrY8g4VbQoyP8oJ5k9j+cFVnlz4n
	 VGYuwm6mldw1NJT0m2qUy+Kxfa89E4iRKrghtOJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 302/515] gve: Return error for unknown admin queue command
Date: Mon, 18 Aug 2025 14:44:48 +0200
Message-ID: <20250818124510.062247804@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit b11344f63fdd9e8c5121148a6965b41079071dd2 ]

In gve_adminq_issue_cmd(), return -EINVAL instead of 0 when an unknown
admin queue command opcode is encountered.

This prevents the function from silently succeeding on invalid input
and prevents undefined behavior by ensuring the function fails gracefully
when an unrecognized opcode is provided.

These changes improve error handling.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250616054504.1644770-2-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 3e8fc33cc11f..7f2334006f9f 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -564,6 +564,7 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.39.5



