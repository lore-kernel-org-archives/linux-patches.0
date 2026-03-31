Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AB842EEB9;
	Tue, 31 Mar 2026 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975177; cv=none; b=TTAGRu3vgM7xJlZRqulzA3749vW1q5L5GdJCn76R/+9qlfwAexQiKEXctxTZBnzogKaqDOV/oTaIpZ78c66smtb1TGEM0tzbHk5ommKqfegtWTTTCtl+HdBSNatVZZb6cfa7DJRbdooGU/736ZaEtGtaDk4rm+oURpuH6EFz5MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975177; c=relaxed/simple;
	bh=0/02UBJyxXoVWtB6laSlmoTG1Iy8vwUuWSGcVieAQoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXIrujy+UHa1CDVqHbM7s1k7KY9ZHzPJmDiCnIa7tBaH1ObgOObDoxVph9c6fUQkT6SQozWBZVhfPc+l2BFtX19lb2sOqwGRDsiLmevfNNEfNgZqzfb3a960PXh5dhk+Roe8nScaWdpbH7xGmeYuJP//mqbyYPQ5mx1LlCilo0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pB4Y98Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pB4Y98Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F5DC19423;
	Tue, 31 Mar 2026 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975177;
	bh=0/02UBJyxXoVWtB6laSlmoTG1Iy8vwUuWSGcVieAQoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pB4Y98YWearFUVqTTO3NhWji3BwA5CkHXxIIPlD2vRjH/nmvMK4iwi9Hn2zBKRdI
	 JTCrI2DwqPP9OkvfrrUPbBa56XWBYR/vYsNYYgxjDY6yIpQFUx0pEWybcGMyV6YuHe
	 VI0nTWQlry6Jfj5MWhBBeeSrvE7/0tG4lGJqJxrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 192/342] io_uring/fdinfo: fix SQE_MIXED SQE displaying
Date: Tue, 31 Mar 2026 18:20:25 +0200
Message-ID: <20260331161806.060589342@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b59efde9e6c122207c16169d3d0deb623956eae9 ]

When displaying pending SQEs for a MIXED ring, each 128-byte SQE
increments sq_head to skip the second slot, but the loop counter is not
adjusted. This can cause the loop to read past sq_tail by one entry for
each 128-byte SQE encountered, displaying SQEs that haven't been made
consumable yet by the application.

Match the kernel's own consumption logic in io_init_req() which
decrements what's left when consuming the extra slot.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 80178b69e05a2..25c92ace18bd1 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -125,6 +125,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 					sq_idx);
 				break;
 			}
+			i++;
 			sqe128 = true;
 		}
 		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
-- 
2.53.0



