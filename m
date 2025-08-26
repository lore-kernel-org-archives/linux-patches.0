Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B246D34DCCE;
	Tue, 26 Aug 2025 13:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216645; cv=none; b=ivTHn+jCtuvLONP72vXfi1R7gOhl7byT7apswNCSdreL/plwnFVexwZgM9XqG/MjUUc5TWlQojbyl6dH1T7dM5JL5fapVSFFIRCT6DdOBdWabXd3TTCxOYXmSd0x5kx93PUGnqM9F6BCth6orqEdkRS82uX3z+IBHndNUGqPYbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216645; c=relaxed/simple;
	bh=yKdF/Pkazn3fW9ociP4ZJ4R3KRh7hdPPm9xSSLqWNFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAo2kFZp11sg5Qus4S0Mc/C86umYSFpdDVaWbRBS8jDfYBNfmo/W7skGLOr6xNgQz17cAjjBvdS8gwpqwOT1C738dDimI5AlEm3twc5n42xn/3pLAlr7on+jCGnxDcMPaBauuvSgQ8mIIQZHZpX7xw9WpWF7+POMeY+LgfdrbNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0S+of93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0S+of93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4513DC4CEF1;
	Tue, 26 Aug 2025 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216645;
	bh=yKdF/Pkazn3fW9ociP4ZJ4R3KRh7hdPPm9xSSLqWNFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0S+of93vxvkHMRC2lJgdfQd4zIJs0E6qCPCqKWjhXearLdt39tSwnev7GkL264tK
	 tWFUj8j9bhrbLBpXS1ULXlPDFM+em0/TJV5m9IZA+fhl2mQEXmgflIyVWu2QyT9hOe
	 S2BUaMri8Mobja1A3i9VNhh3s5u2Q3qk1ONzkmZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5.15 489/644] media: v4l2-ctrls: Dont reset handlers error in v4l2_ctrl_handler_free()
Date: Tue, 26 Aug 2025 13:09:40 +0200
Message-ID: <20250826110958.609324211@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 5a0400aca5fa7c6b8ba456c311a460e733571c88 upstream.

It's a common pattern in drivers to free the control handler's resources
and then return the handler's error code on drivers' error handling paths.
Alas, the v4l2_ctrl_handler_free() function also zeroes the error field,
effectively indicating successful return to the caller.

There's no apparent need to touch the error field while releasing the
control handler's resources and cleaning up stale pointers. Not touching
the handler's error field is a more certain way to address this problem
than changing all the users, in which case the pattern would be likely to
re-emerge in new drivers.

Do just that, don't touch the control handler's error field in
v4l2_ctrl_handler_free().

Fixes: 0996517cf8ea ("V4L/DVB: v4l2: Add new control handling framework")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -992,7 +992,6 @@ void v4l2_ctrl_handler_free(struct v4l2_
 	kvfree(hdl->buckets);
 	hdl->buckets = NULL;
 	hdl->cached = NULL;
-	hdl->error = 0;
 	mutex_unlock(hdl->lock);
 	mutex_destroy(&hdl->_lock);
 }


