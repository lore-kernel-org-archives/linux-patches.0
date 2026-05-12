Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A12342509;
	Tue, 12 May 2026 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609422; cv=none; b=oxgHn59SZ3Kl4WM1qpr+DvEwKxIA4hFUxUa/gr3rb31uF/s6l52RTO+e6FG/wwgbbq8oni1pALUtL+LZqu1dcj98oy62+gLltcK+AYQ5z2N0zfzKwxEs7JfzdXWHCGIenZD4qI+05uWPSkv90Yvi/HSCtQKCk/zJOc5J30v+dFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609422; c=relaxed/simple;
	bh=cvtPjL8CUkILUbgBYAE0LL+QNF/jU3vpaqJIBwH/Drs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLyKwcYie39n0i165TnuUvNh/yOMZi/0by1rSGizDJy2JyzRTQ9nUjt8JloqVR06HspGR7SNuMxBwhSYsz1dMzSVXCTLhy8w3R+yS+kPDPM1qDyAuXcO4luCFj+w4HghcUfcB4bGuqBl9oJCil8f9knm7c4nsfAFnF+QNoD6S0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luBlelkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luBlelkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7781C2BCB0;
	Tue, 12 May 2026 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609422;
	bh=cvtPjL8CUkILUbgBYAE0LL+QNF/jU3vpaqJIBwH/Drs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luBlelkXx1XUdUvdd1F67Nyxw/o845uczZ0QwmqNxF5nP6tHm9YbEUPYYtT1HN9fN
	 cf/2GMjgdHKNeI/103zFL7D+7yxDQusld9A80TD6q726QN7iory15czkkm0OdcDIp/
	 WHAszfEQWGwf7q9XhI6xsDxXCn3HOQbAzi9pxFZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.0 188/307] dm-verity-fec: fix the size of dm_verity_fec_io::erasures
Date: Tue, 12 May 2026 19:39:43 +0200
Message-ID: <20260512173944.084049317@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit a7fca324d7d90f7b139d4d32747c83a629fdb446 upstream.

At most 25 entries in dm_verity_fec_io::erasures are used: the maximum
number of FEC roots plus one.  Therefore, set the array size
accordingly.  This reduces the size of dm_verity_fec_io by 912 bytes.

Note: a later commit introduces a constant DM_VERITY_FEC_MAX_ROOTS,
which allows the size to be more clearly expressed as
DM_VERITY_FEC_MAX_ROOTS + 1.  This commit just fixes the size first.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -47,7 +47,8 @@ struct dm_verity_fec {
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	int erasures[DM_VERITY_FEC_MAX_RSN];	/* erasures for decode_rs8 */
+	/* erasures for decode_rs8 */
+	int erasures[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN + 1];
 	u8 *output;		/* buffer for corrected output */
 	unsigned int level;		/* recursion level */
 	unsigned int nbufs;		/* number of buffers allocated */


