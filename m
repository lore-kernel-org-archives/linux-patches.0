Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DC419FA7A;
	Thu, 15 Aug 2024 14:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732333; cv=none; b=KqHJYG8uW+SosNCiOcJv/utxOwzAHvHZFqYX6ykeecX1sH9e3Ys91yAHSUK0BFZ8mukSHem7PIsTCu6FQRRJ8zOuvjyc0DDVNKYNebZGbvYNlPQ1DcKyiwo0OaKF5AqBCeUq+SemrGhMh0s8xQ10QwlVfHUr1uPGqSsFa4/3Vmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732333; c=relaxed/simple;
	bh=2gW1jdGzLkh4Bgbr+Y46o6uMQ+AgCBAb/pYxrxl9iqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POxPCzYrJ2PeXXr1eJXP/dyFW5hJOqaqGN5w2EMBlmUNyrfpYzLdhAvHCuv9VvJARyq8rVa3Nnwzmqc3o+j7/ZNv6h69GVJsCCZkxgGDFCX/ImZWgkPdG203xQ7Z2dHLz3349yin3n1V8i214XWsc8qzXpjg17p8HAwviTGhEpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsFh/Cpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsFh/Cpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E76C32786;
	Thu, 15 Aug 2024 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732333;
	bh=2gW1jdGzLkh4Bgbr+Y46o6uMQ+AgCBAb/pYxrxl9iqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsFh/Cplhw8zqDNBkF3ywTsgw6mR0sp8SAow14ppsfxRhVTHOyjhXmt2IDhg8580o
	 O2oxXVmJM6clNAMPX6ncrASUi47+3BezofC1TgOlJr7K5FroIdzxcRed7PcG3+huvu
	 Unpzz7w9fpGBMPXESWeX+4kqR5zoKY3vWb43xa0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Beims <rafael.beims@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 146/352] wifi: mwifiex: Fix interface type change
Date: Thu, 15 Aug 2024 15:23:32 +0200
Message-ID: <20240815131924.903096042@linuxfoundation.org>
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
@@ -930,6 +930,8 @@ mwifiex_init_new_priv_params(struct mwif
 		return -EOPNOTSUPP;
 	}
 
+	priv->bss_num = mwifiex_get_unused_bss_num(adapter, priv->bss_type);
+
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	adapter->main_locked = false;
 	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);


