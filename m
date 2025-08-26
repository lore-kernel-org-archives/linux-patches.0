Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C22352FDF;
	Tue, 26 Aug 2025 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217803; cv=none; b=iwGlt5Ovnh213BaTMgdWuMVe7xqYfOQIUwlpIGCkDY/lFmP9XsSkigFy8yv5fp6nVR4XsiSLSACGqfenNsW11JVetg6sJ7VtThSBgZrSsW6/WQyIMdndO7xmx6AcoHowrtPJv2f4Nc1yyAXlHo8YaW57yzkGm64G0qWGTu8ghMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217803; c=relaxed/simple;
	bh=aKXPoLXFkmCVvOKdW0rUmlrFnQ0F3QEQWD/Jdtk0oa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUKSGIX800TiUFJtX76rlXeuXFeqeD3gXP/pTdJy3RL3O89QZvIgGrvv0uqvZKThuGxkm5ubtGW2PvttK+1j4yoY3jH1rjq3Y8gk5e4t8GxJAVhDZc6JRxPh0rfup6qrDUF1SDSwIQct0U1tWYE2A+MBSCdtBnVB1fIBnzolRfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qS016TDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qS016TDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE15C4CEF1;
	Tue, 26 Aug 2025 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217803;
	bh=aKXPoLXFkmCVvOKdW0rUmlrFnQ0F3QEQWD/Jdtk0oa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qS016TDDsuTFCLGWPuNlNRrVg0bkZ8/1q7YhBSGbBsShvTfnjgyVDRVLlQiq1QyUJ
	 Iq+JwkO+cVYf5z4LhT0AA7uZzERK5fN6avV9tbhGUSbUOxaFpb0yg51HjDuuYGfzec
	 aboiz1syX7W6fHRVOfh+a4+Hb/QasA/aO054XXzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/523] gve: Return error for unknown admin queue command
Date: Tue, 26 Aug 2025 13:08:11 +0200
Message-ID: <20250826110931.368269989@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 67f2b9a61463..f02b3f01a557 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -246,6 +246,7 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.39.5



