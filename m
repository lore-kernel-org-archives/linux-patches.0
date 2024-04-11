Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB769149E10;
	Thu, 11 Apr 2024 10:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831650; cv=none; b=CzxVCRBZNgEN8DThlhmTMnZkpnbo1hZdQ27/nF4I76ZH0Ui9XRWASDtsTpgOJhbdsl7Oqp1yW2pTpyoZ3KL/erC7d6vB0ApTza45ALyZsz8m1eH8yzNZH28Wnv295dk/d50gXvxC4LM8x9Ftt5Og0gwK3i4QkdLz63Oh/nYafwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831650; c=relaxed/simple;
	bh=m1/UaqFyUGYK0jG1UjY/L1K+IUUjnhFXta4SveZJaz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlOuG8noajgd/1A6eNFVnn+SxAmBJ3tXIjXKycmzQj+mIKCqW74zjuKk/hv6KP+mqDmDTFXzBdzdM7Z/Pe7m14e3gokqVE2S6zMdwWjCKGzz0NesziuUo/4O77x+eoebG6XAJ0V7mun5jifuaCmYFvRcvwzcHqm8Pebs7NUcwqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HD80OSdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HD80OSdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5171DC433C7;
	Thu, 11 Apr 2024 10:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831650;
	bh=m1/UaqFyUGYK0jG1UjY/L1K+IUUjnhFXta4SveZJaz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD80OSdXAA5x196JzBO1zKnxi9nWItUY+vRmwzk0lnnn8aCwz8lBMIji4vNlrtp8b
	 Lx1UU9J8X8074umv/BfyAt1BBAoHlWiEZ5KnYEqHYBMrN5xnOyaDMAiiCShx/ZN9MR
	 Fw+HmWo+fxtitPl/E1PoNlqAjvpHfUer4dDA7YAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/294] speakup: Fix 8bit characters from direct synth
Date: Thu, 11 Apr 2024 11:54:03 +0200
Message-ID: <20240411095438.094204913@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

[ Upstream commit b6c8dafc9d86eb77e502bb018ec4105e8d2fbf78 ]

When userland echoes 8bit characters to /dev/synth with e.g.

echo -e '\xe9' > /dev/synth

synth_write would get characters beyond 0x7f, and thus negative when
char is signed.  When given to synth_buffer_add which takes a u16, this
would sign-extend and produce a U+ffxy character rather than U+xy.
Users thus get garbled text instead of accents in their output.

Let's fix this by making sure that we read unsigned characters.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: 89fc2ae80bb1 ("speakup: extend synth buffer to 16bit unicode characters")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240204155736.2oh4ot7tiaa2wpbh@begin
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/synth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/accessibility/speakup/synth.c b/drivers/accessibility/speakup/synth.c
index ac47dbac72075..82cfc5ec6bdf9 100644
--- a/drivers/accessibility/speakup/synth.c
+++ b/drivers/accessibility/speakup/synth.c
@@ -208,8 +208,10 @@ void spk_do_flush(void)
 	wake_up_process(speakup_task);
 }
 
-void synth_write(const char *buf, size_t count)
+void synth_write(const char *_buf, size_t count)
 {
+	const unsigned char *buf = (const unsigned char *) _buf;
+
 	while (count--)
 		synth_buffer_add(*buf++);
 	synth_start();
-- 
2.43.0



