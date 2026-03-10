Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034473876A1;
	Tue, 10 Mar 2026 11:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142014; cv=none; b=ZqYo3xFBsIY7vTYVAe5VNIPayYHLR+eswcGT68ZH+rpe/K8o6etI+yKEffWWC85B0q/NDonRHPR8H6WUP8p5Ns9TyvdZYzZamGueyCGA9WHUHbWaHpW32IY2418zVuhE+o8SblkbRWUP/T+BJniXDpHn5DFJiqyIJDgx4ZFC14E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142014; c=relaxed/simple;
	bh=bC5TM00ugOf7Sg7GBqoMgxy5IYdenIHc9AHfMSq+jQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imftNBloXwWkjgi+ggfagL93ARi7bcLcxVqkmaWQW0bhsUiiIpOZVmHQ4rreQqaz4H3+9R16QamTSePI5WJgicaBsS/IBPgkPDFJpD4918ibW6oiwMcurRrNK92GqhWhj0tdPdOiyLX9eSW4UPqLXielDVvJrP3jSjM4Hs0rn58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dwmbm1ZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dwmbm1ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18730C2BCAF;
	Tue, 10 Mar 2026 11:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142013;
	bh=bC5TM00ugOf7Sg7GBqoMgxy5IYdenIHc9AHfMSq+jQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dwmbm1ZNEYtqQ2cT27x9WtSqrvjefElsftzLa6Q57CWvjh+tFElvBBizJWo8A463E
	 Ek7KqEwauzGiyVHdD4+oFYmY5B3i1eKmXun5RPSJs662xwE6vUMs7KGqIpGhX+p+0r
	 WLk3pI2j9VlF7dbWK0hx65c+e5TbAkdaX6UFmI5Eazp/qhdorqNQlR7520OJt7OGu2
	 pK7Xxcg28T3hYjp92TpYS3XwX/f5KTgmqFJgcROTE96359EMsmAfyIK2R481jjjoPy
	 3EHEWdJY69951s+AVlPfTRJjp8ITx+UPLarQ90GO4nOVRA4qMbdqLTb+tEwRQ1gLFN
	 3VIlwUf6v6IqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	stable@kernel.org
Subject: [PATCH 6.18 140/314] can: usb: etas_es58x: correctly anchor the urb in the read bulk callback
Date: Tue, 10 Mar 2026 07:16:39 -0400
Message-ID: <83ecfabbe5b2ce856fec101ecb4f61013797f15e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5eaad4f768266f1f17e01232ffe2ef009f8129b7 upstream.

When submitting an urb, that is using the anchor pattern, it needs to be
anchored before submitting it otherwise it could be leaked if
usb_kill_anchored_urbs() is called.  This logic is correctly done
elsewhere in the driver, except in the read bulk callback so do that
here also.

Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Tested-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/2026022320-poser-stiffly-9d84@gregkh
Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 6eeba9baa1317..1e44bd1dfee9b 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1461,12 +1461,18 @@ static void es58x_read_bulk_callback(struct urb *urb)
 	}
 
  resubmit_urb:
+	usb_anchor_urb(urb, &es58x_dev->rx_urbs);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV) {
 		for (i = 0; i < es58x_dev->num_can_ch; i++)
 			if (es58x_dev->netdev[i])
 				netif_device_detach(es58x_dev->netdev[i]);
-	} else if (ret)
+	} else
 		dev_err_ratelimited(dev,
 				    "Failed resubmitting read bulk urb: %pe\n",
 				    ERR_PTR(ret));
-- 
2.51.0

