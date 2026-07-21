Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F5235C6AC;
	Tue, 21 Jul 2026 22:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673868; cv=none; b=kcdzlOtG/UJuXZGpZ4Tycexd/bTZTDZGsl+Xu3T3y1klhxpBBD9X6qiKJvtGo4h9SSp3d4yCojSYuOBpQyxv6q9bKn/E2dfuad21D96H4ByZijQLZZg7vLtWMLCVwdEZM5FIVxHj+3xCUVNhKF9tiODGKRF50AZhttBmMXAQ/Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673868; c=relaxed/simple;
	bh=moqKkctCAjbzirLZojudGG6/rKTKkxE0E2q//eNoxK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkxegnJIrfM1ktO8vN1I/DxduF1qxlwiO0JSVhfDRD/wVOpS027XCT7LdS6oISDb9dxaOZan47OGcfZ3CepkUcIzEIyOTHVXhRoV5hzBSxGgviPmErbltgfm/WK57Dn73s5MAHUbAWqh3ORXdn4/EXSP/xAVOaYB5zgwrxmpK+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+Xk3fMJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+Xk3fMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8771F000E9;
	Tue, 21 Jul 2026 22:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673867;
	bh=8BAug50HLr8w5EMYoTIFpMzaOh8Z+GmA8ivyjyZ2E9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+Xk3fMJ7lgoxxh/JZGM8nLsZamZ8+O+pxNpio0LWAxJQdkectVMmvkq2SRVGYsNa
	 O2QLBzVUqKLeAAunh1COr5xASjEdnNBWZ4lxQfgqxBcsBBX6BUQAjRPrVTY0URkE+y
	 ZYjaBN3JWajsnsKqKBhkpWlntwODfTFEaVTB5jA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/699] apparmor: aa_label_alloc use aa_label_free on alloc failure
Date: Tue, 21 Jul 2026 17:21:25 +0200
Message-ID: <20260721152403.044466513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit 654fe7505dc6889724d4094fa64f89991afabfc3 ]

aa_label_alloc() allocates a secid before allocating or taking the label
proxy. If the later proxy step fails, the error path only freed the label
memory, leaking any resources initialized by aa_label_init().

Use aa_label_free() on the failure path so partially initialized labels
release their secid and other label resources before the backing memory is
freed.

Fixes: f1bd904175e81 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 7cae71daa0f92f..c675a11d8a5516 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -450,7 +450,7 @@ struct aa_label *aa_label_alloc(int size, struct aa_proxy *proxy, gfp_t gfp)
 	return new;
 
 fail:
-	kfree(new);
+	aa_label_free(new);
 
 	return NULL;
 }
-- 
2.53.0



