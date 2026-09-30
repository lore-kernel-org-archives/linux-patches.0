Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF4B4A8430;
	Wed, 30 Sep 2026 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788782; cv=none; b=FxgXiCK9czuSHa4MS9Q9yo97Ho5bNi/e9SH6nzRmzsJ6CpC/CjCWfEPk1ADoMFT65XOumo3NwZFczWKKHdIdIHbIP/97ezVXz7K5eRBnAVpCwuuTHpJYIxUUKTIXBx8D6OEBrvxg1p8pHkMBMK8289jNctQ3cc4SXQ2rjI8pMwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788782; c=relaxed/simple;
	bh=5hIWtSwhIevp1wcX2Yc8ApzLI+OLC9O1hrpHcTKPQJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpSDJLSV4Q7eXIYG5/ZU+S8ZG8XhFJVNeiquwR+TTetSMec30tjoPbUxIiG6kC5y1W9huMiemwbAQC0yo4jmUUr/X84c+pa4M47yjFbOKwqYvSeNaQP6dFmrw0e5cNE9A7XZ0atATqUVYByWdTaVVM5pP1zxUt/rEif1oWMolR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jg4+tlUW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jg4+tlUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205BF1F000FF;
	Wed, 30 Sep 2026 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788781;
	bh=C9ZHzfQqhuY4i3tWYGS4tvxpQ6P+vazg1P0lQE/Y68I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jg4+tlUWgHxLdTbwMi2jJIIju9iEiOUG04VHDKrHfrSl+bmZ7MAuXVViZbIHiyMXo
	 JoPtL+wWi9ZmQOvhtF59kggVlteH6P8aXpqmM1jDqa6/WzRnMpKzHFHX+6lDEgw+ip
	 g7BVPqkPAAwZvPW0cif+k9e86wxtjmXBkubLTImw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 245/877] Input: zero ff_effect before compat copy in input_ff_effect_from_user
Date: Wed, 30 Sep 2026 17:19:16 +0200
Message-ID: <20260930152420.011653906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -75,6 +75,8 @@ int input_ff_effect_from_user(const char
 		 */
 		compat_effect = (struct ff_effect_compat *)effect;
 
+		memset(effect, 0, sizeof(*effect));
+
 		if (copy_from_user(compat_effect, buffer,
 				   sizeof(struct ff_effect_compat)))
 			return -EFAULT;


