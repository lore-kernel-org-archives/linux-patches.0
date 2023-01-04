Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED220AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0C0C433EF;
	Wed,  4 Jan 2023 16:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849458;
	bh=4va3wUPT7zPa6x4wl2Tqwhgq8MSGnS3eFl2QX7utxqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBk6UHZeTphxOFskTSO4X9z0GiSTEAMJ95GcKQBnEeT05/36HzaD+EensdWWjWG8h
	 BCI/i3mzg4yKUM1jH1BK0LIQqo9/4KS3JlrdMT65nQ9zoKJIA3/U96d/vq1ItWEnLU
	 x9KKE4LCg/ltM70PjlcscoWs5Ykx2twUKp9gOllE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zackr@vmware.com>,
	Michael Banack <banackm@vmware.com>,
	Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 6.0 126/177] drm/vmwgfx: Validate the box size for the snooped cursor
Date: Wed,  4 Jan 2023 17:06:57 +0100
Message-Id: <20230104160511.464668820@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -309,7 +309,8 @@ void vmw_kms_cursor_snoop(struct vmw_sur
 	if (cmd->dma.guest.ptr.offset % PAGE_SIZE ||
 	    box->x != 0    || box->y != 0    || box->z != 0    ||
 	    box->srcx != 0 || box->srcy != 0 || box->srcz != 0 ||
-	    box->d != 1    || box_count != 1) {
+	    box->d != 1    || box_count != 1 ||
+	    box->w > 64 || box->h > 64) {
 		/* TODO handle none page aligned offsets */
 		/* TODO handle more dst & src != 0 */
 		/* TODO handle more then one copy */


