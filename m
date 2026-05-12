Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E99F3EDE61;
	Tue, 12 May 2026 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609251; cv=none; b=bN4s33gUcpvo2/XATJCuDYLLBEMh/3pCic/ZOHqMLLoYTyyTtCLNsFhcL3mwbx7ZQe9YjPsz/qAujrdv6NoYGU99WQcDVWg9l5F/fg++uwLnEgKnp51Vor5oLS7BoVOqiLDIpcRIfs/I0LzFVNPGq1iXJ2jbHqRcfp+EOVo+9kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609251; c=relaxed/simple;
	bh=fjWl35r4hzu/U9H34lxBzqyqP4daZ3sAeNbhhrInrjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0zCgwBAVk7kAuE00dkuBlIYsY5PsNANBOoF23EzC9+DmnHoQa80kavpMpqEMe0Qfx96CvmzHDNATe5STcfnRQYvl7w8t5/WixbQ1dydygMrq7OY2DrzK0xpeJsNbovt0mkp4iENuh7cSGCZtxQ17RTi2i8Y3zw9NqylztEJaN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqJwmxlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqJwmxlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36656C2BCB0;
	Tue, 12 May 2026 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609251;
	bh=fjWl35r4hzu/U9H34lxBzqyqP4daZ3sAeNbhhrInrjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqJwmxlu5IlmTQNBwj0Vz3bR1fRWrIpYeziIFv2m+qxSTyOENd8KtGUMguCuthNAH
	 oxXkW1b2ySMDZlpzOxmTRqWA0FF0iWaN05rh3XACvrXXO7a5HdmI9AZtoi3bd6jdN2
	 9TuTUtJ2WcFdLgPoGvXsps1TD0vGqI3W0xiF0uDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 7.0 124/307] platform/chrome: cros_ec_typec: Init mutex in Thunderbolt registration
Date: Tue, 12 May 2026 19:38:39 +0200
Message-ID: <20260512173942.745707003@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 525cb7ba6661074c1c5cc3772bccc6afab6791ef upstream.

cros_typec_register_thunderbolt() missed initializing the `adata->lock`
mutex.  This leads to a NULL dereference when the mutex is later
acquired (e.g. in cros_typec_altmode_work()).

Initialize the mutex in cros_typec_register_thunderbolt() to fix the
issue.

Cc: stable@vger.kernel.org
Fixes: 3b00be26b16a ("platform/chrome: cros_ec_typec: Thunderbolt support")
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Link: https://lore.kernel.org/r/20260505053403.3335740-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_typec_altmode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_typec_altmode.c
+++ b/drivers/platform/chrome/cros_typec_altmode.c
@@ -359,6 +359,7 @@ cros_typec_register_thunderbolt(struct c
 	}
 
 	INIT_WORK(&adata->work, cros_typec_altmode_work);
+	mutex_init(&adata->lock);
 	adata->alt = alt;
 	adata->port = port;
 	adata->ap_mode_entry = true;


