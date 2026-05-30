Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00FA32D42B;
	Sat, 30 May 2026 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160646; cv=none; b=dnhpsoED36LwFrP339VIppuIPHn4wkQBs9PjSoQZGVGGt51ScW+fKLXzT6dzfPWQdpPthqnixCZYCJto6mGFhtiQjWkUiJVJBxHgZVWfPtbXrps4AvprZLEKqtFO/whiwkujow9xqv81qLFoptqRlqQ9VDuUJC78DyWMuD/h1jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160646; c=relaxed/simple;
	bh=WExSbBd7+srdryRsDCARjlCglsW6U9iNSyzugFiUy+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HS4A368Uhh5s7CkWDjjbl7HCJSXlA89V3p6yt8sjE/nM20ibFc2/7tL9k/VcyD7KuFqinTtk+4uFg1CrRfpm4lCNV0e1eT27EHQwm/rMimBuUlY96sMhQz9NywnkMRnCRmpX8eHhT+iT3hVUZpc2knbVddvtqJmKvJW6KmHyBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dERvFS/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dERvFS/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2BC1F00893;
	Sat, 30 May 2026 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160645;
	bh=1C8MzHXsqizS4mL84/MmognHjPA0NQVvPIT7u2deH5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dERvFS/fk9a4g9oI+6IMYh/HS5l2WgwZgqT8Ytr2OjkrLfE3Et53ramsXI+4GNpEP
	 4ZK/0sTJI6RRfo66CNE4P2lb8F+soJ8itf52aL9Hd0xSI1flD7C0SuPGLlKzqCGfdT
	 V51ug/eESEbUMiS+T8T+QAX6ET0Vex2hys5EVVa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 394/969] media: pci: zoran: fix potential memory leak in zoran_probe()
Date: Sat, 30 May 2026 17:58:38 +0200
Message-ID: <20260530160311.179099848@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 8ea21435fe36fb853706f4935d78bc11beb63fb4 upstream.

The memory allocated for codec in videocodec_attach() is not freed in
one of the error paths, due to an incorrect goto label. Fix the label
to free it on error.

Fixes: 8f7cc5c0b0eb ("media: staging: media: zoran: introduce zoran_i2c_init")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/zoran/zoran_card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1377,7 +1377,7 @@ static int zoran_probe(struct pci_dev *p
 		}
 		if (zr->codec->type != zr->card.video_codec) {
 			pci_err(pdev, "%s - wrong codec\n", __func__);
-			goto zr_unreg_videocodec;
+			goto zr_detach_codec;
 		}
 	}
 	if (zr->card.video_vfe != 0) {


