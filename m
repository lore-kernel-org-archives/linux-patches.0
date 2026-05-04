Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA2229E116;
	Mon,  4 May 2026 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904380; cv=none; b=YZHi1Q+bHNj5roa/H1S/tW/jouesUqbVN6kDgSUMT8rK/59L8PoGTT5RA+UXl2GO9UmYIe05Qa/pLEV2QvCF3ebCXlvXhd04sW48GJB3cIN8AWiGc+geZbpO2+EwQ/z7inPzPToohElq4E/JnBqZFD7MyoKwOfi6H++zu8z2zkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904380; c=relaxed/simple;
	bh=sOg49B/qV3F7338ltwLt/DhEwlJ5r2TYbQtkP34wJT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFSgaqNDWPzvqf6aRlz3lwHQiWbjG8yyYpbQEG4kyD+Jaf35RykWC/mWlyp3zC2iZxZiUYgKYz1qbBimNKFPtARhouCcRSV1UuAocxjl7L6lFs5TsJLZjm+C/zI2bbf/X+RKwRdVVswfYG3YQQ41YKo9IUG+4rhxwGlZ7D0F814=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUtLdrOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUtLdrOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AF3C2BCF4;
	Mon,  4 May 2026 14:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904380;
	bh=sOg49B/qV3F7338ltwLt/DhEwlJ5r2TYbQtkP34wJT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUtLdrOyeE89QaXsqqi2Ano+H/SwXXhelZrCm0Bf64UsB4927Fw7B/0YxPdARuWPV
	 AHx8Inqgu9lvU1UsBVCQBAlrl4w1HJL/9UDIq2NIe/YYHbBWmPrkJten/i3pvQIySW
	 B0OsiFfUboh64KEDWRbaLWbIvieAKCOm6pTWtS4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 017/215] drm/nouveau: fix nvkm_device leak on aperture removal failure
Date: Mon,  4 May 2026 15:50:36 +0200
Message-ID: <20260504135130.804017685@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 6597ff1d8de3f583be169587efeafd8af134e138 upstream.

When aperture_remove_conflicting_pci_devices() fails during probe, the
error path returns directly without unwinding the nvkm_device that was
just allocated by nvkm_device_pci_new(). This leaks both the device
wrapper and the pci_enable_device() reference taken inside it.

Jump to the existing fail_nvkm label so nvkm_device_del() runs and
balances both. The leak was introduced when the intermediate
nvkm_device_del() between detection and aperture removal was dropped
in favor of creating the pci device once.

Fixes: c0bfe34330b5 ("drm/nouveau: create pci device once")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260411062938.22925-1-devnexen@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -853,7 +853,7 @@ static int nouveau_drm_probe(struct pci_
 	/* Remove conflicting drivers (vesafb, efifb etc). */
 	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &driver_pci);
 	if (ret)
-		return ret;
+		goto fail_nvkm;
 
 	pci_set_master(pdev);
 


