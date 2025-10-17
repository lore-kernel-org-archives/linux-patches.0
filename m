Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3038C187332;
	Fri, 17 Oct 2025 15:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714054; cv=none; b=oM4bzxIDVlbflFvQ6WZFW8ouoTf+fqcRtAwyr8nzF/IJv1eHIYcAfKyj4b2rP0DvSjqQf/tVrfpJBKudrdIyifdgReCYZRFHKGvHlAeRBW9rMRZVQQOQOpKRQIFJypZftOwpGVy3y1w9KbejfRpuQET3L6cCbL8BahMYBBU1Bac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714054; c=relaxed/simple;
	bh=Z1GND/hE/rq/S09/hacUBJTXnQzCep68INTocIb1joo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4bRZYlw54hmLFkAlu5bPfGP68aiL8SFskAAOPI8jtEKicU5Tg3E0KlJGJxv8CN7LAGf5vj42oTjbIE8ROiOzqwje8z4MJQTB36ETCTiumm1FlMZBbrHdQhD5qE+Cu24Cwc6AkON/3P7kDw8jN5jl4pBWgbZN7Atotu7pWFC98o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qtzeefT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qtzeefT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6A8C4CEE7;
	Fri, 17 Oct 2025 15:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714054;
	bh=Z1GND/hE/rq/S09/hacUBJTXnQzCep68INTocIb1joo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qtzeefThL1Aa9q8cRCvVhlAX+pjZjWPYFZQUFxynu5fmdQbQfQcRwuhL3W6Dw9wH
	 V9WeN+tkfX7GQg3GbZJiSdvjg80gsufn8ef5oQXgq5z/I4rvFchfBXFT9/EsKTaJmH
	 hPnJxBumHLRMDBuEqySXm13YXoQOHcTXofGXcA78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 011/277] media: v4l2-subdev: Fix alloc failure check in v4l2_subdev_call_state_try()
Date: Fri, 17 Oct 2025 16:50:18 +0200
Message-ID: <20251017145147.558124384@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit f37df9a0eb5e43fcfe02cbaef076123dc0d79c7e upstream.

v4l2_subdev_call_state_try() macro allocates a subdev state with
__v4l2_subdev_state_alloc(), but does not check the returned value. If
__v4l2_subdev_state_alloc fails, it returns an ERR_PTR, and that would
cause v4l2_subdev_call_state_try() to crash.

Add proper error handling to v4l2_subdev_call_state_try().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Fixes: 982c0487185b ("media: subdev: Add v4l2_subdev_call_state_try() macro")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aJTNtpDUbTz7eyJc%40stanley.mountain/
Cc: stable@vger.kernel.org
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/media/v4l2-subdev.h |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -1952,19 +1952,23 @@ extern const struct v4l2_subdev_ops v4l2
  *
  * Note: only legacy non-MC drivers may need this macro.
  */
-#define v4l2_subdev_call_state_try(sd, o, f, args...)                 \
-	({                                                            \
-		int __result;                                         \
-		static struct lock_class_key __key;                   \
-		const char *name = KBUILD_BASENAME                    \
-			":" __stringify(__LINE__) ":state->lock";     \
-		struct v4l2_subdev_state *state =                     \
-			__v4l2_subdev_state_alloc(sd, name, &__key);  \
-		v4l2_subdev_lock_state(state);                        \
-		__result = v4l2_subdev_call(sd, o, f, state, ##args); \
-		v4l2_subdev_unlock_state(state);                      \
-		__v4l2_subdev_state_free(state);                      \
-		__result;                                             \
+#define v4l2_subdev_call_state_try(sd, o, f, args...)                         \
+	({                                                                    \
+		int __result;                                                 \
+		static struct lock_class_key __key;                           \
+		const char *name = KBUILD_BASENAME                            \
+			":" __stringify(__LINE__) ":state->lock";             \
+		struct v4l2_subdev_state *state =                             \
+			__v4l2_subdev_state_alloc(sd, name, &__key);          \
+		if (IS_ERR(state)) {                                          \
+			__result = PTR_ERR(state);                            \
+		} else {                                                      \
+			v4l2_subdev_lock_state(state);                        \
+			__result = v4l2_subdev_call(sd, o, f, state, ##args); \
+			v4l2_subdev_unlock_state(state);                      \
+			__v4l2_subdev_state_free(state);                      \
+		}                                                             \
+		__result;                                                     \
 	})
 
 /**


