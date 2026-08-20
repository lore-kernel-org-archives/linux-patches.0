Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2112E47D449;
	Thu, 20 Aug 2026 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244298; cv=none; b=Ss/WAFxhV95yB/wx3JlJSR95tQjhPET0YM6goFa5i/JCqMruSwyvFPv38JiHBvRrNvq4r6ofLtxvtJpZgx2LfKUPdS6y/az8SyTVjAAJrpdTjjm1YWh5mwpPNvzb9SwyzpVtsS3y2/5osrabPMIG4OXE3JM2ZoGAHTAA9VQNa4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244298; c=relaxed/simple;
	bh=fWVM3KCecC6sY7OG53Ftenpy7d0zDXruRNUVUmLixjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ2GIid9JDO2IvjSMwOffcrwy8l/VUFKWc5bbneg04igW0B8ra8yT5sS3ccHvmUtie2JxQciz8cRL6kKHDHbEu3S/TnizgWFLFFIY8GoK0xFWyhpg8n4sVDtVikFSKwn9mFvxy7Mp1MwpmHY5XfDtbl/8KXkE8Fi+Ct9N8iLu+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEIOWSKW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEIOWSKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0471F000E9;
	Thu, 20 Aug 2026 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244297;
	bh=XRYy4IjZ9ewUIFDQnUJeScJYPDu02eXuGnvcDtWBCGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEIOWSKWFGQgAHkdVDFwP9SxKVK1zZxqY1sMgvHyn/PNqeaDYPtFFswE6NnVUsW6b
	 /HJTbJRRjgbFXxlj+lKqcG37d9WYPyh6gYFxEU8PG+NgAjYjNxQa1g+rbiK/+gUZAZ
	 qcK+J+fbKrEzCURBhJLyogEEGAXF6uJ1x7JAJ0p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/235] Input: ims-pcu - fix firmware leak in async update
Date: Thu, 20 Aug 2026 16:55:56 +0200
Message-ID: <20260820145220.085897791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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


