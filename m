Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D3E2AEEB;
	Sat, 12 Sep 2026 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227141; cv=none; b=UJh6AixGPOmQmtkyMbjerabBXv7qUOy5jWNmBcPKvC7k1jBurvyhFaM2bQNh8EbztVphPZLVyM3Z1OmgiCLnlClv3DOcpCq8Kt8JFN+/WfYSQznhgyUmBI1jDVVxzOUN7nkzvRNSM0/mjfd4UMukBVIagEkkV383Dq0du6LCw3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227141; c=relaxed/simple;
	bh=ddyFt2LQGVIBoZ8k9bnWAETsDq+bWe78OT1BuBJlxhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2YQ4Ftnr2fq8OH8YeoKdYedDuk/RbtGliwGqYVEolloxILnhKf/AHA6dPJEt+gRQvDujzm2UIHSHEOIy1NQS+rYsxIW48hO56X5HP6HucyQs1h0tGrjOQc40Cdc5YgYh/Gt1gT6TgiFdYrESYU5QU0qe4d42lvu52qLppKw1bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCMqVy4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCMqVy4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CFB1F000FF;
	Sat, 12 Sep 2026 15:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227139;
	bh=mFckn/aG61Atp8/RYvuQOqMy+5MZANt5/a3JRDBODwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCMqVy4XmbhDpSQ3liKv45nAPZZqBRTH6UWFKjInxqi2n8zBhApaLRYX7JBL0mD7j
	 9VBH+qK/k91Sp5N4axRe3MC+97T5DGSUtFtlU1JptZ2EPYquEMAYRQlBLnd1a6iIL2
	 XrhU1GmSfrl5KqUCjSQ93evTuBQ8hDqyRHZ3NwCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0103/1191] bnx2x: fix double free in bnx2x_init_firmware() error path
Date: Sat, 12 Sep 2026 08:47:11 +0200
Message-ID: <20260912065550.496093979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit d2796ffe38cb4155afe0eab23636295b096c27a5 upstream.

bnx2x_init_firmware() frees bp->init_ops, bp->init_data and
bp->init_ops_offsets in its error path without setting them to NULL.
The cleanup function bnx2x_release_firmware() frees the same three
pointers unconditionally, so if init_firmware fails and
release_firmware is later called (e.g. from __bnx2x_remove or through
the function state machine), all three are freed a second time.

Set each pointer to NULL after kfree() in the error path so that the
subsequent kfree(NULL) in bnx2x_release_firmware() is a safe no-op.

Fixes: 94a78b79cb5f ("bnx2x: Separated FW from the source.")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260815122149.951215-1-yijiangshan@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13488,10 +13488,13 @@ static int bnx2x_init_firmware(struct bn
 
 iro_alloc_err:
 	kfree(bp->init_ops_offsets);
+	bp->init_ops_offsets = NULL;
 init_offsets_alloc_err:
 	kfree(bp->init_ops);
+	bp->init_ops = NULL;
 init_ops_alloc_err:
 	kfree(bp->init_data);
+	bp->init_data = NULL;
 request_firmware_exit:
 	release_firmware(bp->firmware);
 	bp->firmware = NULL;


