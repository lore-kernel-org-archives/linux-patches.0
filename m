Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDD028C87C;
	Wed,  8 Apr 2026 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673254; cv=none; b=Oqy+VxK5XexUDnn1O1QQu55/SiZN9hM5yfTUUeXVBBca8MOmzkW8q8lW2qhBCcjYaV7wgH7xFS/3hoV7U3gQu/EsZXdrMSnulz/aS3QbmSfP/lYspa7917zQTJhn0jsDb2KfezYN+gkZxISKQHXp3v/Zaf3T+deytrJb8eitqX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673254; c=relaxed/simple;
	bh=0n1fdfU4NT53UkqRIKqnr4n8j24URz6o0xjHY10N8k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYhgiir6NMUDw/tmAyWpk0u9d49N6mID+TaYK4VJZSq4BSBZYwXIgZZbKuKugGQ1MRE8pSve1W4GctwCDgfBAWQfs8gQpOYH4+Nf17hP8ORilsEa/6IewSv7K3tiFKgZhB5ZlmOPIEK+NqmOVZEtS/3iC1G3pVyx16v2qzQ03Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wT0mvxcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wT0mvxcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FFFC2BC9E;
	Wed,  8 Apr 2026 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673253;
	bh=0n1fdfU4NT53UkqRIKqnr4n8j24URz6o0xjHY10N8k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wT0mvxcW+xLjRvUMDKVuxgEAAMLuerVdl1tfbeF7UaiuI6/NEv4aUT4tfnixKBxsR
	 wFYRomWQx0gmtyaoIubDOcmz5Pd4YdeESOH53KvefC1JHszjeQLifbAuTyflIMvEOX
	 Peh3oO5HF3rlrKlBUOQ5TTSMenQ/ShwTCMv2sE+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.18 161/277] drm/ast: dp501: Fix initialization of SCU2C
Date: Wed,  8 Apr 2026 20:02:26 +0200
Message-ID: <20260408175939.882053468@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 2f42c1a6161646cbd29b443459fd635d29eda634 upstream.

Ast's DP501 initialization reads the register SCU2C at offset 0x1202c
and tries to set it to source data from VGA. But writes the update to
offset 0x0, with unknown results. Write the result to SCU instead.

The bug only happens in ast_init_analog(). There's similar code in
ast_init_dvo(), which works correctly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 83c6620bae3f ("drm/ast: initial DP501 support (v0.2)")
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v3.16+
Link: https://patch.msgid.link/20260327133532.79696-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_dp501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ast/ast_dp501.c
+++ b/drivers/gpu/drm/ast/ast_dp501.c
@@ -436,7 +436,7 @@ static void ast_init_analog(struct ast_d
 	/* Finally, clear bits [17:16] of SCU2c */
 	data = ast_read32(ast, 0x1202c);
 	data &= 0xfffcffff;
-	ast_write32(ast, 0, data);
+	ast_write32(ast, 0x1202c, data);
 
 	/* Disable DVO */
 	ast_set_index_reg_mask(ast, AST_IO_VGACRI, 0xa3, 0xcf, 0x00);


