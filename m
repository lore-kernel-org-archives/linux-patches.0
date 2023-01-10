Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350C66FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4CDC433F2;
	Tue, 10 Jan 2023 18:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375374;
	bh=QuTpqDaHpS8o8SloplrIfm3XWizvw1atJ7Rxe86lGBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRJ5/8pJQCAZ70Rk3C1qME3unJ8CmLX/kORq9R1ZoUtIZajmKYp26lL1iTH2/6B92
	 udV8OViFp8MfBht4frsN91pO/elJU1YG2PYHO62FfM8KDyN2RK/Y9MY1C7Z8/6Xsv1
	 MpfN164iJI4lOSSAP3Hv0DP7d3j4Xlx1D3KIbC24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zackr@vmware.com>,
	Michael Banack <banackm@vmware.com>,
	Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 5.15 136/290] drm/vmwgfx: Validate the box size for the snooped cursor
Date: Tue, 10 Jan 2023 19:03:48 +0100
Message-Id: <20230110180036.543094567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zack Rusin <zackr@vmware.com>

commit 4cf949c7fafe21e085a4ee386bb2dade9067316e upstream.

Invalid userspace dma surface copies could potentially overflow
the memcpy from the surface to the snooped image leading to crashes.
To fix it the dimensions of the copybox have to be validated
against the expected size of the snooped cursor.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 2ac863719e51 ("vmwgfx: Snoop DMA transfers with non-covering sizes")
Cc: <stable@vger.kernel.org> # v3.2+
Reviewed-by: Michael Banack <banackm@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026031936.1004280-1-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -186,7 +186,8 @@ void vmw_kms_cursor_snoop(struct vmw_sur
 	if (cmd->dma.guest.ptr.offset % PAGE_SIZE ||
 	    box->x != 0    || box->y != 0    || box->z != 0    ||
 	    box->srcx != 0 || box->srcy != 0 || box->srcz != 0 ||
-	    box->d != 1    || box_count != 1) {
+	    box->d != 1    || box_count != 1 ||
+	    box->w > 64 || box->h > 64) {
 		/* TODO handle none page aligned offsets */
 		/* TODO handle more dst & src != 0 */
 		/* TODO handle more then one copy */


