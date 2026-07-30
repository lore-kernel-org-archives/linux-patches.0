Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D12175A6D;
	Thu, 30 Jul 2026 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423294; cv=none; b=cZETyxQzjL/D9y/XX7/s8vlz7v3cbvCHXwhzgcUilfDw9Rb4H6RN1B49flxtiNwvWiN8D5r1NOKSnmGdNHIf5Ar3uFAgJ0WmGMzha5Zxq/s+DKWInFx3QgS9oNcXo3U8YYbD7SMSVWaxnobT9f/+iAIe4KDNXNN2pnTdJGqlh/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423294; c=relaxed/simple;
	bh=YCuCNdHvd21gio2Au0emmb7vTS9d00Xq1+OpBkN8vas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYrKGDNZOq57S6L2WFl7K9GKHPSgGyOOkDYdiKPHdkLr/PlSD4Fyhu5qdBQ0HxKpKPtVdB1zTg17GghfswoIlulowuZ8daRUxXb+Wz8IJ30hVvpWMHLV4zCYEwGKTxghRddFF0mLqJFv27u6ObHpiBaacuAmXox6GrTy5qel6ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbbOTJad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbbOTJad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EA31F000E9;
	Thu, 30 Jul 2026 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423293;
	bh=mgeh+5obG4ldzSxx0MUha/lyIn50RlJdmZpKKskVzRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbbOTJadfubRc+0SdQvfW6VHH7NkeBTaNqTZMJbDGHa9fYfBxEs5RfxgH2hy3f5TM
	 u1Q69FWAUdACho9q8sXPRuKVu/81arotKi63kN24J8NBH5wwCX1BpVGL2a3ldLl8hv
	 JExNMHrGcm7PH6pDsYBPAt9m9SzsZpWhHZuTzbFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 733/744] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Thu, 30 Jul 2026 16:16:46 +0200
Message-ID: <20260730141459.886744878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1012,6 +1012,7 @@ static void tb_service_release(struct de
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 const struct device_type tb_service_type = {
@@ -1120,7 +1121,7 @@ static void enumerate_services(struct tb
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);


