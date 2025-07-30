Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB1A4A32;
	Wed, 30 Jul 2025 09:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869083; cv=none; b=mjleJ8E0F0o7rFD5ba64IpaG9Fm3Ne1VMiExW9ydyT6+InHvk/UNCHxl8T/tC/K77e+og/+71h/b7w4KIrdYmUafRt9mdVKjWY8N9A62U+gNxIH8UGShyoupaQchZ2xWonXMkNQnNpTnqACikH34v80FCFNYxZAkBmsah7UHn4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869083; c=relaxed/simple;
	bh=6/g+xnBuLMW8Pk4Xap1k7wgrvMyoDvhUWRYir12a4L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U92tJwO71HDTHS27W4w9wxXCsHSIN4hCqH8RF7ZIS4+5xzMKgeCwjcr6rGK0AQWlanpSg75IIhKnfC3fh875FB75TgIx9W5vZXp+q9kVmWIwcE4QAYA3DMDs1oseLhx9WCnZFiYrzkRLJ9QIuobLW+rJS84MK01+MZTgs/MSllo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpOXZMr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpOXZMr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61493C4CEF5;
	Wed, 30 Jul 2025 09:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869083;
	bh=6/g+xnBuLMW8Pk4Xap1k7wgrvMyoDvhUWRYir12a4L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpOXZMr1+ut5dUy4V23ZMFLKpc9/coeZlkcKTa2IZKcVrtQJQG4T1ZPNjRwbPrliw
	 0EGqWU9m+xSzwsx4EYCHakU1ybUu7WkETtPknz6XaeocOcljDCCVAaMQRE2tlxfdQR
	 ZFFQmQW239UTq9jDE94Ql9soQeHLtyCkpUvP9fMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Carminati <acarmina@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 05/92] regulator: core: fix NULL dereference on unbind due to stale coupling data
Date: Wed, 30 Jul 2025 11:35:13 +0200
Message-ID: <20250730093230.843633990@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Carminati <acarmina@redhat.com>

[ Upstream commit ca46946a482238b0cdea459fb82fc837fb36260e ]

Failing to reset coupling_desc.n_coupled after freeing coupled_rdevs can
lead to NULL pointer dereference when regulators are accessed post-unbind.

This can happen during runtime PM or other regulator operations that rely
on coupling metadata.

For example, on ridesx4, unbinding the 'reg-dummy' platform device triggers
a panic in regulator_lock_recursive() due to stale coupling state.

Ensure n_coupled is set to 0 to prevent access to invalid pointers.

Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Link: https://patch.msgid.link/20250626083809.314842-1-acarmina@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 90629a7566932..4ecad5c6c8390 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5639,6 +5639,7 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 				 ERR_PTR(err));
 	}
 
+	rdev->coupling_desc.n_coupled = 0;
 	kfree(rdev->coupling_desc.coupled_rdevs);
 	rdev->coupling_desc.coupled_rdevs = NULL;
 }
-- 
2.39.5



