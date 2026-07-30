Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B9F36607D;
	Thu, 30 Jul 2026 15:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426216; cv=none; b=AEQWtAeRtu1uvK6TP1dlWUmVY0Jqy259cEVYvURLLdeyN+UzdMvPhqge4Knf5gZth8aXXRy6zd5dYo9W5SbqdFvKgwR21gax0IQ1OxX6FXrUxkDZxqprGcO4sY3VWBfAtk3ELImZuFiKAe/EDlq+3i7ugFr1kbzThIJNz4taXkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426216; c=relaxed/simple;
	bh=dDQInhBtKUnUs16OkpOhPljzKPv3xsFal1ArVGyo3/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcsMltSr79bmZFE1UjaPVBKC75SyKpUiCAdnigxH3255lQAV+100PcHG4iIIIiQeQN2bUo+YEI8VBNAFJzpwv0ipKVSMe5Y/cTdcLg+1BUnap5RuRZSP9Qq072keKjq9F/oY+HpwnCdRnSBjOeKqHIVWF5OJ2BmOmJ12qFLS/vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4CN852H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4CN852H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBCC1F000E9;
	Thu, 30 Jul 2026 15:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426215;
	bh=VF2jLtvz8nc0H5admfjWx4hZD3ZAntmLBJ1Bm5OC0Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4CN852HrBxZfEEC73Iek4K5IuOmaHD3q9s2P0BE7fmKyanzmMBpjBR0zfprQbTY2
	 27O2llUZJolkI0PLGCJ2HOMrXUWevJoeKVZzJbN3IawY43/9xquqxyqUeX7+72/EPt
	 VUvMWs8TXIW09hTRw4WJHut68awhgUND1F26ynOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hilman <khilman@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 342/602] media: vpif_capture: fix OF node reference imbalance
Date: Thu, 30 Jul 2026 16:12:14 +0200
Message-ID: <20260730141443.147885035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 2282f979560af6bbc8ee2c1ee8663197312cee5b upstream.

The driver reuses the OF node of the parent device but fails to take
another reference to balance the one dropped by the platform bus code
when unbinding the parent and releasing the child devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 4a5f8ae50b66 ("[media] davinci: vpif_capture: get subdevs from DT when available")
Cc: stable@vger.kernel.org	# 4.13
Cc: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1501,7 +1501,7 @@ vpif_capture_get_pdata(struct platform_d
 	 * video ports & endpoints data.
 	 */
 	if (pdev->dev.parent && pdev->dev.parent->of_node)
-		pdev->dev.of_node = pdev->dev.parent->of_node;
+		device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
 		return pdev->dev.platform_data;
 


