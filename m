Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9585019FA7A;
	Thu, 15 Aug 2024 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732637; cv=none; b=R7acHpX9xMXmQaG5UtWM9C7NdBrMmAJau6cexpqNWQwDQHjHhQ9d1ULuBko8iJbAzjBI/WJR2qySRU92vejyMgIoY7IWNjqrndhFCx6kmuBixqx+xBPpC4cKUDzhvgd3p9V9+XsSPwrLJ/WDg0c8TpieQjVYMf6Ar2ldy09QrQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732637; c=relaxed/simple;
	bh=umC9I5Vc8JKPiyf9AtrCNvEtqqR3T2TGCDvAg2lhFBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgwc8D7yb8WbKeRc+TLwLTsjIRBlKbO2on6H7Tgd/RPVJBuDsQNL8BInD5jsnBAZOTKBHv9IFoafy/VbEbbajUUWnjhEyQLpj0FfQl9jS/E9WZpO0/PZcwfCpG3eGPq9sOnRQ3Ku2JVDHgFInsYt4VOCgqbVYTZ99qDwEg1fDj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJGcPnxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJGcPnxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1871AC32786;
	Thu, 15 Aug 2024 14:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732637;
	bh=umC9I5Vc8JKPiyf9AtrCNvEtqqR3T2TGCDvAg2lhFBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJGcPnxS6Ocswr2QGElh9+axT1HF9du6B/Ttq94drh0fP4eYY94aPyi/9YUm2Zosy
	 gy/Hs5xAxvo75jAcZ2oOnumnKtpx5VnMvHUyTujPuLWGd/S43J/tVHmF8QZAqjY0YC
	 48+GJS/wijFhrNtALejhNmFPL+T3R9ZKSwT6WlOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Duda <patrykd@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.10 240/352] platform/chrome: cros_ec_proto: Lock device when updating MKBP version
Date: Thu, 15 Aug 2024 15:25:06 +0200
Message-ID: <20240815131928.713536149@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


