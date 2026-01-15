Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C2B86334;
	Thu, 15 Jan 2026 17:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498720; cv=none; b=hNYm9nI4lfZqKdcPGYKbYZ0e/3whhhM46bBvieu+fzZ+bP2pQ1+4ne72DUzbepsnRpsqS8E0cBntBfZsrKxY4nFevRoM2wAEZnSU//0KkD2s++VMqSd2KMKYyD4QuOngwNTUfPLAK232z3xhlK9Hp4Oxyf+KVQ7/XXJ9HKoz/NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498720; c=relaxed/simple;
	bh=vcb8DYub5I7ndI/ak1HH/wHxSCAJH/eudNXlyBxVylc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7oQe8Qk+9Ew21tgwww4oryyts4NW43cXcOBRxuh/Ao/L/0nfY6LB+Vc8Cd5/A4UvgqhwXPb06JIDsgwu/BqQ8F2xuL+OZ6krZPdyKaQ7zdNp8EOS4id2iW0dkZPEawq/OZBstwljgRSzklF3USOYcazVdwbelfaUTsOH9aIAU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBL0Vske; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBL0Vske"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422D0C116D0;
	Thu, 15 Jan 2026 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498720;
	bh=vcb8DYub5I7ndI/ak1HH/wHxSCAJH/eudNXlyBxVylc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBL0VskeqxRuqrXmcMrnrzOvYDxvQGMagH7P+z35gSHUikQVo4V9ExUjzzdd+GKvy
	 hOhiUc47qVEIJqyXgRiDrJqdtw92IR5/r97TWr4QxEgUy7HZaIoEsZmcWKDyXY97kK
	 rnDlo6SzhcsJPq8KmCbzw8dGc4sMwsSG6+ExcNpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Amitai Gottlieb <amitaig@hailo.ai>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.15 497/554] firmware: arm_scmi: Fix unused notifier-block in unregister
Date: Thu, 15 Jan 2026 17:49:23 +0100
Message-ID: <20260115164304.308193945@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitai Gottlieb <amitaig@hailo.ai>

In scmi_devm_notifier_unregister(), the notifier-block argument was ignored
and never passed to devres_release(). As a result, the function always
returned -ENOENT and failed to unregister the notifier.

Drivers that depend on this helper for teardown could therefore hit
unexpected failures, including kernel panics.

Commit 264a2c520628 ("firmware: arm_scmi: Simplify scmi_devm_notifier_unregister")
removed the faulty code path during refactoring and hence this fix is not
required upstream.

Cc: <stable@vger.kernel.org> # 5.15.x, 6.1.x, and 6.6.x
Fixes: 5ad3d1cf7d34 ("firmware: arm_scmi: Introduce new devres notification ops")
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Amitai Gottlieb <amitaig@hailo.ai>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/notify.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -1539,6 +1539,7 @@ static int scmi_devm_notifier_unregister
 	dres.handle = sdev->handle;
 	dres.proto_id = proto_id;
 	dres.evt_id = evt_id;
+	dres.nb = nb;
 	if (src_id) {
 		dres.__src_id = *src_id;
 		dres.src_id = &dres.__src_id;


