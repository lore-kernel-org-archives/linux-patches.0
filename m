Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0800923CE;
	Wed,  7 Aug 2024 15:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043698; cv=none; b=FcfKzf6lB50UlwGGBGKETg/vXxFQG0UhECrrIo94GEfLRS/uh3xQvnm0XycQkVJqXFlahu/mKJivqzjcV0WawuCWmkQFRM/7X1CYLK2RAJbtgzg+HsZkiysbSjiky4NxHNlMUnhH4/NXqua/IF3YLm6OlXTvjpzB1YeTSu1YKks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043698; c=relaxed/simple;
	bh=VegMAM3cSjWzkB5OwZeIQ3+NjNxl0/yPVhOe6r3TFI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+Vxd6EgVho6nksGi7lwHpso5bFfukUMO0amXDT7gpvbOvQLxOkfkmCZeNxhN4UegGEXIRk8awPjdn31IGbWzjDGM1HtTiWzxa/T+0vHj+MKiqCB7poDGX93hB436drj8xP2QxTy1eka/ZrLeVPMP1KULajMofG34X9fq+va658=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2ydrCrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2ydrCrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5DEC32781;
	Wed,  7 Aug 2024 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043697;
	bh=VegMAM3cSjWzkB5OwZeIQ3+NjNxl0/yPVhOe6r3TFI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2ydrCrEETVoix5qJ0dwQDgI25xwfFcok+taY4jyqzHc1IMKvjVCp2suAbq87QngB
	 1ylLi4EWYr7tquGvxz7eaZu7jXwgr4okpZHAK4+dJoi344rHRQRkpqLUNanITjLn/z
	 UVTazxrjW2a+h7NSVViCH8GX9wXib/snSrD98JZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Duda <patrykd@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.1 67/86] platform/chrome: cros_ec_proto: Lock device when updating MKBP version
Date: Wed,  7 Aug 2024 17:00:46 +0200
Message-ID: <20240807150041.470892509@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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


