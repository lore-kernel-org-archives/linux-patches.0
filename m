Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC7526F47B;
	Tue, 25 Mar 2025 12:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906393; cv=none; b=QYGUsKevQRRODvz3dR3kS/2ssZdiPsFpLBy8bb0W6huWwGn7EajTO/05ozUftYPvkeId9AdgTcIRBs2Rog8anWN2VyzhOTRIcqTMZrYTimDIT7CCiz+PjBr9cd64zgPqKMPs8TGmfcoTrTm9+nzRBnYLu3Vk8IidDKucQO5yBdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906393; c=relaxed/simple;
	bh=KdRcj19A2BlXwqXwAodBcueXtHqEybJL7KeycZ/v9SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkNKwhUDDCygQYdrpOs94KrPQbSkUU8uqSnlGytOsEZXmdPfommnZql7s2VqkvpUFoguGOPr+WQziIONancr2Kn0mDpbGc/aA1p+o57hk+Mb9P0bDvM+guuuWE8QsbZ3HWOKnyXIUgn9EJjCy/dHdkaAveqIbDkXEtauMegLTBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxzoAwVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxzoAwVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49A1C4CEE4;
	Tue, 25 Mar 2025 12:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906393;
	bh=KdRcj19A2BlXwqXwAodBcueXtHqEybJL7KeycZ/v9SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxzoAwVxf0u27YSD0qBTobZAMQvdFXBIGAiAWX5M9iuXaE6wth7oN7ti7vlC1nT6D
	 dBPdwj0eEHjEC/UDiqlfT9SJiG5kEB64xtJD1XQG4QX7+sE7yP0UDQxsz1TSoUNOxn
	 qPCj+iGdLTjbrWY1WDVrV/hGBn3RXoAu+XVWlA/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: [PATCH 6.12 066/116] accel/qaic: Fix integer overflow in qaic_validate_req()
Date: Tue, 25 Mar 2025 08:22:33 -0400
Message-ID: <20250325122150.898692900@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 67d15c7aa0864dfd82325c7e7e7d8548b5224c7b upstream.

These are u64 variables that come from the user via
qaic_attach_slice_bo_ioctl().  Use check_add_overflow() to ensure that
the math doesn't have an integer wrapping bug.

Cc: stable@vger.kernel.org
Fixes: ff13be830333 ("accel/qaic: Add datapath")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/176388fa-40fe-4cb4-9aeb-2c91c22130bd@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/qaic/qaic_data.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -557,6 +557,7 @@ static bool invalid_sem(struct qaic_sem
 static int qaic_validate_req(struct qaic_device *qdev, struct qaic_attach_slice_entry *slice_ent,
 			     u32 count, u64 total_size)
 {
+	u64 total;
 	int i;
 
 	for (i = 0; i < count; i++) {
@@ -566,7 +567,8 @@ static int qaic_validate_req(struct qaic
 		      invalid_sem(&slice_ent[i].sem2) || invalid_sem(&slice_ent[i].sem3))
 			return -EINVAL;
 
-		if (slice_ent[i].offset + slice_ent[i].size > total_size)
+		if (check_add_overflow(slice_ent[i].offset, slice_ent[i].size, &total) ||
+		    total > total_size)
 			return -EINVAL;
 	}
 


