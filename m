Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C014F9F4;
	Fri,  6 Dec 2024 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498440; cv=none; b=bWX/UlyitevlUNKnfvO7gvM0BgtSkPAUpeq6kt1iPU5ltRB8X4FrgsexgKEfJ0RxEcSf2+JBm6uw0qIPpa5LHQYi2u6mUr9ikz3EnWwNftD6lZnjhr6XVYOKamSwETzA9/Py1/7djs5Ak3ub9VFmYBTKn2KfGgQP3TRGpICmL+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498440; c=relaxed/simple;
	bh=/ei4x7q8ybFPWqVw9VMtfoIbH8hJ5NihMQpktlDpA8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9p7KISBB5SQuG8vr2pgdwYEbAtiPyuH/4SRj65FGzq2P20J6GY2VO/mRJbluwa5GI+D3iWbm0sx7Ka2G+hn2dRQYTd0IYw2g6pZtASn4yaQyX7RO/eydJCnn7wgtIaEWUpllZEEzGgpjLIF4HIBHzvng9zKyEG2GPO2xuThjAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWSQJ2Jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWSQJ2Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572A1C4CED1;
	Fri,  6 Dec 2024 15:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498439;
	bh=/ei4x7q8ybFPWqVw9VMtfoIbH8hJ5NihMQpktlDpA8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWSQJ2JgJFxTXPVR4j3yCNpKDZnsWc33ZnOPS9NTSb+kUBE77Cw30cSo8qSQB8BcW
	 JQCs7BxtGnc+qDoskMdzzpTMML5mpEBOFULMckNLd3/FhEU1JloLlpvrmQj79vQgOn
	 TfX1nGdRrdmhzZ7QuIseZl3BKEhGOHWS+pB/31bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 584/676] modpost: disallow the combination of EXPORT_SYMBOL and __meminit*
Date: Fri,  6 Dec 2024 15:36:43 +0100
Message-ID: <20241206143716.181602852@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit a3df1526da480c089c20868b7f4d486b9f266001 ]

Theoretically, we could export conditionally-discarded code sections,
such as .meminit*, if all the users can become modular under a certain
condition. However, that would be difficult to control and such a tricky
case has never occurred.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: bb43a59944f4 ("Rename .data.unlikely to .data..unlikely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 0426c1bf3a69c..c4c09e28dc902 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1176,7 +1176,7 @@ static void check_export_symbol(struct module *mod, struct elf_info *elf,
 	    ELF_ST_TYPE(sym->st_info) == STT_LOPROC)
 		s->is_func = true;
 
-	if (match(secname, PATTERNS(INIT_SECTIONS)))
+	if (match(secname, PATTERNS(ALL_INIT_SECTIONS)))
 		warn("%s: %s: EXPORT_SYMBOL used for init symbol. Remove __init or EXPORT_SYMBOL.\n",
 		     mod->name, name);
 	else if (match(secname, PATTERNS(ALL_EXIT_SECTIONS)))
-- 
2.43.0



