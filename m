Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C67386C21;
	Sat, 12 Sep 2026 12:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215464; cv=none; b=rcMKKg4tHugBL5tedux+91bA0bZG5a2vgVGUqXixx/TkvbJtyqqyp8oAVapw8RC7fZ9vkXzSwlXvq+3UN0S/byZsKy3yQbPDvDRN5uuWyigBr4qFD4O4jWSwS1jmsiQ1Aqj+SvmkqkP1nTIb/EzfsCeQgh+zjhu2gZ3PFM1Tx7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215464; c=relaxed/simple;
	bh=4ZsEvf9X0iBkca/iY5xhddIE3o7H0LMstYFBBk2uu8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBo4LG17z5n+RvxDvrudVpdqDzHauQuEYr3n9Q4gOD8tPw8JWmIx13ddtXqosXCkr50sBDOnQY4sFFCTC89azXaaSHF/3973CtjoocEUgogM3LlRiYAdQbsTBzXyhzeRv+OhyfGhd2QqZjiw5cTBtruZkm+1tm6zGNdYw2fbiGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlFuQjRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlFuQjRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FB81F000FF;
	Sat, 12 Sep 2026 12:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215459;
	bh=/btWg6EKEvaXNK07WXXHpHz7F6LA8rRRU5CUTo0gsXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlFuQjRNs0LZ+5zn5W1MhQf3tVE4IMO+JyI7SdI7bMSmT1hqrUWrEtnEsU/mT1ms8
	 fe9xIwPWgXj83SL2NNpobPHoQtXUHS1yAHKr7mUq1assa2FO1m8OxHYYPKDA+6hn+P
	 LqHKk7YgCGRLjkn1ScBKpf2O6KC+nH9EQqMYmnAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0536/1376] firmware: arm_scmi: Clean up channels on setup failure
Date: Sat, 12 Sep 2026 08:49:22 +0200
Message-ID: <20260912065619.488331946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 687d67be3d87894ef12e8a164434612e0b53cfae ]

scmi_channels_setup() can fail after the common BASE channel or earlier
protocol channels have already been registered in the TX/RX IDRs.

Route this failure through the existing channel cleanup label so the
transport channels, transport devices and IDR state created before the
failure are released before the probe error path frees the SCMI instance
ID.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-4-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f69b8e2697415..5a44e10ed6041 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -3114,7 +3114,7 @@ static int scmi_probe(struct platform_device *pdev)
 	ret = scmi_channels_setup(info);
 	if (ret) {
 		err_str = "failed to setup channels\n";
-		goto clear_ida;
+		goto clear_txrx_setup;
 	}
 
 	ret = bus_register_notifier(&scmi_bus_type, &info->bus_nb);
@@ -3228,7 +3228,6 @@ static int scmi_probe(struct platform_device *pdev)
 	scmi_notification_quiesce(&info->handle);
 	scmi_cleanup_txrx_channels(info);
 	scmi_notification_exit(&info->handle);
-clear_ida:
 	ida_free(&scmi_id, info->id);
 
 out_err:
-- 
2.53.0



