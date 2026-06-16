Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC0847B403;
	Tue, 16 Jun 2026 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628736; cv=none; b=iLLZJgEYchVc3X95P2k6IpFmc5XDoKUb39cergg3T6iw/TjgCFlSa3d+3QVHCsGpqIuxs5Xyyq7DBBuy9eS29GxLgHDbW3WD8J5VPfJTPXOAZQnewPqFVb40tNb3R8Ti1pUVsbdn+QlsAbUsuuOo+mRE1uc57FcVLImX4QrTof0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628736; c=relaxed/simple;
	bh=D1nzB3X9np9ZE1H9Cx7awXSWeNVY8aki3LXRwarU4to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/7plVeyW135SlTr5Gp1uAONHWbIy2fM4hOPTz3wKnDndUDFL+W827eKX41MV6SF554ECpfrTEzTqJug0hfb2nSVYZ2o2U8mgtQeZwB41kixP38GNCV46hsfpwEWi2J3qtFCLg6C9KOHBIkXPBznpq/H6Da3GsaHr8jO0/jpCDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7zni56M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7zni56M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573B21F000E9;
	Tue, 16 Jun 2026 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628735;
	bh=m6DspL2ITJACQaQbXfK3vN1MMwSZANRNZoFwU6o100c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7zni56M4Ki0b6t+BdbcrC+wjTSLGqn8CGlIKARespAHFSQqj6pE/k0Hr+XOpspT2
	 nC7842ETGYbtZoVy2lJgEpbAfAybpo9fSQWSgPYkaztOPH8ta4aYyOeG66q2zSBKMP
	 XvakUql6PE3BfViYbIUeKLahvk7iD9if0WCiK1hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 145/452] Input: atmel_mxt_ts - fix boundary check in mxt_prepare_cfg_mem
Date: Tue, 16 Jun 2026 20:26:12 +0530
Message-ID: <20260616145125.313732805@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit baa0210fb6a9dc3882509a9411b6d284d88fe30e upstream.

When a configuration file provides an object size that is larger than the
driver's known mxt_obj_size(object), the driver intends to discard the
extra bytes.

The loop iterates using for (i = 0; i < size; i++). Inside the loop, the
condition to skip processing extra bytes is:

    if (i > mxt_obj_size(object))
        continue;

Since i is a 0-based index, the valid indices for the object are 0 through
mxt_obj_size(object) - 1.

When i == mxt_obj_size(object), the condition evaluates to false, and the
code processes the byte instead of discarding it.

This causes the code to calculate byte_offset = reg + i - cfg->start_ofs
and writes the byte there, overwriting exactly one byte of the adjacent
instance or object.

Update the boundary check to skip extra bytes correctly by using >=.

Fixes: 50a77c658b80 ("Input: atmel_mxt_ts - download device config using firmware loader")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260504185448.4055973-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1476,7 +1476,7 @@ static int mxt_prepare_cfg_mem(struct mx
 			}
 			cfg->raw_pos += offset;
 
-			if (i > mxt_obj_size(object))
+			if (i >= mxt_obj_size(object))
 				continue;
 
 			byte_offset = reg + i - cfg->start_ofs;


