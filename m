Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515E7312810;
	Wed,  3 Dec 2025 15:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776784; cv=none; b=oymiQluGcvFJaETfC9wxTMxwKGpwrxUQSI667WnXjg//sGsS7XE3ApCnScneCvz1qTuzYUnLLM+5gDBkde+cInk8J589umZIvgUU8o9qv0n5m43ec3bYWBpH89W/vIVUnztydHtH1L5onTj1BBJ6FdPyBs8ttR9QKODcvzt776s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776784; c=relaxed/simple;
	bh=X290QDd9oF3WnbzwcktiWPxBSwSvCu3o/K6XBU8UG5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAZXVwQJzRTzSWne+Jj8xdXLrWieDTy+Mx5tksaMtY335OedqShIWGp/IVTxd9m5cVmT1j8Gw/HPVOQaVeZBDyKof76a+TrOIiQ4oVFynq6YTA5HFMUITOd5io612ewGdjH2790HsL9UYsBqdyb9L8PiBMUnqV85zLW07CJqlgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzj1mBEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzj1mBEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6010C4CEF5;
	Wed,  3 Dec 2025 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776784;
	bh=X290QDd9oF3WnbzwcktiWPxBSwSvCu3o/K6XBU8UG5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzj1mBEX2UXJufqyClNjehNBwy7p8MswRy3eyCwLmfXHDuQPkhEz0Mgh/jCtFcMWq
	 nuAGoRzpPBh0FADdlrdcfZRu8ZD3TFg80tQIYkXNnEpHTlqEjEs+CTPJbSWjGPInQM
	 M1/BNDswW15vIaikS1q4jX36MxI+3EvS/2dzPsQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 5.10 287/300] drm: sti: fix device leaks at component probe
Date: Wed,  3 Dec 2025 16:28:11 +0100
Message-ID: <20251203152411.255382976@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 620a8f131154250f6a64a07d049a4f235d6451a5 upstream.

Make sure to drop the references taken to the vtg devices by
of_find_device_by_node() when looking up their driver data during
component probe.

Note that holding a reference to a platform device does not prevent its
driver data from going away so there is no point in keeping the
reference after the lookup helper returns.

Fixes: cc6b741c6f63 ("drm: sti: remove useless fields from vtg structure")
Cc: stable@vger.kernel.org	# 4.16
Cc: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20250922122012.27407-1-johan@kernel.org
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sti/sti_vtg.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sti/sti_vtg.c b/drivers/gpu/drm/sti/sti_vtg.c
index ee81691b3203..ce6bc7e7b135 100644
--- a/drivers/gpu/drm/sti/sti_vtg.c
+++ b/drivers/gpu/drm/sti/sti_vtg.c
@@ -143,12 +143,17 @@ struct sti_vtg {
 struct sti_vtg *of_vtg_find(struct device_node *np)
 {
 	struct platform_device *pdev;
+	struct sti_vtg *vtg;
 
 	pdev = of_find_device_by_node(np);
 	if (!pdev)
 		return NULL;
 
-	return (struct sti_vtg *)platform_get_drvdata(pdev);
+	vtg = platform_get_drvdata(pdev);
+
+	put_device(&pdev->dev);
+
+	return vtg;
 }
 
 static void vtg_reset(struct sti_vtg *vtg)
-- 
2.52.0



