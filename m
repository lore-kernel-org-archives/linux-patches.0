Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C053DD85D;
	Tue, 12 May 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608505; cv=none; b=fBjIu1/igENE8Qjn4MzFTZNDGpcHQGCF3jAto//pkw3JgIIUwUTo4LJKGAUzH4hU978lKq8wMbvoLLuQzq0qn5OL8KjStMzllUhz3JMreFuf5BmtF3imyugmvLBph26yM4BMd9TOFHMRMuP3IgGCau3MiId9NbDAyaSp+Ox7uD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608505; c=relaxed/simple;
	bh=19ZGOYFFI43BFXUUEWdbn0yxyPZ4g4ZjP9b6PN/9SQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tncEt1BEnUeQDWcavHULRaNUZHjYX0TdUkPXxxJw9jS2L2kqG8oO3c6ub17vbKsViZZ5W0mDm7A0Xmb9RNQWt6j6gaDjUrFCKDLM/XzlQFo6pbq90x8of5tbAKLK3k9/rUUs89mHGn7papYpRMkGGsxGM1Rqq0LY09b2hXZ4ypw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRqtUXH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRqtUXH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C21C2BCB0;
	Tue, 12 May 2026 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608505;
	bh=19ZGOYFFI43BFXUUEWdbn0yxyPZ4g4ZjP9b6PN/9SQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRqtUXH0u0Sxc/pxf4C64Y8Wqoa737YxbICNelj+9qqlX8Xrp15mxQyDkrAfK0/tT
	 pweShvZZcbtiFTXmhcn6fo7oU12JwKs/ur6PRKC5GHwvsC0V87mz8M9w2bzI8cmE3O
	 rd87TwBtqZKRwJL3wZcg1+zmvw+N9xRJNbYTHRMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.18 105/270] platform/chrome: cros_ec_typec: Init mutex in Thunderbolt registration
Date: Tue, 12 May 2026 19:38:26 +0200
Message-ID: <20260512173940.669589128@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


