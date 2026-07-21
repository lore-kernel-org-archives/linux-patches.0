Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A3346D08F;
	Tue, 21 Jul 2026 18:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659867; cv=none; b=E7ZoAEx7IEUsG4nhRLATinCnlP4B147NjThze4ItCB4QQXEb0GDb8B5r29YrpamtwodVGsFWmMSfDTFDLSLP6Jbi4W7jNfQvpi/v1d1rGNEdPdE+YW1ugc8pkL/YwQH6JRvB8f5lwCSZgeqcVsMfHyuRt3Ohw7ixb407yzAQfbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659867; c=relaxed/simple;
	bh=rQmkJ/YLVuIZ+YME+DCDKS7jRyA13fDQ8biLVH6QI04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPNk8Yzpx0E7Xl0TXf19AoZyyX5JZwwErkBvC8YCEjmm8HlVOxPrvLHhPQGmicMZtDVO9TTRPgyd+3BQOnMkv1Nyve6KYZsXxX2sKE4ujXTGznzqIpyWbxFd8Pn72g9hmTHhHjH1Z25qWIPkFvtJReaFn4+j7OiJpQ4iPPrakxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWrreBDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWrreBDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1128C1F000E9;
	Tue, 21 Jul 2026 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659865;
	bh=elOz9aQSl/b3BCqBuP8EmaPLaL/RNsEp8fsjkjwIBgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWrreBDfAIAlPEh4hdVA0yNwytuQ3aK9yuDsZKXjCPJhDrDCSwvq0OjSFRVTrdtWd
	 ij8GSUin50Fr0i/in4l94lOpAV4HSkN0x8dgslMhDd9swXEPUD9TbWn4pSyqfvESGW
	 WX/Wx31MR3A0XTMqjitrhtV/2tec+z9wCnp1PhY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0762/2077] dpll: guard sync-pair removal on full pin unregister
Date: Tue, 21 Jul 2026 17:07:15 +0200
Message-ID: <20260721152610.767193203@linuxfoundation.org>
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

[ Upstream commit 0a5c720a7d57d2287d5566c4ad93ee26b7c06845 ]

__dpll_pin_unregister() wiped the global sync-pair state on every
(dpll, ops, priv, cookie) tuple removed from a pin. When a pin is
registered multiple times and only one registration is being torn
down, this dropped sync-pair pairings still in use by the surviving
registrations.

Move dpll_pin_ref_sync_pair_del() inside the xa_empty(&pin->dpll_refs)
branch so it only runs when the last registration is gone, alongside
clearing the DPLL_REGISTERED mark.

Fixes: 58256a26bfb3 ("dpll: add reference sync get/set")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20260607183045.1213735-7-grzegorz.nitka@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index ac9654b42b77ca..e3d7aeed43088f 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -913,11 +913,12 @@ __dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
 		      const struct dpll_pin_ops *ops, void *priv, void *cookie)
 {
 	ASSERT_DPLL_PIN_REGISTERED(pin);
-	dpll_pin_ref_sync_pair_del(pin->id);
 	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv, cookie);
 	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv, cookie);
-	if (xa_empty(&pin->dpll_refs))
+	if (xa_empty(&pin->dpll_refs)) {
+		dpll_pin_ref_sync_pair_del(pin->id);
 		xa_clear_mark(&dpll_pin_xa, pin->id, DPLL_REGISTERED);
+	}
 }
 
 /**
-- 
2.53.0



