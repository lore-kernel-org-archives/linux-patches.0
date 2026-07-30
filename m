Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A62376A0B;
	Thu, 30 Jul 2026 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427722; cv=none; b=WtqYiYkH5GdLV76129QnQDDBAPyDqfSO7ey+z3r15raTsGFzr7rz+j5gSSUR+YvX/T7yBF6eqA/OnY6DvlmSTIdqqyDSEyWLBkaUy6RhNIpg2tA1otddgCK6Zr3l3wY8DBYF4fFbHRXQEzjN4K11SyOwSDKL8LYSZYQxK15bWIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427722; c=relaxed/simple;
	bh=2MweNMCpTTwT0AN5RsXNqNBg1PgLQOWHiMzGtWVJWNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/7EzOoOUqxm6ltVhANmcG4c1IGziSc82J94mDUbRlaYjzk0kePuDofr5L8aTfJqVPi4xwojgaYsLztxurRp9TcxR7mhIREZOVamE7WCvNTzYgV0/aUL436+ik50zLk2BJ7nc0sGKgbuRHmvoqNG8URXBqqWfLfyWXos1L3DVzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3/cP7hn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3/cP7hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F2A1F000E9;
	Thu, 30 Jul 2026 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427721;
	bh=xChH+6Ek7qGvIkk743L+CYAt8DPddGMAZj7h5cUBHzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3/cP7hnJdUel8wc0nkKE/dzcOoXWcNwOwKfcLBFcRlbYvuwcGpvF+k9TkNm1L21V
	 pb1AB/9SJTD8Pf1CGJmoOiNqBPTOq5DYU0ozPxEekmotRwQSYC9clKbPWZfuXV20nC
	 3+dFDfUvhNQDq1nXrcFjJl/MiIAUetB3SW3lL38s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hilman <khilman@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 268/484] media: vpif_capture: fix OF node reference imbalance
Date: Thu, 30 Jul 2026 16:12:45 +0200
Message-ID: <20260730141429.315653821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -1500,7 +1500,7 @@ vpif_capture_get_pdata(struct platform_d
 	 * video ports & endpoints data.
 	 */
 	if (pdev->dev.parent && pdev->dev.parent->of_node)
-		pdev->dev.of_node = pdev->dev.parent->of_node;
+		device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
 		return pdev->dev.platform_data;
 


