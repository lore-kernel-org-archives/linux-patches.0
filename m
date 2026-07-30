Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E75637BE64;
	Thu, 30 Jul 2026 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424542; cv=none; b=aFwdGRjK7PkErG2EP8rTH3+xz55imAoMXCgVKd80Rd8i+eXKJyCp2mRPVLGAPsB6ixE1gu3nbJROuW87IyHiJZsUsS+4t+Wf7WIkwqFRP42QprF6gYlpJo5HdANGxPn6YgqKNcrd+8oq8owIs5kxLKIRFCP8toYALkW1lpfus9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424542; c=relaxed/simple;
	bh=07OrlQk4c8oy81jKhlWNpGYeGWVBMDir8qAdqAfpfls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbBciCuBEO/8u+k4m36/M/L7L22NNTk2LGE6u+a8OSjflTLwdzsc570txPBmG07yjyfuH9TOOAFGq81iuOuLDf9rZPKT32L05DzKQI/jOuE3M1r8wIFWOjFV1ROy8ej52uspRwc93JVp9c0LPsbP8LxhkF7awf/vsg21vRzZYlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjj0PxiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjj0PxiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7491F000E9;
	Thu, 30 Jul 2026 15:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424540;
	bh=TRo42D61apTU52byUDy1wk4aFRoLS4UOO7GpcLq6v+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rjj0PxiEiVHglxRrBgP0TT3QnwAho/QXogqcDoYhZzEv7I8QjlyR49eW6N3Uf5Fb/
	 fOWeI1rYHxKDsVldyCLkERLzG5wZU9bBAUJ5TcMnDQna1sNo0FBdhqU8svJLKtrBUL
	 xzN1QPAbnElxLMnV3l0Me9qw+tq5CoVVICLugRVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 430/675] media: stm32: dcmi: unregister notifier on probe failure
Date: Thu, 30 Jul 2026 16:12:40 +0200
Message-ID: <20260730141454.278115907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 084973ebd67b28f0945c5d45408f86c58b540110 upstream.

dcmi_graph_init() registers the async notifier before dcmi_probe() toggles
the reset line. If reset_control_assert() or reset_control_deassert()
fails afterwards, probe returns through err_cleanup and the driver core
will not call dcmi_remove().

Unregister the notifier before cleaning it up on that error path,
matching the successful remove path and the V4L2 async notifier lifetime
rules.

Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")
Cc: stable@vger.kernel.org
[hverkuil: added Fixes tag]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/st/stm32/stm32-dcmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/st/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmi.c
@@ -2063,6 +2063,7 @@ static int dcmi_probe(struct platform_de
 	return 0;
 
 err_cleanup:
+	v4l2_async_nf_unregister(&dcmi->notifier);
 	v4l2_async_nf_cleanup(&dcmi->notifier);
 err_media_entity_cleanup:
 	media_entity_cleanup(&dcmi->vdev->entity);


