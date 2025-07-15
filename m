Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB72E4278;
	Tue, 15 Jul 2025 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586362; cv=none; b=PJUGaxOtmD3VlqShK1YKlF4Z1Flxk2zLoRml0QE/1HBDexmeEZ7j5XTSum2xUvZryDAo9eMjB38ReV1DSSLdH9qE8QpKTHEkyem5O+vbzfKJGMhFvKttR//cgoOkFAOCPpF2QPpFxzp7VcZNnNIRRDCH6AZVSEb3/7ncQIXaK30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586362; c=relaxed/simple;
	bh=k8sRJOTy3O9oyFoCTCYJ0GpYlUJKI+T5dbli1/hiPsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eu3p9yoRV714T3DzoZbwV7EAVsqvBMTCOZSmVtS5TsMWASuZ9z9D3RhD8Uvnom5y5jKBHsljvcaZ9/5D9SVGrAxvku2V3QwkSzNOUNsj3LVGi+y69YDx+ZUjOi6o03aEo8iZyCYjIejhO1jy8SHMJ9cPnXmxC7ex4KtVgIwX2wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KB5cka/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KB5cka/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1909C4CEE3;
	Tue, 15 Jul 2025 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586362;
	bh=k8sRJOTy3O9oyFoCTCYJ0GpYlUJKI+T5dbli1/hiPsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KB5cka/eNFuMrrTn+gl6o1hwlM5rqoF4hQigRtqaQzF2k251K2bPoMeE4SVF0sU1F
	 orR+/TZEAGtIvLOr6wRa/QvvPVe5lbsiXPDZl6zzhoEjbJcfD+DiJ11dLIhRrcXMrD
	 BJ41KbDGylIasEsz/KfjHj+GGAE14qNmA5zg+DEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/148] usb: potential integer overflow in usbg_make_tpg()
Date: Tue, 15 Jul 2025 15:12:09 +0200
Message-ID: <20250715130800.596004161@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yufeng <chenyufeng@iie.ac.cn>

[ Upstream commit 153874010354d050f62f8ae25cbb960c17633dc5 ]

The variable tpgt in usbg_make_tpg() is defined as unsigned long and is
assigned to tpgt->tport_tpgt, which is defined as u16. This may cause an
integer overflow when tpgt is greater than USHRT_MAX (65535). I
haven't tried to trigger it myself, but it is possible to trigger it
by calling usbg_make_tpg() with a large value for tpgt.

I modified the type of tpgt to match tpgt->tport_tpgt and adjusted the
relevant code accordingly.

This patch is similar to commit 59c816c1f24d ("vhost/scsi: potential
memory corruption").

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
Link: https://lore.kernel.org/r/20250415065857.1619-1-chenyufeng@iie.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_tcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 90fe33f9e0950..48d02c5ff8491 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1320,14 +1320,14 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	struct usbg_tport *tport = container_of(wwn, struct usbg_tport,
 			tport_wwn);
 	struct usbg_tpg *tpg;
-	unsigned long tpgt;
+	u16 tpgt;
 	int ret;
 	struct f_tcm_opts *opts;
 	unsigned i;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 0, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtou16(name + 5, 0, &tpgt))
 		return ERR_PTR(-EINVAL);
 	ret = -ENODEV;
 	mutex_lock(&tpg_instances_lock);
-- 
2.39.5



