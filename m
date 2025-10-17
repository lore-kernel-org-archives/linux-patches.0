Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECD13328E8;
	Fri, 17 Oct 2025 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713483; cv=none; b=sUAyLsi/a5meXLXsMnpXQ7T901SuuXEskR1aUmg3c9ExuD7347ncuqLIxwnoIHyff5/227GGz8d+CbiqJR1Ve77WLsRtPYmVrYPcqVJLSQj8oTHWVHXN8aNDoJctcuxJm1uS0hVBf3ctGjAni6jXH2f5fgePNQ7YL0svJ638xEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713483; c=relaxed/simple;
	bh=nbIrV75eUPq1tqavNi8AxSzHuOqBa7/HOIUzhT+ZH1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxAE6EcKSMRA6N2XOBSBDlGXOcx8J8Oo7nPYmfqe9vm4yPaf20+aUgqX+QEXYLb3tpvXn40QhWLNHqs5uZiA+8pZ4a9xeu8QWlLoX2zl9epmwsB4LoEbTJzAQ/uscLGFNZC5KasZVA9kQSf6QCQfPicwf52P4WappPl3HdunpEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wn7DQbXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wn7DQbXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5CFC4CEE7;
	Fri, 17 Oct 2025 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713483;
	bh=nbIrV75eUPq1tqavNi8AxSzHuOqBa7/HOIUzhT+ZH1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wn7DQbXXhuqPCxGDffmInhg972S/kgQjXhZIW9IMEx7FmawyiTJO9rUxBpLe1rzzg
	 GtmzK2ln3uMRWcVtotKsZQ6PArnVNjYB7Tch7mSEMuoeex0QkHEPd7qai10CON7Dzn
	 gp1GDmiqDQQ7r74C5uNxt/8BDCkmGjv+e30xT3lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 005/201] media: v4l2-subdev: Fix alloc failure check in v4l2_subdev_call_state_try()
Date: Fri, 17 Oct 2025 16:51:06 +0200
Message-ID: <20251017145134.923799575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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
@@ -1881,19 +1881,23 @@ extern const struct v4l2_subdev_ops v4l2
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


