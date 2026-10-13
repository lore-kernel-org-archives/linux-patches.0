Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F2E4F4CE6;
	Tue, 13 Oct 2026 12:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895395; cv=none; b=QH7oujxuB3GlHqNdQgNxm0DfixzbRBQxXPSL4wCf0xel05MgDdJTKgUCrjn/qZZ/DXtwh7mJH4kOc39Q/owR+JLoFqfJGL/NmZ817sfCDuKosr8sxmBG8EEai1ZfrLCnLptPKEoiB9ENl1Wvtx8c8C8NE+M+De57+HJcYlQ58n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895395; c=relaxed/simple;
	bh=hP1l9B4fSNhey5d5VN+/AgykbmaiPoniHWHE9A3BhB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebB5XKjPf4ekk6OxNdAuHHcxdoq0TnZF1j/tAa6RDF5TZTZKQGwapQXupbYFtxDbgFBqHVyIepiRJHoxcX108VW7vVgEhVp+dvTfbURH3/4yCaSLVYKum7mHuqllHEvIXl8O/psm/odU0ekFDiVI+bZ/yBTjqtM38n8NEWmiVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnYD3sZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnYD3sZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B771F000FF;
	Tue, 13 Oct 2026 12:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895394;
	bh=fWSKuydTP5kBeaQgzEh0Gcqe/9RcRxhyH7NTmfre4+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnYD3sZ4RWs6hxZJWGUWlrjhpOv/qmG3V29OBe5s8mz6a6WNBNWjk/Cem/pC7rEYc
	 L5ANzBeTQw7ub7O94EgozF8/OUHRoqRck6Y//mBXkj15eoetGKKzvpPseP19fqM/Ng
	 VG/JNIy8L7MwnMD9lj5y86sxTk7NGEZnVL0qoVYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/497] console: introduce console_lock guard()s
Date: Tue, 13 Oct 2026 13:37:06 +0200
Message-ID: <20261013112914.038945810@linuxfoundation.org>
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

[ Upstream commit 4847d1187402a5027d9a04393f12d52a5a1d7f98 ]

Having this, guards like these work:
  guard(console_lock)();
or
  scoped_guard(console_lock) {
    ...
  }

See e.g. "vc_screen: use guard()s" later in this series.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250814072456.182853-2-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 226bd5603371 ("vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/console.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/console.h b/include/linux/console.h
index eba367bf605da..cfc7125daf626 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -666,6 +666,8 @@ void vcs_remove_sysfs(int index);
  */
 extern atomic_t ignore_console_lock_warning;
 
+DEFINE_LOCK_GUARD_0(console_lock, console_lock(), console_unlock());
+
 extern void console_init(void);
 
 /* For deferred console takeover */
-- 
2.53.0



