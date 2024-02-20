Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038B014AD12;
	Tue, 20 Feb 2024 21:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463549; cv=none; b=oHHKiSFoxqRuEb9AWBhiXBkTysp+rRbLH6gDGO6aWIwWayRIizn1duUi7HqHNFTQITolT2Uwy3A+7voHdQdlakqiPRsdJcLna4snbIi5CLkHmMgubwI33VGBo/U138PyDb5T4VWSfa5dYhpgBqFCg+qWTvP1xfrQCjxGHhbDDqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463549; c=relaxed/simple;
	bh=4qGCWFGY7hoRfdoLiOTexrXHeTBLvR1husl6tSC2gF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYPWrWTjgw6840bJniF4rBYRwYgBedeHKGFszQcw4tEpkvvkBnkigU9BAe9NyhXvPbw7W5k9OtnckyrPHk3N55b0f4iHmdN5SmkFhbqTtXrmnCtlFkDzToTDV6Gw/3KYMUlIpZe3LZbgWfFJqofuBUnIJdEH9IQFX7rohIXXiCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVX2Ztz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVX2Ztz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C1CC433F1;
	Tue, 20 Feb 2024 21:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463548;
	bh=4qGCWFGY7hoRfdoLiOTexrXHeTBLvR1husl6tSC2gF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVX2Ztz8Hj4RXliv/f7csSjK/kjPkeWz1bElYpsTwaflOkpeSu7M5cuB6MaCwPFRQ
	 C9g/2iyuMcKr7ZqLGYDtBBpCYHjK1dxJ2OVN2VbqT7SwDGiLwnDTmNs2Bv6Peq16k5
	 O65lfRXar5BXF107ni3Z6gcd63JUA3A6bQWJo4jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 077/331] usb: ucsi: Add missing ppm_lock
Date: Tue, 20 Feb 2024 21:53:13 +0100
Message-ID: <20240220205640.000139260@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit c9aed03a0a683fd1600ea92f2ad32232d4736272 upstream.

Calling ->sync_write must be done while holding the PPM lock as
the mailbox logic does not support concurrent commands.

At least since the addition of partner task this means that
ucsi_acknowledge_connector_change should be called with the
PPM lock held as it calls ->sync_write.

Thus protect the only call to ucsi_acknowledge_connector_change
with the PPM. All other calls to ->sync_write already happen
under the PPM lock.

Fixes: b9aa02ca39a4 ("usb: typec: ucsi: Add polling mechanism for partner tasks like alt mode checking")
Cc: stable@vger.kernel.org
Signed-off-by: "Christian A. Ehrhardt" <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240121204123.275441-2-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -935,7 +935,9 @@ static void ucsi_handle_connector_change
 
 	clear_bit(EVENT_PENDING, &con->ucsi->flags);
 
+	mutex_lock(&ucsi->ppm_lock);
 	ret = ucsi_acknowledge_connector_change(ucsi);
+	mutex_unlock(&ucsi->ppm_lock);
 	if (ret)
 		dev_err(ucsi->dev, "%s: ACK failed (%d)", __func__, ret);
 


