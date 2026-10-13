Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940033B1EE7;
	Tue, 13 Oct 2026 11:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892116; cv=none; b=uCYpahUrhRPZ8/sEIgqElF8WV8jJzee1tDDA3jUQodNYzYmyFd9Xbu0JDZRzEocopeRijOcG47WeP7m81yOptUns8Iwp0NJReSGoPOE1i1yRTbAldaSKuLH+hTiGWCr2cAeJgiPEvJj8TxxNdvz6ffDj5s9RuwPp+Kfp+S/+Lyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892116; c=relaxed/simple;
	bh=6PowfluB8CPrUY2nN9BecYCY8LuOsy8sA8ncvUwkOxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk1e2JS53qFnqTjgy2JE9fiJ2MYUoJIVHy1YtSVme27AR5rf1PIn2oK6bTeHjVZvO+dLrg9ekohV2a+CwdMDh/emiYOFq2g7Xn6lAfkmi9czapr66cPIhgQF+Nd0A10BocEEN0kFNH84tK9DYSey3DQqOMzY6Lg2OKTsNX50/1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfT61rDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfT61rDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7E91F000FF;
	Tue, 13 Oct 2026 11:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892114;
	bh=iG9t6DKct3UOvQ0Zy7Dh754s9BJm70xIP76e0gSLkaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfT61rDxCrj6lAqU58uX+fD08PEoufAVoi+xREsA0NXme1aIdbJT1pRGVvVHrFxUJ
	 Of/dXUYq9NMGBPe5l3lWwHRyW10NXsppSnljp2XmajgudNIrVwBm3dBhYi7RGMffrw
	 ITJqNn0VEZa68rWnktG61MxOszqo25LMs4Xoh/K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Gvozdetsky <gvozdet@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 064/281] io_uring/register: dont exempt disabled rings from task restrictions
Date: Tue, 13 Oct 2026 13:36:20 +0200
Message-ID: <20261013112856.681912775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Gvozdetsky <gvozdet@gmail.com>

commit 6da8f402e362b2f546e2efb7167fc9597aef6faf upstream.

A ring created with IORING_SETUP_R_DISABLED is exempt from its register
restrictions until it is enabled. This lets the creator register the
restrictions and then enable the ring with IORING_REGISTER_ENABLE_RINGS,
whether or not that opcode is in the allowed set.

Since commit ed82f35b926b ("io_uring: allow registration of per-task
restrictions"), a ring also inherits restrictions from the task that
creates it, and the same exemption applies to those. A task whose
register opcodes are restricted can therefore create a disabled ring,
issue any register opcode on it, and then enable it.

Mark rings whose restrictions were inherited from the task, and keep
checking register opcodes for them while the ring is disabled. Enabling
such a ring now requires IORING_REGISTER_ENABLE_RINGS to be in the
task's allowed set. Per-ring restrictions registered on a disabled ring
work as before.

Fixes: ed82f35b926b ("io_uring: allow registration of per-task restrictions")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Eugene Gvozdetsky <gvozdet@gmail.com>
Link: https://patch.msgid.link/20261009-iouring-task-restrict-fix-v1-1-a49daf55a12c@gmail.com
[axboe: amend with inheritance flag fixup]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    2 ++
 io_uring/io_uring.c            |    3 ++-
 io_uring/register.c            |    9 ++++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -316,6 +316,8 @@ enum {
 	IO_RING_F_DRAIN_DISABLED	= BIT(10),
 	IO_RING_F_COMPAT		= BIT(11),
 	IO_RING_F_IOWQ_LIMITS_SET	= BIT(12),
+	/* restrictions were inherited from the task that created the ring */
+	IO_RING_F_RESTRICT_INHERITED	= BIT(13),
 };
 
 struct iou_ctx {};
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2967,7 +2967,8 @@ static void io_ctx_restriction_clone(str
 	if (dst->op_registered)
 		ctx->int_flags |= IO_RING_F_OP_RESTRICTED;
 	if (dst->reg_registered)
-		ctx->int_flags |= IO_RING_F_REG_RESTRICTED;
+		ctx->int_flags |= IO_RING_F_REG_RESTRICTED |
+				  IO_RING_F_RESTRICT_INHERITED;
 }
 
 static __cold int io_uring_create(struct io_ctx_config *config)
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -764,7 +764,14 @@ static int __io_uring_register(struct io
 	if (ctx->submitter_task && ctx->submitter_task != current)
 		return -EEXIST;
 
-	if ((ctx->int_flags & IO_RING_F_REG_RESTRICTED) && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
+	/*
+	 * A disabled ring is exempt from its own register restrictions, so
+	 * that the creator can set them up and then enable the ring. That
+	 * does not apply to restrictions inherited from the task.
+	 */
+	if ((ctx->int_flags & IO_RING_F_REG_RESTRICTED) &&
+	    (!(ctx->flags & IORING_SETUP_R_DISABLED) ||
+	     (ctx->int_flags & IO_RING_F_RESTRICT_INHERITED))) {
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;


