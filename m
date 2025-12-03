Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994D0350A03;
	Wed,  3 Dec 2025 16:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778540; cv=none; b=ZNLMtUU0Pm11bp/u0FuD2YFpFSvgLBDzNf4LmZGI9cSHtPsrnE/YOFL8Jb3lmjhc2eP5OyPEsiWGAy4QczN312wqaZarVtgmj4DAW42ifH/8oCH7P4FmFR97ox6kat5ayY8D7LrRNI+RII9miKcoOu7goOkIA3G1Fu85HOpvrfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778540; c=relaxed/simple;
	bh=v49CobYErsbg6HP6RR9Vs8jlQLD7DMuYLUZ/HUgUPzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evdaFuSWyHoN7sR6lbsEjT6Ay5K2HjY5NM3Odf0mIpZlJiySqwUoCJOuVy1vOdUD4j6A6IFP0DPU8WvwDzbKQPU4AC4f1ZXeou/g2K55xVQaKhycoBu54WKVpmRexe/SZ1gwAvijXKB5t+HolR5YlUlsVNZP51sKhEKQKWhmHL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSCd1v8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSCd1v8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E6AC19422;
	Wed,  3 Dec 2025 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778540;
	bh=v49CobYErsbg6HP6RR9Vs8jlQLD7DMuYLUZ/HUgUPzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSCd1v8xcNmn3rp86PUy69GO0rPNchPBqfij9cOwZCqFF3fY/aE8MN/P5UPuh3E7n
	 vk4iyEvNw/zMs2qqlxDEQefNS3ZEynIkZlhksIxKM5S/KYZxVr35f/LaCcloldw2gR
	 XxGOlKwNKBy12dQpifnz7y1aLGSYCyWHDv9Ye8pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 5.15 375/392] drm: sti: fix device leaks at component probe
Date: Wed,  3 Dec 2025 16:28:45 +0100
Message-ID: <20251203152427.954874116@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


