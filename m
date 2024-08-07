Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0133A78C92;
	Wed,  7 Aug 2024 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043448; cv=none; b=d4Luke91mcbCpiFt1myPtiyv69C/tz3W1HMMJp4NKLvuUI8Qmv8n+EdBpr36FN3CbJKjLJFikEjEFzNK/0dZR3PU2x5jIQJPoaMtgeVkRlGQH4ORRx3dvR2vUt8vsBNiTFOqqzrLVacxbuDvdtfvt5eMHfej8tItK9OvHRLoM/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043448; c=relaxed/simple;
	bh=1NsnYChWPz9cRW19nEMOpl5/wENPO3Mn2JfTaqMjBUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tO6lCsBw3Jtw89+HABmi/BsdXjui3AgUIEoJmotUh/O3wD69B8mQBPG7YueYCoPU6cuvXe7ur9xi6ecermIxlpV+GKHeqPHTHpAQUChOzDVwIsW9xo9o6kKaXA5BwB4j8UUNPG7kM3xLgZspjWsY+M5ZhDIcnLOncs6rYkvOtWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bsuv4Z3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bsuv4Z3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84796C4AF0B;
	Wed,  7 Aug 2024 15:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043447;
	bh=1NsnYChWPz9cRW19nEMOpl5/wENPO3Mn2JfTaqMjBUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bsuv4Z3v7/Hp2ULr9oH1UBZpKRMRLYEo47o+skc+jPLZEfKxA16Ke/2V2+SGnocqf
	 ebcghAZQulNG6gvqlylWiAiQ2xEuUMefPvnKZYQc8IOcVWAp/OHQU2RTDvLXtySA5K
	 EgNWrVMs3YL61MjTEAeV7jY7v2zye4+r6h9/h0Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Duda <patrykd@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.6 095/121] platform/chrome: cros_ec_proto: Lock device when updating MKBP version
Date: Wed,  7 Aug 2024 17:00:27 +0200
Message-ID: <20240807150022.501806782@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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
@@ -805,9 +805,11 @@ int cros_ec_get_next_event(struct cros_e
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


