Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B3B2EE5ED;
	Thu,  3 Jul 2025 15:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555939; cv=none; b=dLGNJFaMEoHudQ8UAmL8F3TsL+F0fL8/qXlecBs9SDvrqEHTP6ZNgw5YdvBHjj0f99iq61BcgY+6sYT2ljhVzYRFOcfbvbXYyIrjR4CfQLmW+nl519x8X6t+hrgvH42/a2unlBYM1lor+95CsCZ6ULnajxzkeAGWu65CUM79+cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555939; c=relaxed/simple;
	bh=q2mfwGU1w2Sa1i8x5ha9tVW5JEXlFnIDov3pg05Fq4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7VWNJPscMX7qiQcKRYPNUPvrL9TuszoteepPwDJZK3CIEgy+b8JlkbYL4dsAPumY3S2QZ687TnyKnkyoCf0R8TJWP4klKdo1Ij9wTFCo4dyDoJOpcfslr4cdmyeObLE8atZ0mOpVE2OuEsJnLFc6z+L46JIzAUln6zXqM88FRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fck8Zzh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fck8Zzh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D240C4CEE3;
	Thu,  3 Jul 2025 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555938;
	bh=q2mfwGU1w2Sa1i8x5ha9tVW5JEXlFnIDov3pg05Fq4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fck8Zzh8dg1YqlX1cL5vO5gS/a8sc+qrAfYBrsC+aiRXUMtkxXpvVUuZ4Y9RqKAgg
	 utio+U0n0bpZyxCXneb35yG4gh27JRIaaocAyF85mbIHzcltd1BB5xVYHyuD/Pajyy
	 9iMGqlMB9/Hl4SwCUYYivywIByZAkPBkWQ23QDwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/132] usb: potential integer overflow in usbg_make_tpg()
Date: Thu,  3 Jul 2025 16:41:53 +0200
Message-ID: <20250703143940.349640973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3c9541357c241..55a81ad6837b6 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1321,14 +1321,14 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
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



