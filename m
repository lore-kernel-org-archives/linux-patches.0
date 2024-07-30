Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D224189513;
	Tue, 30 Jul 2024 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357603; cv=none; b=PainxFZvPdL82mwPIaylWUsmgk8MofRcV95cMlmOdJOgSESO4CKFOB8QczolxYf2DnTOr+5z5R4Ak+t1IsAx49K3L+MdOgdg4zjeNJIpd/Z4myC4eNF9ZpuY6sIc1zduExiraPxfP+KAnoz4TetKIq0wvcS0VGx4KthacfF0R4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357603; c=relaxed/simple;
	bh=x+FeiTP98ITJBOiPfRVjZ5X+GfaGbvCWAjE9gJjrg8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOpQ2mQfuCAhoAiZnPKsBmMkW2vOh3hQQl7okiz0a/l5D93iSVlcPwIcnMlv68Z5VRuqbPdsS6D+lAbY7PueTtihqVYsw8+5ykRlM++x3eDJ5HOfA8eavQkUIADFaO4S2QgpKrMzMh+WaEzZtFtRy1nSktstR7JGLUFSn0eNzns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7b6J4vD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7b6J4vD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD3EC32782;
	Tue, 30 Jul 2024 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357603;
	bh=x+FeiTP98ITJBOiPfRVjZ5X+GfaGbvCWAjE9gJjrg8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7b6J4vDU07wuI1hvxJ5ArI+3l6swPeTFdglaJE2HvdtpIfGse6H5xZv1csA9DWod
	 7EOm+8/t//2arQdrnotzqBQuySQMPOqmF1Pc/G4xArNlmvGFQ9w+iNEqCbBVNtbT6o
	 v6BCZlpf6ZJuq6VZjlj88Y3dW9sGySqSNp8mrBSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Beims <rafael.beims@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.1 308/440] wifi: mwifiex: Fix interface type change
Date: Tue, 30 Jul 2024 17:49:01 +0200
Message-ID: <20240730151627.852825154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Rafael Beims <rafael.beims@toradex.com>

commit a17b9f590f6ec2b9f1b12b1db3bf1d181de6b272 upstream.

When changing the interface type we also need to update the bss_num, the
driver private data is searched based on a unique (bss_type, bss_num)
tuple, therefore every time bss_type changes, bss_num must also change.

This fixes for example an issue in which, after the mode changed, a
wireless scan on the changed interface would not finish, leading to
repeated -EBUSY messages to userspace when other scan requests were
sent.

Fixes: c606008b7062 ("mwifiex: Properly initialize private structure on interface type changes")
Cc: stable@vger.kernel.org
Signed-off-by: Rafael Beims <rafael.beims@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240510110458.15475-1-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -926,6 +926,8 @@ mwifiex_init_new_priv_params(struct mwif
 		return -EOPNOTSUPP;
 	}
 
+	priv->bss_num = mwifiex_get_unused_bss_num(adapter, priv->bss_type);
+
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	adapter->main_locked = false;
 	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);


