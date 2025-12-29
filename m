Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506FB334C31;
	Mon, 29 Dec 2025 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025971; cv=none; b=b0PK7fz7Q0QUXHn5EreYmpM3jIq6XaSBLnTC4VKCo4zSPFPfTYUus9UmVdKf4aUu/L1Ty+00PjI+l5KcsxBTO1pksmDxw1UzEvJs6n6VLmXAtKry6eLouOO75pE7oz/Rj7IMp+jFe/RfKD4QJGg+P84+ZQoTanLfqCebEHs5Y2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025971; c=relaxed/simple;
	bh=aMrd8+W72u6mxwTvOp5WSUfxh/MJGgRIKRP/oLR/PRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNBC9mWz3+O7yhQ+ZgUwYhLFK2LfLh1BU3I1YO/XwYnlpVfp0LIWyH6jmNgAjqNP3ciyPz6ojSgm2g0yJ6rEFRXJZSikSFknACG3aBsIWghape+zNa6upmJcLtrCjmemGUWuimEBvt7fv2iOFUChbePjjGXBapR2NVcK6zKWZOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GhuY5jn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GhuY5jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBB1C4CEF7;
	Mon, 29 Dec 2025 16:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025970;
	bh=aMrd8+W72u6mxwTvOp5WSUfxh/MJGgRIKRP/oLR/PRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GhuY5jnXeU8CsAiBKy/BmiT3E2NppGW9+4N1rBk7vOJYgC7cvdS+5jdD+7Li8QYq
	 IjH22Rn6bLzuRotQ2xovvWRJd5Yy2JgykT6SY6YgFy+ZfCkUMUuoF5UnQZM0ZAc8v1
	 MAkM/OGbtyZRBiiE4FDI9X27M9lwGkZKNMAcmhhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 401/430] zloop: fail zone append operations that are targeting full zones
Date: Mon, 29 Dec 2025 17:13:23 +0100
Message-ID: <20251229160739.071569874@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit cf28f6f923cb1dd2765b5c3d7697bb4dcf2096a0 upstream.

zloop_rw() will fail any regular write operation that targets a full
sequential zone. The check for this is indirect and achieved by checking
the write pointer alignment of the write operation. But this check is
ineffective for zone append operations since these are alwasy
automatically directed at a zone write pointer.

Prevent zone append operations from being executed in a full zone with
an explicit check of the zone condition.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zloop.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -407,6 +407,10 @@ static void zloop_rw(struct zloop_cmd *c
 		mutex_lock(&zone->lock);
 
 		if (is_append) {
+			if (zone->cond == BLK_ZONE_COND_FULL) {
+				ret = -EIO;
+				goto unlock;
+			}
 			sector = zone->wp;
 			cmd->sector = sector;
 		}


