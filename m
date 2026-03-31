Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1534E262A6;
	Tue, 31 Mar 2026 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975414; cv=none; b=OrsZHzVBki9l2ycjTKw1eAgkesY/MMbsgK7E4zvF2iBNZbHqQHfH/3eK+MTz06WaigQRzCO0ifiJZHIdSDaVc2PvgytG/jmvLPKkiY5ap5TmymgpZrb5taoN8hd7X3xuQStbSf3Tz530CCUn97HGyhy9QacuTIltcvo4Vqz4moI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975414; c=relaxed/simple;
	bh=Hy9iMdSvtNxG9I4QeyUUT2iG7dFjgr1XJk3iYd8L6EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lZCKoMhQCFd5XXSc5PKznv6s32GpoIjEG98QAvoBiPwVWAI9CgwMf9UeVs1xO1BO+ZAFRSwRw//7Usb0d54U+yC9F5tqtxBuJJkk0eHHIvGQ6lYWZbT7PXUpG5vs+gIj6kageQiSdxZ4MOrj2Hje+gK4+B0bziUanvXi5PaVYqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXJe5Uv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXJe5Uv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABB1C19423;
	Tue, 31 Mar 2026 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975414;
	bh=Hy9iMdSvtNxG9I4QeyUUT2iG7dFjgr1XJk3iYd8L6EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXJe5Uv2f1i5NJEEhoHiWLtEvBDYLF/ymtII2JlxwZbUflz2z78A4H7qnsfwPlym/
	 6smefhFUAUQ0v9QPyvqkiu6BZvF7fwgDh+7YDl5MKHtQmelmVa+HZ1gnzjaBRVDRo9
	 wOJV8ExDF69bof4o07gggR7E4ESDe3+x3rS37oTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.19 268/342] drm/i915: Order OP vs. timeout correctly in __wait_for()
Date: Tue, 31 Mar 2026 18:21:41 +0200
Message-ID: <20260331161808.810394315@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 6ad2a661ff0d3d94884947d2a593311ba46d34c2 upstream.

Put the barrier() before the OP so that anything we read out in
OP and check in COND will actually be read out after the timeout
has been evaluated.

Currently the only place where we use OP is __intel_wait_for_register(),
but the use there is precisely susceptible to this reordering, assuming
the ktime_*() stuff itself doesn't act as a sufficient barrier:

__intel_wait_for_register(...)
{
	...
	ret = __wait_for(reg_value = intel_uncore_read_notrace(...),
 			 (reg_value & mask) == value, ...);
	...
}

Cc: stable@vger.kernel.org
Fixes: 1c3c1dc66a96 ("drm/i915: Add compiler barrier to wait_for")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260313110740.24620-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit a464bace0482aa9a83e9aa7beefbaf44cd58e6cf)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_wait_util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_wait_util.h
+++ b/drivers/gpu/drm/i915/i915_wait_util.h
@@ -25,9 +25,9 @@
 	might_sleep();							\
 	for (;;) {							\
 		const bool expired__ = ktime_after(ktime_get_raw(), end__); \
-		OP;							\
 		/* Guarantee COND check prior to timeout */		\
 		barrier();						\
+		OP;							\
 		if (COND) {						\
 			ret__ = 0;					\
 			break;						\


