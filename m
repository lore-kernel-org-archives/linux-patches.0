Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6CE248BA0;
	Wed, 15 Jan 2025 10:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937823; cv=none; b=VVU75gSPJrV/MD8edqz5S0XyaApwgj2fLwGJOIu7eFek5b3tsqCRXok2ipAShVs0DJpHppMCgte/5zLyF9e/e0Z16bU180/BXq/dSyxTsq3ociQYMY2WeZrbMxd6VAwwueLEiUUPh2rH4xmw5I8u4zmlPT3dwGy8487RZPjZs2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937823; c=relaxed/simple;
	bh=LZhfzvSvPZJSYDOH8UDWhtyJTaBW/LRt0Dk6Xw1ViUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyJAt/9cmhIVMJjLlmrbocEliFF7RagYw1Y5Yea0jEiq42uxf04/aYMUUW9ZNm2nr8KHfTGp2A/oltuGi9Sy/BowBQ3YOcnzBRDKo14jgYLM4NiYFQd8HaXXuczQF7Zpp+GCKYylQsJ7oZ9jgco3jQjCGLu+y2/3uoIxDg8i/dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyhnqIzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyhnqIzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B35CC4CEE2;
	Wed, 15 Jan 2025 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937822;
	bh=LZhfzvSvPZJSYDOH8UDWhtyJTaBW/LRt0Dk6Xw1ViUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyhnqIzv9U7ovb8cYVsMNkv2lbOZpME50bAGJ/P+gAox3+H0bKP4smpOz2LX+jzDY
	 ixiTleGCVlE9cIu84c4enebEd3dubNaJAX4HAzvxn6BiFE8uNOC9JhuMj/yP+AMxxO
	 fFiEuq51uht20+W+7AFaE6oRe+bI24n2hr/Rr1QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 63/92] usb: dwc3-am62: Disable autosuspend during remove
Date: Wed, 15 Jan 2025 11:37:21 +0100
Message-ID: <20250115103550.073398811@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Prashanth K <quic_prashk@quicinc.com>

commit 625e70ccb7bbbb2cc912e23c63390946170c085c upstream.

Runtime PM documentation (Section 5) mentions, during remove()
callbacks, drivers should undo the runtime PM changes done in
probe(). Usually this means calling pm_runtime_disable(),
pm_runtime_dont_use_autosuspend() etc. Hence add missing
function to disable autosuspend on dwc3-am62 driver unbind.

Fixes: e8784c0aec03 ("drivers: usb: dwc3: Add AM62 USB wrapper driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20241209105728.3216872-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-am62.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -263,6 +263,7 @@ static int dwc3_ti_remove(struct platfor
 
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_set_suspended(dev);
 
 	platform_set_drvdata(pdev, NULL);


