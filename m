Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23CA3385A2;
	Wed,  3 Dec 2025 15:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777244; cv=none; b=R8bgwJHrUFRYjYMIsufbkSae6iV8Lq/HyNCc/jr1ovGUkHyTqQjrvAiVK7hKWpkhIiln5r7nwIqhMhUrdiwOuyDEh8Y+2PYwA4tuZxSpWFejCNHHqHyolhwcBOVDkQm8ypJzd17dPAJ9WSDIJLoBSCly/quUxH8EL8j2XxOGQqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777244; c=relaxed/simple;
	bh=AJOPlJsqrAm4Rh0bY5XPeqBwxsQOcsrN/dRCNWNTxXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcMj+djVqRVj9JVgzJI1akbWQQsQvDSmd+mRGXJ9Wn4HLTGQdLPgwVqKRQTdoTqbTvHK0nafOWb6M7yEZ9kFnTSmUf6mMCJYoBW6DnDJIaM8TRnnVd0Nmz9aFsQyv2yqtbjI2q/YDdwNwykIprfNT60LZyDs3LZuwInX5Hrs26o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBe5B9Qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBe5B9Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B59C19422;
	Wed,  3 Dec 2025 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777244;
	bh=AJOPlJsqrAm4Rh0bY5XPeqBwxsQOcsrN/dRCNWNTxXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBe5B9QibJDn8xiznf7XToFdesyaOEaIc/sv7zw/KJQmfw7o/Fa4QsYvyFVKNIYEJ
	 4gPuhCcHLFGyPorDF+UrFxLyeKWvrS/p3z6xfotUryOiMiukxIbdkpD9lSRZRoeFjT
	 PjikVF5JJKLUTW13kv7kSo39XOOILnjVfZrxwCK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.17 126/146] drm: sti: fix device leaks at component probe
Date: Wed,  3 Dec 2025 16:28:24 +0100
Message-ID: <20251203152351.071653475@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/sti/sti_vtg.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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


