Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56093C1FFB;
	Thu, 15 Jan 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498095; cv=none; b=GTYm0ntSkKAdBq32vCoUlFf744OfUMkbTqhhP9lqLaqc4E0qdXsZKWJUoE6dJE2JnFFUZlPldhQ8kiFnJq0sSaO5QAXz+o9dsv6HmY+yCp0wCiCpqc9DwbdftoeHTrp+XGPQj73u9LR0f3sLVQ3kb87k2QZERsE9rV7H0nKo4Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498095; c=relaxed/simple;
	bh=41jvnbtUkZeh754hjDlMEWd+CxTyJSkITBdrY/Wv3Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+1JWQWDyBjdZdHG+MX2l1hnGn+Vxrnlg9Md5DtDULCWaBospvBny8CSRU7EGvdOtcebFSlV8grU1yGMdmA7Hw9IkhMzlhDjRawt5mRZ0dR1y8gClA1VBbkPVN54L+am7/UyPNE0Q4R6iCz5UFcbZ/orRDcp3wOJVyidUIf21Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqwmEeCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqwmEeCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9B1C116D0;
	Thu, 15 Jan 2026 17:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498095;
	bh=41jvnbtUkZeh754hjDlMEWd+CxTyJSkITBdrY/Wv3Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqwmEeCPClgrKTz9FTRXxWwggV07rz96Dg06TnAszP/wwQK5bsxh4d3RE4VhV2Awc
	 wgQ2OFc9/lX4eLzFw2X4RM8LuDiR0JUS1+qGpSRIXHQkA5u5UnkFAMibyO3GDm7M0M
	 KFulh9wdaW3T+s2+qXRY6ZvE/3DKxJus7dnOaD7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.15 310/554] platform/chrome: cros_ec_ishtp: Fix UAF after unbinding driver
Date: Thu, 15 Jan 2026 17:46:16 +0100
Message-ID: <20260115164257.452519277@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 944edca81e7aea15f83cf9a13a6ab67f711e8abd upstream.

After unbinding the driver, another kthread `cros_ec_console_log_work`
is still accessing the device, resulting an UAF and crash.

The driver doesn't unregister the EC device in .remove() which should
shutdown sub-devices synchronously.  Fix it.

Fixes: 26a14267aff2 ("platform/chrome: Add ChromeOS EC ISHTP driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20251031033900.3577394-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_ishtp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_ec_ishtp.c
+++ b/drivers/platform/chrome/cros_ec_ishtp.c
@@ -710,6 +710,7 @@ static void cros_ec_ishtp_remove(struct
 
 	cancel_work_sync(&client_data->work_ishtp_reset);
 	cancel_work_sync(&client_data->work_ec_evt);
+	cros_ec_unregister(client_data->ec_dev);
 	cros_ish_deinit(cros_ish_cl);
 	ishtp_put_device(cl_device);
 }


