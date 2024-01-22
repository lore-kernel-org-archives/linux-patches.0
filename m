Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC3417CA;
	Tue, 23 Jan 2024 01:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972148; cv=none; b=SCefGK0ewdqLizEByaLUKj1THoCsfnKvl9FSQF9nPaOYUTNWPEs9kAzmt0Y/LeMHSo8J+ZEQlFTG21i+y7NAJfU4BVPYwfTWdtGzXZmtDrvVrGizJVEZowCCgZv8qT0wCL61dPQBrMIrMDKaMduhxqN/vmfc1YrNMBV+jQko3+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972148; c=relaxed/simple;
	bh=8RsnXrCUwB5QLUX8cujbWxaOyoymvQKQzorZqeizLyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jB4KCes9tB7JnKIh7rUgvkqzu9z4bvLhpSRZApn7InojHHRmB6DvHRqYgLgFVSCUdQwLiG/ZRiPB9u1tm+oCMvfRcM3DBVPZmuj0G4NumMT3spO//9UUuZ/MrdZNuVg3mpYfUnMtZ8TMXQHIdpY0d06/QXfZFu36maTIoSpiD6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgP40wnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgP40wnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0851C433C7;
	Tue, 23 Jan 2024 01:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972148;
	bh=8RsnXrCUwB5QLUX8cujbWxaOyoymvQKQzorZqeizLyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgP40wnUJjN/1HT0kKVL6DO5rKnHsAEt92MI/4iiMqJSaL5it5HgcB5JR+FH6Ob+s
	 RQk1DfAztgukSbDEHc/Bab9L1rW7hQVhyl/DzBANOeNK/DWfY5DvWr+kApKPunOkGk
	 YwkMufTvJWVbZiBW8Xv3TmWaHGnfAsp7Bg1LD8Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/374] powerpc/powernv: Add a null pointer check in opal_powercap_init()
Date: Mon, 22 Jan 2024 15:55:32 -0800
Message-ID: <20240122235747.262852516@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit e123015c0ba859cf48aa7f89c5016cc6e98e018d ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: b9ef7b4b867f ("powerpc: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231126095739.1501990-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-powercap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal-powercap.c b/arch/powerpc/platforms/powernv/opal-powercap.c
index c16d44f6f1d1..ce9ec3962cef 100644
--- a/arch/powerpc/platforms/powernv/opal-powercap.c
+++ b/arch/powerpc/platforms/powernv/opal-powercap.c
@@ -196,6 +196,12 @@ void __init opal_powercap_init(void)
 
 		j = 0;
 		pcaps[i].pg.name = kasprintf(GFP_KERNEL, "%pOFn", node);
+		if (!pcaps[i].pg.name) {
+			kfree(pcaps[i].pattrs);
+			kfree(pcaps[i].pg.attrs);
+			goto out_pcaps_pattrs;
+		}
+
 		if (has_min) {
 			powercap_add_attr(min, "powercap-min",
 					  &pcaps[i].pattrs[j]);
-- 
2.43.0



