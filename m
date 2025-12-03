Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C49933CEB0;
	Wed,  3 Dec 2025 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781168; cv=none; b=OG2lHFtwOKrOcwLDNMnacYA7NVnqxS4POW1R54j4U0VNNjb5qQ9cWYSQKZ5HI6B4xjIpsj4764tzoHRUkpsjijpZpGc1pE8cKORX5Ez88cEED128yZMrac15yuILcDzCWc5D2HQ0h4W1dyX/bB1hR3lJurqoJC93SQ5Dz4C6/Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781168; c=relaxed/simple;
	bh=DwPFoLFoWy1s8O4JGTika85QhlLKEYyq4mT31xi3SDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSmsLHajI5GulyYEHOFCP5QE7NSy9/M/+DF3MvAb5wrPX7vCgLfmHea03+6fBLHTkdNEKBLjyCBq2c+CuLexX0Z5B/UijqV/iUm9n0WwcozLpnRwuXxCb7VvEMABfZruF8Sy+Nc2G44zmKy1TeysR8CXqTsfbv/7UfMZai5wPjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqK98rTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqK98rTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA32C4CEF5;
	Wed,  3 Dec 2025 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781168;
	bh=DwPFoLFoWy1s8O4JGTika85QhlLKEYyq4mT31xi3SDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqK98rTdE1XBD5+Ft5z86WrprctA/tDZNLz/Goq8NDhex48DO6YA58ZSsqt1ngGnC
	 ggyQoZE2jTWzdYb1wtLX9zTTvQT+dZRqDoTjriTQKb/IFe4HwNP0LqVXXejq4Vhbgv
	 nK58nUx7pnSEtD3RsEnv50W008L2DxbpfnOqiry8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.6 71/93] drm: sti: fix device leaks at component probe
Date: Wed,  3 Dec 2025 16:30:04 +0100
Message-ID: <20251203152339.148208914@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


