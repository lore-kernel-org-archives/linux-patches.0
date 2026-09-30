Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7072350B437;
	Wed, 30 Sep 2026 15:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783731; cv=none; b=logBSGsqw8wInX8zS6De8Ba5kqe+FyB0Ky4ggDIW7mIe3A3Iqydaau0MJVed43ZAoHDC+bAEhWzRzzqfdyp/CKCWPzHCQZlb9A20S9kZ9+eDm+bsoOMPgo0t3DNi5CXcPP2VOpRWStSkeWRoAGH4Aa7NG1Gm90hSRl7eFmQhQ8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783731; c=relaxed/simple;
	bh=ROmzoXm47dkmebfmsy6KkpN0ZkIjGNkwss8wXXljnNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ClLXu8InTOEV9C+Cndrr7rDGvYzo1B/Fc7b6GIV0imyEGAphtaca8UuCWs3/ITI0B/CLyT+dGZotW+H5rGmMHLMJ3/FJmf0WnQ28UcuooQn4QbEGirT25+VTQ1h8qpJ/BCHO2eKzI8JhNa4Nq+ZGiCoptUn/o4edJ5I3eR1QrCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKrtevHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKrtevHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BA71F00898;
	Wed, 30 Sep 2026 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783727;
	bh=MaMPXZysBKkpYGfpspzNDiDRfMVAva5ivc1YqZi6uOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKrtevHz4aBpSGF2TVSplG+D6nKOnLbgfuwq2higB5IsG66caBYH3TnmIvWZnhMpV
	 IuAEn3Tx+eMPX+uPXW9zzezEoVP/D+baWVxs0vxEPda0pOd4hnumGEYVMBJaxPhL99
	 18U0W8XLmH3GOIBdnavmXb5fqQiPQted8KJAI7pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 456/595] Input: zero ff_effect before compat copy in input_ff_effect_from_user
Date: Wed, 30 Sep 2026 17:25:49 +0200
Message-ID: <20260930152357.490676177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


