Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B827A3C09E1;
	Tue, 16 Jun 2026 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633014; cv=none; b=fTNsG0lLBy8SoK5p3XWwUGfGMYNol1HvAtZCPLnt1nd4oRGyYadOCWCWM7l9BethQb/T/mx8Eg0wgQsJpPNLQ9li6K2PyiED/AUi98C8GglqBGOyXr+Gfs35obg3Gj/cKVhMyJnyezg49a/AOduBWgfjxgUcSP+EvJ9M2ZWU1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633014; c=relaxed/simple;
	bh=LT7cBtNoCJTHsZ5AjA3AKuHy5uCufNXl/biROmaDnhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSqAT81JvMlsdZSYQtiNy0/z4vVRgdrgPuuy9dccp0WOhHTA/A7FXkquEtLaJS8Z4caD6RPYo19/0NVFK87hGxdbvmQufyBGnM5rWdnbXTGrHNc38Wp9fveF7Q0naS8/VEW8+3NnmK0jdDRVDqR21Dp277Z8X2byT4SPxgjKTZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGdPRqK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGdPRqK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C066E1F000E9;
	Tue, 16 Jun 2026 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633013;
	bh=UEeopNKKF4RX2tLGKDtBQeODKbeyeQoVx+aWH94qGUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGdPRqK2Om1YPVwYiaI2mw25NEuAk1Glv/cmezhH0YgqOiak3Nw12rqRlKW26equt
	 fvRDwUptS+y1O8nnFmcWe5y+TobH8amYrE+R3YplRdRkvdzysDATM3416xXA3EqTm4
	 yPwwqpXt8Kc5dbPlJoRr68TJaXy2e9kxiwjsqORE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.1 512/522] drm/v3d: Reject empty multisync extension to prevent infinite loop
Date: Tue, 16 Jun 2026 20:30:59 +0530
Message-ID: <20260616145149.691657860@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

commit fb44d589bf3148e13452185a6e772a7efbf2d684 upstream.

v3d_get_extensions() walks a userspace-provided singly-linked list of
ioctl extensions without any bound on the chain length. A local user
can craft a self-referential extension (ext->next == &ext) with zero
in_sync_count and out_sync_count, which bypasses the existing duplicate-
extension guard:

    if (se->in_sync_count || se->out_sync_count)
            return -EINVAL;

The guard never fires because v3d_get_multisync_post_deps() returns
immediately when count is zero, leaving both fields at zero on every
iteration. The result is an infinite loop in kernel context, blocking
the calling thread and pegging a CPU core indefinitely.

Fix this by rejecting a multisync extension where both in_sync_count
and out_sync_count are zero in v3d_get_multisync_submit_deps(). An
empty multisync carries no synchronization information and serves no
useful purpose, so returning -EINVAL for such an extension is the
correct defense against this attack vector.

Fixes: e4165ae8304e ("drm/v3d: add multiple syncobjs support")
Cc: stable@vger.kernel.org
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
Link: https://patch.msgid.link/20260415050000.3816128-1-ashutoshdesai993@gmail.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -649,6 +649,11 @@ v3d_get_multisync_submit_deps(struct drm
 	if (multisync.pad)
 		return -EINVAL;
 
+	if (!multisync.in_sync_count && !multisync.out_sync_count) {
+		DRM_DEBUG("Empty multisync extension\n");
+		return -EINVAL;
+	}
+
 	ret = v3d_get_multisync_post_deps(file_priv, data, multisync.out_sync_count,
 					  multisync.out_syncs);
 	if (ret)


