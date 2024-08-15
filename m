Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E756B19E7F6;
	Thu, 15 Aug 2024 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730222; cv=none; b=RM3MQ9VeZ9izv6uNQL4yBqoNXT0geY2pg/HkgE2L+U/fQ/Eg417zPheKCek0eKdzKXUNFDMPnVdfBKG7InkQfvJJErOc0GaDhY74e76Qsj0Wy01Ugt2x31UtTqsR/nbVYTVreot4pSSTBPL36RRltnIT/sXehMroTdzOx4UVDHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730222; c=relaxed/simple;
	bh=1uRcZUtvmbPEy/OEokSqMsKuikeKCK165wXdXTVqtLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZfvXFCI3eOODdTQNQf7OvkNNWJGV1oSg48tqOfFXGCURHP4nbG9OtZS9iJKjwJlaUfTdn/lO3U4ZWdb7uZeKzG/aFRD7a+1yqSguqdyps70U7ErdyTAGTAni/nAYnNbMZ4ulBx5moGetkOpkOP/DAuXWSzrYDBVVJWull4xhuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULInLkjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULInLkjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF3DC32786;
	Thu, 15 Aug 2024 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730221;
	bh=1uRcZUtvmbPEy/OEokSqMsKuikeKCK165wXdXTVqtLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULInLkjMPJZvFzC9JzKwY/RfcXopi41vTpnSOVUK/LIgm5pLJrw0Ec0qiI9Kx1Web
	 UqAJ4GvNVMvjHgv8ke+mn8g0L3h/mRtz7bH3uV4caAUgHEqAgmC7gPCy7BSbyyHzPg
	 yw8Xv1Xsa/6/8XggkkVcBe4/I4lRrGLCF5GH2wWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Duda <patrykd@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.15 342/484] platform/chrome: cros_ec_proto: Lock device when updating MKBP version
Date: Thu, 15 Aug 2024 15:23:20 +0200
Message-ID: <20240815131954.628319924@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patryk Duda <patrykd@google.com>

commit df615907f1bf907260af01ccb904d0e9304b5278 upstream.

The cros_ec_get_host_command_version_mask() function requires that the
caller must have ec_dev->lock mutex before calling it. This requirement
was not met and as a result it was possible that two commands were sent
to the device at the same time.

The problem was observed while using UART backend which doesn't use any
additional locks, unlike SPI backend which locks the controller until
response is received.

Fixes: f74c7557ed0d ("platform/chrome: cros_ec_proto: Update version on GET_NEXT_EVENT failure")
Cc: stable@vger.kernel.org
Signed-off-by: Patryk Duda <patrykd@google.com>
Link: https://lore.kernel.org/r/20240730104425.607083-1-patrykd@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_proto.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -780,9 +780,11 @@ int cros_ec_get_next_event(struct cros_e
 	if (ret == -ENOPROTOOPT) {
 		dev_dbg(ec_dev->dev,
 			"GET_NEXT_EVENT returned invalid version error.\n");
+		mutex_lock(&ec_dev->lock);
 		ret = cros_ec_get_host_command_version_mask(ec_dev,
 							EC_CMD_GET_NEXT_EVENT,
 							&ver_mask);
+		mutex_unlock(&ec_dev->lock);
 		if (ret < 0 || ver_mask == 0)
 			/*
 			 * Do not change the MKBP supported version if we can't


