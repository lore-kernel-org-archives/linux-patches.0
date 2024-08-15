Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FDE7DA78;
	Thu, 15 Aug 2024 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728749; cv=none; b=muOvzjAbEucH+yoU2xbS68fo6cQafjacDJvjehq/Vdae9bLD1Sx0mObYdxSdpX0s4dxf+0SmxhGG14XksccGdetykgV3KHYEz8ElwiIAJsOitVeIm6uJ6/iXWhE0NwO3REEEqVpes4SglQLisb4QpF/005dVszWTX/PWB5tbOmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728749; c=relaxed/simple;
	bh=pp0MVBRFQUwtFoImPcTLOHxrK1v+Dc4OquyykWEGB4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWzHncjerikhfWBzrwhBEYDS387tT4zPOzIJPrJmu2Gh/aw7YJRrYVkrpjFwW0LJlK+PtnVfx2Sj69Bdsnp8wfhsJ/e9vsSL4HBuB1JNoiE37IA/kuYTgktR3XkWpWvs4lPukuYlpY3DgJ+YnnTSb6rB22AY+3+7WmdOHn/JZLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoUF2r7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoUF2r7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAADC32786;
	Thu, 15 Aug 2024 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728749;
	bh=pp0MVBRFQUwtFoImPcTLOHxrK1v+Dc4OquyykWEGB4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoUF2r7z9uLyczOLBpAyvxDuLMv+CrCz3ZIamyKl4O/sywFVat/vWnoCSaEa0xHGe
	 gvXZBfBX7cJ/iyfbIbdujNH4TtDi+wD1m46Wgjr3LGR7AAvKyx2hBnGr7dfIkdq0Hp
	 Xc9DIyRs6XXShmdIHDoZwyhXkmrVM3AgK0CUQM4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/196] kdb: Use the passed prompt in kdb_position_cursor()
Date: Thu, 15 Aug 2024 15:23:34 +0200
Message-ID: <20240815131855.793546854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e2e821095949cde46256034975a90f88626a2a73 ]

The function kdb_position_cursor() takes in a "prompt" parameter but
never uses it. This doesn't _really_ matter since all current callers
of the function pass the same value and it's a global variable, but
it's a bit ugly. Let's clean it up.

Found by code inspection. This patch is expected to functionally be a
no-op.

Fixes: 09b35989421d ("kdb: Use format-strings rather than '\0' injection in kdb_read()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240528071144.1.I0feb49839c6b6f4f2c4bf34764f5e95de3f55a66@changeid
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 9ce4e52532b77..bfce77a0daac8 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -192,7 +192,7 @@ static int kdb_read_get_key(char *buffer, size_t bufsize)
  */
 static void kdb_position_cursor(char *prompt, char *buffer, char *cp)
 {
-	kdb_printf("\r%s", kdb_prompt_str);
+	kdb_printf("\r%s", prompt);
 	if (cp > buffer)
 		kdb_printf("%.*s", (int)(cp - buffer), buffer);
 }
-- 
2.43.0



