Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94171A00F0;
	Tue, 26 Aug 2025 12:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213116; cv=none; b=kH+1qkjikLBf4AxZv48sJ82quvgfE51Jwn4vy2AYA2JLqt8afn0puQ8WtDyi2cAAsYKGV/b9+kW5+QW7/rPkq+iFK+y/Nc+EYxOuRVHtcgYqL6bj/Jnsb//xAvAy29zbVa4JRSTL2pCNHNF/D4rSPaYH3y9/RR0tDbjYeyj6eWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213116; c=relaxed/simple;
	bh=q1+jItuhTmpGkx/h34ZovI9d6/Fbsxg8Q2PYA0RWtdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ks4VKvkVUbImpqkXOHah4JwNWSn9eYoM0ewy8Ix+eGoNYmZZRSEz+6khIcacETJHUSCKuRsAwu/7D/StiVkvUFym5G7a2vX/7CHsrONQBrdjkBHbRngZsLrHfrowJ++bj9XAh/JKPUK/IpENoufEjC9zP4z8FolMxLdECQVsn2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VI4KeV18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VI4KeV18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BD8C4CEF1;
	Tue, 26 Aug 2025 12:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213116;
	bh=q1+jItuhTmpGkx/h34ZovI9d6/Fbsxg8Q2PYA0RWtdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VI4KeV18aT6SgMZdC2Zi+X61DP8Nfd0ZGdNZAKbtlsaSLDquTOINF+l1pCns55lS1
	 0BZPRTmldEB+brWjaZUfKdBXbdLxDRKW3ug+3AaerWduP6pYfwxqz0eGYgARZD405w
	 5rMVJoGw85svA3mZhnepx3xMWpn2ivrDQkiuvWWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/587] gve: Return error for unknown admin queue command
Date: Tue, 26 Aug 2025 13:05:45 +0200
Message-ID: <20250826110957.926337042@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 79db7a6d42bc..9c50febb4271 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -431,6 +431,7 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.39.5



