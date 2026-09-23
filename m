Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC62F51CF76;
	Wed, 23 Sep 2026 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175048; cv=none; b=XJE9fPJc52Y1KJxpmqzaKirvmKWRHcZ/9k+d4x5VD0jZHrQcDltRx6LNFWpTUOMRH/nZgY+0UQcgDHzFtYO6w6GFgnTnymupPr5lBOCebjwkY/BN9geGcSvM957ZZ70HmRTQJisjQuFuoayIKXGLUjQBG0kn/3TlRYfvK9DITkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175048; c=relaxed/simple;
	bh=XtTEGH3ecdqLVH7VBkEQsBJZds68C+/r/x1Gke85Uw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C0Yi0khZaoXT6PJp3bC/HI2Rlz0EzSofLyCrumu0JpsQWE5acQ+GFmugSR/XeBJiflKFjt7QsBWN68mDtzObdWIYmySFVFwLmPwrzCBiVSFWLbdxv9UPhAVeyR54AgRPYz7uQgFIK64vYcKoh15jGSAGeL1WPV1/XSQCyVMPcfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWmIFlna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWmIFlna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170291F00893;
	Wed, 23 Sep 2026 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175046;
	bh=qUWzn+PhMnm6n7W8RvdvkujjEbg1ShcKBUQQAy5UhwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWmIFlnaoqaMIZ9f6EuQQ/N/3XbWc6FR10ry+u/LJVRTIhHW5M8IwhfSOdDeB9U6g
	 KB+ZskbzvtD56oik0iw7eqUtxWUbwn6OJQ9vXUboTFKld8NhB3U7z2sVdD9cgzgDn/
	 XLs63Q+2mDdTqYZJHRst4BMJdP361JPAfU+mLtRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 305/398] Input: zero ff_effect before compat copy in input_ff_effect_from_user
Date: Wed, 23 Sep 2026 16:06:19 +0200
Message-ID: <20260923140651.326637508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

commit f84819ef8d66931ee3998fee3c4f03230f4cb6cc upstream.

In the compat path input_ff_effect_from_user() aliases the caller's
native struct ff_effect with the smaller struct ff_effect_compat and
copies only the compat sized prefix:

	compat_effect = (struct ff_effect_compat *)effect;

	if (copy_from_user(compat_effect, buffer,
			   sizeof(struct ff_effect_compat)))

The tail of the native structure is never written. Callers pass an
uninitialized on-stack object, for example evdev_do_ioctl() for
EVIOCSFF, so those bytes keep their previous stack contents.
input_ff_upload() then stores the full native structure in
ff->effects[id], from where a uinput based force feedback daemon can
read it back via UI_BEGIN_FF_UPLOAD, disclosing kernel stack memory to
userspace.

Zero the effect before the compat copy.

Fixes: 2d56f3a32c0e ("Input: refactor evdev 32bit compat to be shareable with uinput")
Cc: stable@vger.kernel.org
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Link: https://patch.msgid.link/20260901130629.24078-3-ivanrwcm25@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/input-compat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/input-compat.c
+++ b/drivers/input/input-compat.c
@@ -76,6 +76,8 @@ int input_ff_effect_from_user(const char
 		 */
 		compat_effect = (struct ff_effect_compat *)effect;
 
+		memset(effect, 0, sizeof(*effect));
+
 		if (copy_from_user(compat_effect, buffer,
 				   sizeof(struct ff_effect_compat)))
 			return -EFAULT;


