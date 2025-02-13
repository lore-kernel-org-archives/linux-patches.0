Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D667211468;
	Thu, 13 Feb 2025 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457728; cv=none; b=iRno7qGHckmW9k6CyFhxU6KQjytqk++LfKKTALARIWFlf8J6O7AXWFfxB3VbTVjPSfyo+S5plWTwvVxGfOHerQtS8HhU2mr841WaNe88vcE7dBEagOmnqhCqhjPyOqYHciRs0U9UiOQhtLyxi6azYt+6rqsAPsRhV9oLNjCgRb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457728; c=relaxed/simple;
	bh=ih4XgMTNBIwCVFJRZqPOSehWhVrmIt7PU9zNLtCMxQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFvDgNVLH9biIups0PyVSj9alVZkNluQNbgVOs/3pkiXdFm060wDDFP/Ilaf1IT1xdjhuyV32dc9CWImAaqdT0a3OfnOfzxJGZho3DnnrQ1u5UfXO8IxTKoNuHWr/9gyOjmZNUZHpym1LEltjwrfpprd6eNvZirzZH8xhwLiYWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsITwqsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsITwqsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEA6C4CED1;
	Thu, 13 Feb 2025 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457728;
	bh=ih4XgMTNBIwCVFJRZqPOSehWhVrmIt7PU9zNLtCMxQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsITwqsQUlqAKb2qEmH5jDaTQzDO5puL7oC/rEQx1S/noT0FrIKclbc/OX46paMeE
	 2K3Vp60x1ygMV8qUi+y/JXThFElvPZ5hbVhtVBm8nNFUmuEZVDF8DvNFFWquaZp/GP
	 jILWUZn6YZqVstGi+pPxqGuXedXEKAI17qndoLSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.12 164/422] drm/komeda: Add check for komeda_get_layer_fourcc_list()
Date: Thu, 13 Feb 2025 15:25:13 +0100
Message-ID: <20250213142442.873604993@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 79fc672a092d93a7eac24fe20a571d4efd8fa5a4 upstream.

Add check for the return value of komeda_get_layer_fourcc_list()
to catch the potential exception.

Fixes: 5d51f6c0da1b ("drm/komeda: Add writeback support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20241219090256.146424-1-haoxiang_li2024@163.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
@@ -160,6 +160,10 @@ static int komeda_wb_connector_add(struc
 	formats = komeda_get_layer_fourcc_list(&mdev->fmt_tbl,
 					       kwb_conn->wb_layer->layer_type,
 					       &n_formats);
+	if (!formats) {
+		kfree(kwb_conn);
+		return -ENOMEM;
+	}
 
 	err = drm_writeback_connector_init(&kms->base, wb_conn,
 					   &komeda_wb_connector_funcs,


