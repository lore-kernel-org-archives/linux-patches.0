Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A0447A0DE;
	Tue, 16 Jun 2026 17:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630732; cv=none; b=rJoTkJ28g4sLNqlcSrU9ete4OBIA0aDLEXZIQWBrSnUCgRVmgQOCn/MVYnzZCCKRbCJg+gazZ6d9fXB0xFtOWtQ8W2TqN13DxBjNsha6cK4uGf8JcdCi9+KJRVeABff8MHwF1HPJfoendkivg/70uWqdy9pAefq3JW18XT60d8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630732; c=relaxed/simple;
	bh=xtk5XeFiqI9yTk+Gpgd699S94wmeSEBEu4pWWnULLfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjxsPkT7mTP5pjQz7wMvCk7DvqkhDKI2sbtUAIo7Z2+CEB0KX+1a35a94gSg5tlKn7NLSXHzG31w6HjwwkWAf/oH5MDTkCfO+/jpbGMJQsQ3A1VUIBUWmOGhyNYCMLKrN9ytTP8JcmDt0bcHKpdIpDFjd6JSDFpNhqVt0DSNc5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZwPN4Kq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZwPN4Kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC551F000E9;
	Tue, 16 Jun 2026 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630730;
	bh=cQzECBqe/27mkgNhpQ2/FruKdRIy9bX4ZaDpJDkPU8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZwPN4KqACEpZia+qkfLiu/txjk5do/gwV3wsBHOgSVhqAtmFksoas/JYde9VeZ2b
	 Tk7TqWL/HQghux5PhDyDXAOQPrQ6QYIJhBpRue1/RHdSQes3qOQZQz0rc0YYG9IzXy
	 FlhRrtrVvNauWXBnAAftL9xqE3Gct+oMeKt/fs0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 085/522] usb: typec: altmodes/displayport: validate count before reading Status Update VDO
Date: Tue, 16 Jun 2026 20:23:52 +0530
Message-ID: <20260616145129.847178536@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8a18f896e667df491331371b55d4ad644dc51d60 upstream.

A broken/malicious device can send the incorrect count for a status
update VDO, which will cause the kernel to read uninitialized stack data
and send it off elsewhere.

Fix this up by correctly verifying the count for the update object.

Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/2026051350-reacquire-sculpture-4244@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -308,6 +308,8 @@ static int dp_altmode_vdm(struct typec_a
 			}
 			break;
 		case DP_CMD_STATUS_UPDATE:
+			if (count < 2)
+				break;
 			dp->data.status = *vdo;
 			ret = dp_altmode_status_update(dp);
 			break;


