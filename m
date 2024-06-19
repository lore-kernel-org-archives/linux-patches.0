Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAEB14D6FF;
	Wed, 19 Jun 2024 13:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802190; cv=none; b=W/7Q+oY2czBacG5EbovEge7QWGZrrGdj3eaNVL49AUE+G2ZGwldzw17a88BEMbno0OQXhqbTeMQpv0kHAuRI+Qp5s8PZIhyHLPt1ap6lVS/zXDJLBf6VCSZbu0L1uFIYWHYByUZe2UKRV5CAJI3ToJ80NOOgWG9COPQVPFunis8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802190; c=relaxed/simple;
	bh=0Iy5QIXpapFQblTvygagHYZt+Rpgr72YVw6EDx1OA7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MpW0Wv7/G58c87qw13CT3jpcfZ2pdUiMB2cMcx8l6V0tq+xVw61Gc/YnONJCQyweYRhFm17W7hZ23fCAzBVSk+y2xH9wHDFKNnlvzcvwKNkmtzQyw/RdRrPYLaVazn7GHxJcUnpQK5+2m5BfsVjECEOYsX8M+ObTmIBCU6fFeDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQno8KaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQno8KaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10546C2BBFC;
	Wed, 19 Jun 2024 13:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802190;
	bh=0Iy5QIXpapFQblTvygagHYZt+Rpgr72YVw6EDx1OA7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQno8KaPHr8vN+w65tq+Q7ff+GoQm3I82mvwP+tzaXH9kfy0fqN2s5ofsrumKCOIN
	 GGRLsdzVbWNLsik5FX01JxDmDdpKPcYDE0yteQJB43gOrZ+pVEHGzixi3vESer2EhO
	 zNi7MWrLyDE5alciZnHuSG91xr4KI67F7RbgKXlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadym Krevs <vkrevs@yahoo.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 085/267] tty: n_tty: Fix buffer offsets when lookahead is used
Date: Wed, 19 Jun 2024 14:53:56 +0200
Message-ID: <20240619125609.613317546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1624,15 +1624,25 @@ static void __receive_buf(struct tty_str
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


