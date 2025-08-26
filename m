Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA31118F2FC;
	Tue, 26 Aug 2025 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213596; cv=none; b=id3PkmmNNVG5SY1tUlKXLLyeLa8StlAPLf85Xw8sPuw8IvKu9vCUjoFAkVxlYaPzgPjPXifBUDGcJjCMAKGgL2udkEKhz7gb2bfpFEbaaFWl7dvX4n7UgoBmwOXKBmGAbQNQdqAyamzDj9u05ydEr4O/KVX5vm9V5eJ1kLgKxdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213596; c=relaxed/simple;
	bh=FePxn+B35CSIZmHk8qrOb1C7GILlSRSRwLhl0yMkb9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAmmN1CbHKtOyMpAyhmwLoYmjdk8HAof9VWUI/nZtqgiOSCxRJ67deSIoHgKo05AIhj9sVNHEP31OMbb5tS9T432mg8xvts0AM8rGvtN7nwYpQtiSFrDSwuma/R97L6QmeMClJlXNqbXKZUetFCP3su1eULXsu6ey5qSg0FWdWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQUTvsf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQUTvsf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ACBC4CEF1;
	Tue, 26 Aug 2025 13:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213596;
	bh=FePxn+B35CSIZmHk8qrOb1C7GILlSRSRwLhl0yMkb9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQUTvsf73UvYoz1a9Hl9ZQnCg2hDp+Z5+nTj5dCFLVb2EhzLP+C0TSovO0pB4XHw1
	 v53jM949Xs9Swj5OooUCkOKye+cY8PhwLi6O92Qu/RhaBBNehFw1Z8niH5WzxYhBTp
	 Iz7E1nRYkxiFUInorCG9Tkk9t+a910OEfB8aT8e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.6 406/587] media: v4l2-ctrls: Dont reset handlers error in v4l2_ctrl_handler_free()
Date: Tue, 26 Aug 2025 13:09:15 +0200
Message-ID: <20250826111003.255431478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1578,7 +1578,6 @@ void v4l2_ctrl_handler_free(struct v4l2_
 	kvfree(hdl->buckets);
 	hdl->buckets = NULL;
 	hdl->cached = NULL;
-	hdl->error = 0;
 	mutex_unlock(hdl->lock);
 	mutex_destroy(&hdl->_lock);
 }


