Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14A44F4D04;
	Tue, 13 Oct 2026 12:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895516; cv=none; b=bn9aV9V7T3dFyCZfvPKA3woSpVni2WIJ9IdQxRSLUXeKM2hDHW7S6T6kDKVw4r3EW7/t7obYfZ68CIWitQcf/sEIXxwRI128Eq43pu2Y6zwRve/Uck/Fu0ixKPzmEfHL9dSc+edYSGvLP+pTXfyG3AGrpBHNGNVsveapwBl6HyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895516; c=relaxed/simple;
	bh=QVorhjzAUff+AXStbp+PBF+V7dpyoWErUuBBsNPBt9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz5JhzXhyHy1o5HgbPgSxv8LQPinQf9OWlCV7kGaNLv0wbM9NoNCRC28EFftUWY+Q80S5KyaTLJjWcpdv9tGgoMeBNIRrvj+wFbaA1+GkInA0Iu4bY4dZMofS7Po3LPc2RCmlEPQLN79O+q7mMMrPCW7HghHORR9WMNbSrJEfxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z97gEFKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z97gEFKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71901F000FF;
	Tue, 13 Oct 2026 12:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895513;
	bh=hVqyn7Pb7aUDwWIzNavtVYRjDmXZfwwI6P5kmby+iB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z97gEFKxOeJOieb8GZqHHn8gK+9zBfYbLpVIaMzgN5zd/eSwwxu5fnhsIMzDYRZPn
	 2b8o+txqmKoq7ygGnReAv30EfgzEdoXsC95lJuK8ZwRQyhn7zJXo0G/0IHS/kJU9yw
	 OxDGL2HQ3wIsdj/UM9Sm2+Yd6Pf8DsA7a31GfnbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/497] tty: introduce tty_port_tty guard()
Date: Tue, 13 Oct 2026 13:37:47 +0200
Message-ID: <20261013112915.018279163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit e8398b8aed50382c21fcec77e80a5314e7c45c25 ]

Having this, guards like these work:
  scoped_guard(tty_port_tty, port)
    tty_wakeup(scoped_tty());

See e.g. "tty_port: use scoped_guard()" later in this series.

The definitions depend on CONFIG_TTY. It's due to tty_kref_put().
On !CONFIG_TTY, it is an inline and its declaration would conflict. The
guards are not needed in that case, of course.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250814072456.182853-3-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 56964f6a3123 ("tty: tty_port: restore TTY_IO_ERROR on activation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tty_port.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/tty_port.h b/include/linux/tty_port.h
index 41b1c72745ca5..5e2cd738aceaf 100644
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -273,4 +273,18 @@ static inline void tty_port_tty_vhangup(struct tty_port *port)
 	__tty_port_tty_hangup(port, false, false);
 }
 
+#ifdef CONFIG_TTY
+void tty_kref_put(struct tty_struct *tty);
+__DEFINE_CLASS_IS_CONDITIONAL(tty_port_tty, true);
+__DEFINE_UNLOCK_GUARD(tty_port_tty, struct tty_struct, tty_kref_put(_T->lock));
+static inline class_tty_port_tty_t class_tty_port_tty_constructor(struct tty_port *tport)
+{
+	class_tty_port_tty_t _t = {
+		.lock = tty_port_tty_get(tport),
+	};
+	return _t;
+}
+#define scoped_tty()	((struct tty_struct *)(__guard_ptr(tty_port_tty)(&scope)))
+#endif
+
 #endif
-- 
2.53.0



