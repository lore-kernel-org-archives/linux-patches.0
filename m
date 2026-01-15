Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE373D349E;
	Thu, 15 Jan 2026 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499966; cv=none; b=Us1G4+DG3fM4rBPHJDdNfFIe4Lz2bjL/c9uvn475raDzQUn7KqClTT2yEWRQg6WqcdE6wdX0mUYQ6KcEXwDX29L3IkH0uzvUT4zDqQiuJQC+8qylZKdZ4/xXz4yPFlG+e0xUeVch94NWmqv0bDqG5YGO26wsJHwjRcgqSknHHno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499966; c=relaxed/simple;
	bh=qltydNzxNjaUNBbdpFhMbulkFQ80BFtO4PDmsRnjFz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2o6ZqUyS529rLpSt90PsdMV1TnzoQpXZNeHwJEMQ/0yBMmCOn+Vp3+C2ybwVoIAshzP4nRuIrN/KBP5Fi3jVZN6Ltv7PitLZ3tcjtzLSWezNMmhxDO7SUgZy9tpde/nwNMe3kLvsPQYdZJV2VLU0JUP0E7/1Se4GjAMxyRt9Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+wJyvAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+wJyvAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136E3C116D0;
	Thu, 15 Jan 2026 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499966;
	bh=qltydNzxNjaUNBbdpFhMbulkFQ80BFtO4PDmsRnjFz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+wJyvAt3iadqgWIQnWIWjQB/dpL1Fe4HanAIhljdR2GeRTXH3r2cKYUy+8AOXFRD
	 /d1sdKdMqaG7/ev4162+nm73jPPHr5R/52ioEE2zpna9ycMzNtQyLIEA/r/rp1p4MS
	 j4ZZVre9v2+tv45cfONc2K2GKUKvu84yWTeQKGiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/451] media: renesas: rcar_drif: fix device node reference leak in rcar_drif_bond_enabled
Date: Thu, 15 Jan 2026 17:49:40 +0100
Message-ID: <20260115164244.630358051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 445e1658894fd74eab7e53071fa16233887574ed ]

The function calls of_parse_phandle() which returns
a device node with an incremented reference count. When the bonded device
is not available, the function
returns NULL without releasing the reference, causing a reference leak.

Add of_node_put(np) to release the device node reference.
The of_node_put function handles NULL pointers.

Found through static analysis by reviewing the doc of of_parse_phandle()
and cross-checking its usage patterns across the codebase.

Fixes: 7625ee981af1 ("[media] media: platform: rcar_drif: Add DRIF support")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rcar_drif.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1253,6 +1253,7 @@ static struct device_node *rcar_drif_bon
 	if (np && of_device_is_available(np))
 		return np;
 
+	of_node_put(np);
 	return NULL;
 }
 


