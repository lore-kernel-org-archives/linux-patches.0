Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90269846F;
	Tue,  6 Jan 2026 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720999; cv=none; b=sqC7jzzLtWs2sD5YsKLf75kPI8Hf3F+IoAfumqAXhK79mEBraML9nhsyeJNzno5uzv2wgf+GW9ADzEbOCASUiv9IEBejKRwEi9EnkvNJCE5YIXuPY0X5B2vJbkUSE+0S+MhN8irmtQj0aKYET+TUEC9nRMnT9unZhEnf1D6xXzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720999; c=relaxed/simple;
	bh=k/6SnduiWUMW3qd5lItR6jV72y775RlLgay40QuviUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEkIN0SJrhTQQBC73NJMeya8AkH+QI0mEb2vNeuokVjWlCv2R8TSUgtVsiRcWukWmlpBhc5W0uYODcLmd+ZB/tnf8MYGi75Xx8PCIDJRKnxflVf9UzuLJBJzcN3TglqodDC//yp0MRAU4RTAehDQm38ScfEx87SIrpNPZoTT5fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAW/cBQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAW/cBQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086D1C116C6;
	Tue,  6 Jan 2026 17:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720999;
	bh=k/6SnduiWUMW3qd5lItR6jV72y775RlLgay40QuviUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAW/cBQiS7YmwLQ3T3Z2J9dB/alyuZIgenDSBKEnOEtZGKZ6WljSKKmpCgLf49uqD
	 pmi85XBKJUiCRO22R23cLvoRiJAtDOwpQXw8Wi7VUroX0VHFwxt/lQSVq4ac/4CAa8
	 Np1JpU6M0rB7Z+MC8aiICof5Hf7ZeRzdK0OxhSXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 405/567] media: renesas: rcar_drif: fix device node reference leak in rcar_drif_bond_enabled
Date: Tue,  6 Jan 2026 18:03:07 +0100
Message-ID: <20260106170506.325503933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 445e1658894fd74eab7e53071fa16233887574ed upstream.

The function calls of_parse_phandle() which returns
a device node with an incremented reference count. When the bonded device
is not available, the function
returns NULL without releasing the reference, causing a reference leak.

Add of_node_put(np) to release the device node reference.
The of_node_put function handles NULL pointers.

Found through static analysis by reviewing the doc of of_parse_phandle()
and cross-checking its usage patterns across the codebase.

Fixes: 7625ee981af1 ("[media] media: platform: rcar_drif: Add DRIF support")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rcar_drif.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/renesas/rcar_drif.c
+++ b/drivers/media/platform/renesas/rcar_drif.c
@@ -1249,6 +1249,7 @@ static struct device_node *rcar_drif_bon
 	if (np && of_device_is_available(np))
 		return np;
 
+	of_node_put(np);
 	return NULL;
 }
 


