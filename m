Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FC71F8684;
	Tue, 17 Dec 2024 17:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456507; cv=none; b=U70QmmZRumCWlsnelG2jXxrbg3jg0pPJlLrCdTDpshhnuVKw0P7rI+6+ZV0QlGvVBaLLYiBrHvSgFUE2Vls0FSignfGA/B/O6eNaidWK8ur3h/3hDhieHSQfpDdJVpFRHxv2+wTRufWmA9dSJ+M1Ug7xoqDkZp1NtkMeI5C9Y94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456507; c=relaxed/simple;
	bh=nYYH3dKO7ecUtYEP5soDNg7kTa8eyhKXTv+yvqKwWcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FXx4kQjT1gmn8NQEnmyTXYztraFDhe2IgOSPF1tlxsYbevo/NrICoKTApUGYLwtOKF6fFvuVdoT/hLx32IqprW7FFLsDNNPwaEZvLE7UVoV5Oi3syhbYgp/6i71JCmuoRVCx4nfNNmHZLqMk1Z2HkF5RN4nT44lUJLEUxb3wB/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlNlFNPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlNlFNPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FA7C4CED7;
	Tue, 17 Dec 2024 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456507;
	bh=nYYH3dKO7ecUtYEP5soDNg7kTa8eyhKXTv+yvqKwWcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlNlFNPSVqlE7tIGoyR9eNN4IXcZh1gQ9JFss0Im21MOsolDLPb5jnbOGDWP8QdO0
	 c/nB2/KD1Up9sacGYUVO6hRHM+5QbKCPDVQ4ldphrB6CXKLlw2qwp7nXJdXVQtLJti
	 NlR9sps5pI5U8nIpJ/a7O8KEtxoYgcaE7pV9evrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.12 051/172] usb: typec: ucsi: Fix completion notifications
Date: Tue, 17 Dec 2024 18:06:47 +0100
Message-ID: <20241217170548.384791168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Bartosik <ukaszb@chromium.org>

commit e37b383df91ba9bde9c6a31bf3ea9072561c5126 upstream.

OPM                         PPM                         LPM
 |        1.send cmd         |                           |
 |-------------------------->|                           |
 |                           |--                         |
 |                           |  | 2.set busy bit in CCI  |
 |                           |<-                         |
 |      3.notify the OPM     |                           |
 |<--------------------------|                           |
 |                           | 4.send cmd to be executed |
 |                           |-------------------------->|
 |                           |                           |
 |                           |      5.cmd completed      |
 |                           |<--------------------------|
 |                           |                           |
 |                           |--                         |
 |                           |  | 6.set cmd completed    |
 |                           |<-       bit in CCI        |
 |                           |                           |
 |     7.notify the OPM      |                           |
 |<--------------------------|                           |
 |                           |                           |
 |   8.handle notification   |                           |
 |   from point 3, read CCI  |                           |
 |<--------------------------|                           |
 |                           |                           |

When the PPM receives command from the OPM (p.1) it sets the busy bit
in the CCI (p.2), sends notification to the OPM (p.3) and forwards the
command to be executed by the LPM (p.4). When the PPM receives command
completion from the LPM (p.5) it sets command completion bit in the CCI
(p.6) and sends notification to the OPM (p.7). If command execution by
the LPM is fast enough then when the OPM starts handling the notification
from p.3 in p.8 and reads the CCI value it will see command completion bit
set and will call complete(). Then complete() might be called again when
the OPM handles notification from p.7.

This fix replaces test_bit() with test_and_clear_bit()
in ucsi_notify_common() in order to call complete() only
once per request.

This fix also reinitializes completion variable in
ucsi_sync_control_common() before a command is sent.

Fixes: 584e8df58942 ("usb: typec: ucsi: extract common code for command handling")
Cc: stable@vger.kernel.org
Signed-off-by: Łukasz Bartosik <ukaszb@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20241203102318.3386345-1-ukaszb@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index c435c0835744..7a65a7672e18 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -46,11 +46,11 @@ void ucsi_notify_common(struct ucsi *ucsi, u32 cci)
 		ucsi_connector_change(ucsi, UCSI_CCI_CONNECTOR(cci));
 
 	if (cci & UCSI_CCI_ACK_COMPLETE &&
-	    test_bit(ACK_PENDING, &ucsi->flags))
+	    test_and_clear_bit(ACK_PENDING, &ucsi->flags))
 		complete(&ucsi->complete);
 
 	if (cci & UCSI_CCI_COMMAND_COMPLETE &&
-	    test_bit(COMMAND_PENDING, &ucsi->flags))
+	    test_and_clear_bit(COMMAND_PENDING, &ucsi->flags))
 		complete(&ucsi->complete);
 }
 EXPORT_SYMBOL_GPL(ucsi_notify_common);
@@ -65,6 +65,8 @@ int ucsi_sync_control_common(struct ucsi *ucsi, u64 command)
 	else
 		set_bit(COMMAND_PENDING, &ucsi->flags);
 
+	reinit_completion(&ucsi->complete);
+
 	ret = ucsi->ops->async_control(ucsi, command);
 	if (ret)
 		goto out_clear_bit;
-- 
2.47.1



