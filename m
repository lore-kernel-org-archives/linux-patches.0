Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EE712C462;
	Tue, 30 Apr 2024 11:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474888; cv=none; b=n1J8Rs/+dCZ+u3o314Anx6vqo/GZ7c2spl7VcG+D2TALQPFTjanQ5CZ4/SfLA1w9b1RWxTUzO96/+ULXZ/CbbZkFD4Zxvhp9Myn6lRBi1u8rPMUYEiiYNoK6bcxF0HxYb0QQrkjTp/Fftgv+fm0p+/wjTVKnfX3R7CcArgh31YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474888; c=relaxed/simple;
	bh=blvGQYZkQolPD/F40j/3wuCjuUXtqM0nQ53igxogk4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcFOThSPATxxi2X0svQUvo+TSXhCOGzAcMG/Hhy0Eegv/p72K0WkRA6f5TOmp8i78a5RpN1MGT+eIUtiLdJU3wqJyfuHwi44QZLuyZN8WlZ31puk1sQ2lHaT597KvG2vgnRu1pyF+8ZeMDneKmlhGkQskOg8DCuij60GNJ8UESA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peY0XZIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peY0XZIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D0CC2BBFC;
	Tue, 30 Apr 2024 11:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474888;
	bh=blvGQYZkQolPD/F40j/3wuCjuUXtqM0nQ53igxogk4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peY0XZIoR8JAXP/Eq7pm+qlL/AbUxnHpk9asIV48QYY7kkHmt1/y8P1LNSy5B/Gr+
	 +H1mBcQDmUoUF0xwRvhvQk8x4OCz2j/be59UvszOFbYEUlPvkwT7hUz1pd87PIuGYV
	 XOQtZw6gh6PWIPoTXya5lPnGptvy9w0hecHAw9BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.10 066/138] speakup: Avoid crash on very long word
Date: Tue, 30 Apr 2024 12:39:11 +0200
Message-ID: <20240430103051.365943721@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit c8d2f34ea96ea3bce6ba2535f867f0d4ee3b22e1 upstream.

In case a console is set up really large and contains a really long word
(> 256 characters), we have to stop before the length of the word buffer.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: c6e3fd22cd538 ("Staging: add speakup to the staging directory")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240323164843.1426997-1-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -576,7 +576,7 @@ static u_long get_word(struct vc_data *v
 	}
 	attr_ch = get_char(vc, (u_short *)tmp_pos, &spk_attr);
 	buf[cnt++] = attr_ch;
-	while (tmpx < vc->vc_cols - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


