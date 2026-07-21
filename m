Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE3D46D094;
	Tue, 21 Jul 2026 18:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659863; cv=none; b=UdxCJ9evHuGTQqGEI1YuNz3JpAGIxFPH9mobnk5z1sAv1dDq0PvGnwYBTkU5WkRoAtikK+CwqgiwUPAh9uBplndhZjKAhV1a9sdbHtpQiRNMUaZeOOuBxSlmHU7OkiZTj7eFZVlXLBuv9UtXkrm3gqxalPWbv3QCzGvsbmInvu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659863; c=relaxed/simple;
	bh=7MouR4AY4CSAi8hf5vllGDvkRjW/1HJUSGaYgSQjjfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFvX3tNMpPiG7wRgwA5zTLE+efeJ886NedYc0Dqev/a7OADTa9//8qwYRUEWgJFngy45dnO7F/f7kN3o8kSTNw55R9Roblclq9KIRvkiZYpJZNvUcc7X1v1hztt2bxW3kjDBEksUpFpzfY4gBCBOuRSfDn+afhAViLhFHwfVmY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKmYcnm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKmYcnm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284A61F00A3A;
	Tue, 21 Jul 2026 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659857;
	bh=VfNnskLTvk7QQRAasSYj1ylSxDA1ZKo3/99JsDWUeWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKmYcnm6ckw6Yq7RvgMPmXAqX2Hn7QYvw4l3eQtZB208t0m3rb8r/YgkkDdies6FV
	 fTV4jznT0cFY/994zi1qXOW2JONxrk8y1wGatGxfcnLs8z7TeVHOuroVehyGnvd3Vj
	 xlrYQyIyOHPMdxDuc3SEM7wbNXoJKLfLLe8MP+ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0760/2077] dpll: send delete notification before unregister in on-pin rollback
Date: Tue, 21 Jul 2026 17:07:13 +0200
Message-ID: <20260721152610.720118833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit e83b403eb142be18d223fc599c0ac45519053671 ]

The rollback path in dpll_pin_on_pin_register() called
__dpll_pin_unregister() before dpll_pin_delete_ntf(). When the
unregister dropped the pin's last DPLL reference it cleared the
DPLL_REGISTERED mark in dpll_pin_xa, so the subsequent
dpll_pin_event_send() failed dpll_pin_available() and aborted with
-ENODEV. As a result userspace was never notified of the rollback
deletion and remained out of sync with the kernel.

Send the delete notification first, matching the order used by
dpll_pin_unregister() and dpll_pin_on_pin_unregister().

Fixes: 9d71b54b65b1 ("dpll: netlink: Add DPLL framework base functions")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Link: https://patch.msgid.link/20260607183045.1213735-5-grzegorz.nitka@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 1f1b9a6696231a..a58977c87de193 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -994,9 +994,9 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 dpll_unregister:
 	xa_for_each(&parent->dpll_refs, i, ref)
 		if (i < stop) {
+			dpll_pin_delete_ntf(pin);
 			__dpll_pin_unregister(ref->dpll, pin, ops, priv,
 					      parent);
-			dpll_pin_delete_ntf(pin);
 		}
 	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
 unlock:
-- 
2.53.0



