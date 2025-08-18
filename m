Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A633376B4;
	Mon, 18 Aug 2025 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525662; cv=none; b=JDJLeoMHLOJCOuzq6YfesswhzUEgTHOLV68ULiIOwH95GdOUxl3MGTYeFHBoSkJDY5d+Q43AtXqT75t1gLf56gSwaoL9AH//hFVLKBwoArQ8U2XiXHkzm5rIYTeWi2EJke/4942TqBvEIvzVoq1RFKLK6I3FRG+75jQoRSvr09E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525662; c=relaxed/simple;
	bh=z+WkyoSQQNapYb3WMQTc3fqnoN05D+sR62DafNjo0bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqwU+jnZ9vK8ZS6b/1jAdXjW+WgVYYGDhW/ONFOjkl30sl3SlGVRrdidcYH18bjOz1oX+5v6m6ukWp5X7PwUZGr8vk9ncNGH1DovYYkKc9p0A+XHUyglHH6KgPCGRxYmdwyp9ltHSSExsCMEtspUqzBpipn82mP03neoGJuOaTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o84yV921; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o84yV921"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D99EC4CEEB;
	Mon, 18 Aug 2025 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525662;
	bh=z+WkyoSQQNapYb3WMQTc3fqnoN05D+sR62DafNjo0bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o84yV921b5YXvVJyGGAhkEppn2p+J69PfCkge8c6dJ1GtlUYI6Sz3w1T0L96J+5Mp
	 aFlIICQpH1izfqMypDzrKEHrhSFUVHugIPSw4LddxRFFF1GGXLkL5Hl1PRIXriarMv
	 xm+6jY7c2/kz+XfdkS46RixK+mT03z6sEAp26mvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 329/570] gve: Return error for unknown admin queue command
Date: Mon, 18 Aug 2025 14:45:16 +0200
Message-ID: <20250818124518.528527475@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



