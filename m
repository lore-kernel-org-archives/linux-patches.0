Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4D4158218;
	Wed,  5 Feb 2025 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766411; cv=none; b=i8yLDRpr02JBGrA9ogViOE3ApxQDvYS4CYKOvKu25oAdvFQ09ArIdnXGIcX9BCeKbQ3MPSODuKWY0ao/jbMd4dRpLrYgma1Jb2PiS8jZuhMswObLDkfLtKT2VOVGN3RFZ/whYl1fz0DORI+ABCSQhvleFh7ma/mFxmLBT8ydlIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766411; c=relaxed/simple;
	bh=pdfgn/JdQAj2StbD6YaBpv+HnfC9S3hZ4K75sCEEYVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7mzNIw2rJ3tdsqaH1vp4yfNa2anGPazcbcyBoxlXkpwXuxgMorneIWUZVjcjvaIsAO9CQkI9aFPF9aqY+afCc2MPrmBfjIEJhDJ+pe+6NXrglGnzljdXVTXCpXnd4Yjm7YCb4bwpRXrymMtD5VEpqX46Uwrq0w/vUgOe2Vp+S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d82P0SyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d82P0SyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B877C4CED1;
	Wed,  5 Feb 2025 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766411;
	bh=pdfgn/JdQAj2StbD6YaBpv+HnfC9S3hZ4K75sCEEYVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d82P0SyCugXFiqUILntEtYwMld+N/75nyFhD9KBx51L29236jYYZsAm/cYzsn9ZJl
	 55PIVKYuY8bywpk/LOPvCo3OD4Ohv8vbr4Ib8exYhnMPIiJPZffOFIchm5Ra/DwiP5
	 CMIu1nqx0Gi+irD160WT0hysl76G0Zmfq77JyP/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 360/393] kconfig: require a space after # for valid input
Date: Wed,  5 Feb 2025 14:44:39 +0100
Message-ID: <20250205134434.074526086@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 4d137ab0107ead0f2590fc0314e627431e3b9e3f ]

Currently, when an input line starts with '#', (line + 2) is passed to
memcmp() without checking line[1].

It means that line[1] can be any arbitrary character. For example,
"#KCONFIG_FOO is not set" is accepted as valid input, functioning the
same as "# CONFIG_FOO is not set".

More importantly, this can potentially lead to a buffer overrun if
line[1] == '\0'. It occurs if the input only contains '#', as
(line + 2) points to an uninitialized buffer.

Check line[1], and skip the line if it is not a space.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: a409fc1463d6 ("kconfig: fix memory leak in sym_warn_unmet_dep()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 02ac250b8fe9e..8694ab1e04067 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -432,6 +432,8 @@ int conf_read_simple(const char *name, int def)
 		conf_lineno++;
 		sym = NULL;
 		if (line[0] == '#') {
+			if (line[1] != ' ')
+				continue;
 			if (memcmp(line + 2, CONFIG_, strlen(CONFIG_)))
 				continue;
 			p = strchr(line + 2 + strlen(CONFIG_), ' ');
-- 
2.39.5



