Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CB035B149;
	Fri,  9 Jan 2026 12:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962761; cv=none; b=V9B2Wy2xrf+XUNSla18epmCYlfrmFwH8PnYz1KMarEqey5pQ1Bh2bVXrMkr4iMpB8Or0QgDCRPC3Xb+qbI7tZGxU/MZwih57aQH2IdFFRKaSIiXbLRh57HDLuYp22/iNFWbmncU5n/fH8g8aGNzEg+iIJYyPATPBWqNsx7Eyadk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962761; c=relaxed/simple;
	bh=AmXAJJztOZlUA6gOZcb2LEk414LF6DIN68EQZCINi1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id6juTus7fVPKNjPrz/ePotxw36NzqZB6hpmmvvwHYTwBQxai3MWGEsZfYO5QHls2anqeJYj91QkftDVF6l4ml4eAMqmNUUCGpKvq49vQxPqmY3HkfdoYxqg2RtLTnCGJZeK/3GTBOZB2EDorE+7wQKw9oCchzvGp9YBto42Kb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXavtMxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXavtMxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043D1C4CEF1;
	Fri,  9 Jan 2026 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962761;
	bh=AmXAJJztOZlUA6gOZcb2LEk414LF6DIN68EQZCINi1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXavtMxPL4qrj7MsRm5EVFFDdlZxBlZdOxcn1p1TOGECLeX17SjienLSpMFS2QF/T
	 7RY5P16RZGFMLtcJ0lU//DDXr4J+xbeqRZwds3QgVKZcikfQeCdbsVaxJsiluMbnZg
	 lbXblMu1VAz5QwRHLHI/w8B4Y7et6EHvVC3VjmnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 478/634] media: cec: Fix debugfs leak on bus_register() failure
Date: Fri,  9 Jan 2026 12:42:36 +0100
Message-ID: <20260109112135.534230918@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit c43bcd2b2aa3c2ca9d2433c3990ecbc2c47d10eb upstream.

In cec_devnode_init(), the debugfs directory created with
debugfs_create_dir() is not removed if bus_register() fails.
This leaves a stale "cec" entry in debugfs and prevents
proper module reloading.

Fix this by removing the debugfs directory in the error path.

Fixes: a56960e8b406 ("[media] cec: add HDMI CEC framework (core)")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/core/cec-core.c
+++ b/drivers/media/cec/core/cec-core.c
@@ -449,6 +449,7 @@ static int __init cec_devnode_init(void)
 
 	ret = bus_register(&cec_bus_type);
 	if (ret < 0) {
+		debugfs_remove_recursive(top_cec_dir);
 		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
 		pr_warn("cec: bus_register failed\n");
 		return -EIO;


