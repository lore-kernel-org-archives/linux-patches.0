Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8668D13F435;
	Wed, 19 Jun 2024 13:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802910; cv=none; b=T+CfZ1rlcPPzDWhNQUPaK9A+pFEu9KyFU/sU3K4ex79oukDeFUSGSxJ/J+6Uy9TS/cjgu3UX+8Zfp5D1qaqn72XVuhDFNWLcZaIrO3miCfYaGgy6e2Lv/QdfGK7iF0qBDJ6VFpL7anWlxBfOZFX/L3+HBSWN4D6769mKh+jwh2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802910; c=relaxed/simple;
	bh=2GVFJpKJC784hjAbmGaq83SRxJOZIGt3jQ79qZ6xCqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfFTjkwxnr6k7WGoILERmaoCCbM3ZhAOzMfTzNzh+iKuYgVAVjfddP3I2i+6kh7JGo++01tu93W/JXQhG03dKk2qYWdHYY8iwa9ir4G/XcmulNyG3QmuB684om1PQ7nMIyeGeuoRiguMtVjm4dxhT0bcxKaKmAFHZagNFahta1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W+dp9fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W+dp9fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0952DC2BBFC;
	Wed, 19 Jun 2024 13:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802910;
	bh=2GVFJpKJC784hjAbmGaq83SRxJOZIGt3jQ79qZ6xCqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W+dp9flPTs28NK4Jwr9sv47Re7XDMV84P310BQIknuKgcLLxYb73yBN1uYcjSWNV
	 dIEz8O2sjXRzGJT9eptGrVnsWxG3qSwcnGe1+FU4s2itpCXWf9Xrc3Bsknpp/OLtn6
	 hrl+baz0W7GOoDuaQ3iX2Tm8buzhONaNADDj+4Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadym Krevs <vkrevs@yahoo.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.9 089/281] tty: n_tty: Fix buffer offsets when lookahead is used
Date: Wed, 19 Jun 2024 14:54:08 +0200
Message-ID: <20240619125613.275781779@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit b19ab7ee2c4c1ec5f27c18413c3ab63907f7d55c upstream.

When lookahead has "consumed" some characters (la_count > 0),
n_tty_receive_buf_standard() and n_tty_receive_buf_closing() for
characters beyond the la_count are given wrong cp/fp offsets which
leads to duplicating and losing some characters.

If la_count > 0, correct buffer pointers and make count consistent too
(the latter is not strictly necessary to fix the issue but seems more
logical to adjust all variables immediately to keep state consistent).

Reported-by: Vadym Krevs <vkrevs@yahoo.com>
Fixes: 6bb6fa6908eb ("tty: Implement lookahead to process XON/XOFF timely")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218834
Tested-by: Vadym Krevs <vkrevs@yahoo.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240514140429.12087-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1619,15 +1619,25 @@ static void __receive_buf(struct tty_str
 	else if (ldata->raw || (L_EXTPROC(tty) && !preops))
 		n_tty_receive_buf_raw(tty, cp, fp, count);
 	else if (tty->closing && !L_EXTPROC(tty)) {
-		if (la_count > 0)
+		if (la_count > 0) {
 			n_tty_receive_buf_closing(tty, cp, fp, la_count, true);
-		if (count > la_count)
-			n_tty_receive_buf_closing(tty, cp, fp, count - la_count, false);
+			cp += la_count;
+			if (fp)
+				fp += la_count;
+			count -= la_count;
+		}
+		if (count > 0)
+			n_tty_receive_buf_closing(tty, cp, fp, count, false);
 	} else {
-		if (la_count > 0)
+		if (la_count > 0) {
 			n_tty_receive_buf_standard(tty, cp, fp, la_count, true);
-		if (count > la_count)
-			n_tty_receive_buf_standard(tty, cp, fp, count - la_count, false);
+			cp += la_count;
+			if (fp)
+				fp += la_count;
+			count -= la_count;
+		}
+		if (count > 0)
+			n_tty_receive_buf_standard(tty, cp, fp, count, false);
 
 		flush_echoes(tty);
 		if (tty->ops->flush_chars)


