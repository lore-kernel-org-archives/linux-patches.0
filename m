Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD19F28E03
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5FP3eHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D855C433C9;
	Mon, 16 Oct 2023 14:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468264;
	bh=XlFqW98FNn+bLAShPUjwImg87MJ+T7lbcFrz0D7ezXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5FP3eHU5ZcJlzERFDXK0UBnMXPZprjwU6rVz9vxdmVwoCDdjcjKQmWw+SjxrW4lv
	 pGJbRNQzeQNceT2nekdNqn2pihnw6VBODYksFwt0eot97bqSxtyrlvt25IAI0t2aif
	 zSDaNfqFMkrFhkW9ATuoLdpZdJD+JKcNg38hG0qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.5 175/191] usb: typec: ucsi: Clear EVENT_PENDING bit if ucsi_send_command fails
Date: Mon, 16 Oct 2023 10:42:40 +0200
Message-ID: <20231016084019.460292543@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit a00e197daec52bcd955e118f5f57d706da5bfe50 upstream.

Currently if ucsi_send_command() fails, then we bail out without
clearing EVENT_PENDING flag. So when the next connector change
event comes, ucsi_connector_change() won't queue the con->work,
because of which none of the new events will be processed.

Fix this by clearing EVENT_PENDING flag if ucsi_send_command()
fails.

Cc: stable@vger.kernel.org # 5.16
Fixes: 512df95b9432 ("usb: typec: ucsi: Better fix for missing unplug events issue")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/1694423055-8440-1-git-send-email-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -885,6 +885,7 @@ static void ucsi_handle_connector_change
 	if (ret < 0) {
 		dev_err(ucsi->dev, "%s: GET_CONNECTOR_STATUS failed (%d)\n",
 			__func__, ret);
+		clear_bit(EVENT_PENDING, &con->ucsi->flags);
 		goto out_unlock;
 	}
 


