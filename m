Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48EF1514DC;
	Tue,  2 Jul 2024 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941286; cv=none; b=sp++aXdMZ11E/Fx1TnrbgvZxMcqoSMkFJUlHNJ1ZIMD7d6E3oZ7VCC1DCww9HGkWfxdKAp0kpZjT+LHzYuewTGnXkzvg79NcJIMsTR4+MFzwV2h3T2xbKbfdvKGdHyTaZUHmKh5xDew/pXRdfcnEe1fdSoVO8nmt+Qcv84Reb44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941286; c=relaxed/simple;
	bh=rZPyIZHdCdGVWN5wJxOolxUmP/o2impAzFBiKBVYN68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Niagb4fhWh9pdssYphUK62pb1z6uVe9LlYrcdoieiERrx26zN5MqN9jSUzBYzrSBBG7IEv3hwYGPNUi/rs7OyziG2+8SQ6RqFKhDUhdYGN0ILMTwfGJPNIf/LViztVAcIkLfrTncD2ujV/1yJikOp7E1Hv1eHTW8UwxC/3p4k4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shoA9OQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shoA9OQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4344BC116B1;
	Tue,  2 Jul 2024 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941286;
	bh=rZPyIZHdCdGVWN5wJxOolxUmP/o2impAzFBiKBVYN68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shoA9OQLrqgbjySt1SDm0nCRmuXLQ0dmmhssVpm5a3lOc471cnhZccUPR6UyWH8hQ
	 GbBwOqwZuGfFmDCesVz8xcwZ+kzRBrcmON/4abG9yhBELauVswM7HtF845aAE+f+DC
	 CjjmcwDC+IQOaiHUUX3PuxJHjx0kfKCFxjCPliJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ammy Yi <ammy.yi@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/128] usb: typec: ucsi: Ack also failed Get Error commands
Date: Tue,  2 Jul 2024 19:03:23 +0200
Message-ID: <20240702170226.327691447@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 8bdf8a42bca4f47646fd105a387ab6926948c7f1 ]

It is possible that also the GET_ERROR command fails. If
that happens, the command completion still needs to be
acknowledged. Otherwise the interface will be stuck until
it's reset.

Reported-by: Ammy Yi <ammy.yi@intel.com>
Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240531104653.1303519-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -140,8 +140,13 @@ static int ucsi_exec_command(struct ucsi
 	}
 
 	if (cci & UCSI_CCI_ERROR) {
-		if (cmd == UCSI_GET_ERROR_STATUS)
+		if (cmd == UCSI_GET_ERROR_STATUS) {
+			ret = ucsi_acknowledge(ucsi, false);
+			if (ret)
+				return ret;
+
 			return -EIO;
+		}
 		return ucsi_read_error(ucsi);
 	}
 


