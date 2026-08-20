Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFDD47D463;
	Thu, 20 Aug 2026 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243569; cv=none; b=PwqH0ETJniVY1IKVJ1N4b1YIMPf04wDhcsWM72E0qU99N/b+QayQesOcLez9/5UngEyvE8mcctW/PfO1f+XBlfOAB4haj6P7mlRHrd+pH74FJY4E3KW7YfYbAWW+1mDwxAaXhVmdzs4zFWC/6MQFGiBxr53cE55S+TL7kDoDn2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243569; c=relaxed/simple;
	bh=pG0jbreZErTIeIC90wH9gQYTyp8Jw+TmurPGyNglot8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbR37fI/Jp+T5nuhl6ezYlXD05zDQwMSXE+TpPWeAB5gGOjk8+JdnnqxmRjuXXJVTWKPDzM5Jz8X5tCH0Vc0kiOPgmZD4J8G64dZDHVLnlhLw7OJRqwH56sPDB5HPOEbe+PAmi9AKsByikwv4++NSQbeIM+bcIXhapgrn+X7aZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKPDTDhZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKPDTDhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FCD1F000E9;
	Thu, 20 Aug 2026 16:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243567;
	bh=bdpQ7w/VYLnEav4y8QXU191OAAoe4V2MWwGpxDmLgss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKPDTDhZYXBcmOBqELa8ookUeWzitXf1CSRMkv3OTvGWk7vdMkB2Ldq/CThQFLoMn
	 SepigTCgNuSF/hv6lLd6yz5SavpMSD4rcvdMxaGTcJrar3gvuQg2uTBN1Sspcuuq7P
	 jzjYBS34SaEy/O+VOIAlFxqmNgdYk7cTh42XB6BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/272] Input: ims-pcu - fix firmware leak in async update
Date: Thu, 20 Aug 2026 16:55:23 +0200
Message-ID: <20260820145235.456661338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit d48795b5cd6828d36b707e8d62fc9e5c90e004ab ]

The firmware object was not being released if validation failed.
Use __free(firmware) to ensure the firmware is always released.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -964,9 +964,10 @@ out:
 	return retval;
 }
 
-static void ims_pcu_process_async_firmware(const struct firmware *fw,
+static void ims_pcu_process_async_firmware(const struct firmware *_fw,
 					   void *context)
 {
+	const struct firmware *fw __free(firmware) = _fw;
 	struct ims_pcu *pcu = context;
 	int error;
 
@@ -987,8 +988,6 @@ static void ims_pcu_process_async_firmwa
 	ims_pcu_handle_firmware_update(pcu, fw);
 	mutex_unlock(&pcu->cmd_mutex);
 
-	release_firmware(fw);
-
 out:
 	complete(&pcu->async_firmware_done);
 }


