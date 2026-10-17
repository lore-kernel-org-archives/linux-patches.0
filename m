Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9533B71A7;
	Sat, 17 Oct 2026 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260627; cv=none; b=WjsEUF+6ZvJMcTcXcE49a6XynPqw6IQL5oMcOM7K1UEiW6mLzido24rAOTe3pJioeMDNiT2L1PYM2gsqVA9oGs8tKqiqP1WtN8tXfrRZPOEuxj14iau0CyqG8g0QYq7ilxo9W+jooQJiJXIcd05MrRAFmo1QwPDUiWKBg9+EqyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260627; c=relaxed/simple;
	bh=nNoPfkqxaN0axqsZgVRuKsYLw/Mr5Uuuz48m6pV595Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwDXHeIYvFU2PdTLMNc8ByXwAg0Z34ISLwpKpSVuhrzc1ol41jc3hTlZ+nnKJ8qoPrksFlbQRMK+qxFRSihd78N02Sucj5o0OYeYQZh5hD7p0ozoq2c1Wu0xTFD553VuwiH8DFnqGOVZ4GrQeQ4zbbF56PosZ1cSJj7I+zRTC1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFNy7+TC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFNy7+TC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0B31F000C4;
	Sat, 17 Oct 2026 18:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260626;
	bh=GaOhj3rrTgRW6fUKDOTjqmnMTo3AfCJfGRB6G98TIzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFNy7+TCH4JmH9M8QLSAuGVupSZWZ+KOqTVgRZYwTmDSJwRZy8lt8WG0DKNxjvamB
	 HdxZCltMWW7e+1goOAgT4Rt1RnNIt7QOouk1ogZGV3vRQN742Cm83jW/NRzo7fEQNR
	 /SsvsQMypFpcqsx+vGZ55zfs83AsfNpQASc6EdFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1607/1674] path: add cleanup helper
Date: Sat, 17 Oct 2026 18:04:39 +0200
Message-ID: <20261017160512.333979002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit ff2c570ef7eaa9ded58e7a02dd7a68874a897508 ]

Add a simple cleanup helper so we can cleanup struct path easily.
No need for any extra machinery. Avoid DEFINE_FREE() as it causes a
local copy of struct path to be used. Just rely on path_put() directly
called from a cleanup helper.

Link: https://lore.kernel.org/r/20240607-vfs-listmount-reverse-v1-2-7877a2bfa5e5@kernel.org
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: a7c1290eef60 ("configfs: pin the symlink target's dirent instead of chasing ->ci_dentry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/path.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/path.h b/include/linux/path.h
index 475225a03d0dc..ca073e70decd5 100644
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -24,4 +24,13 @@ static inline void path_put_init(struct path *path)
 	*path = (struct path) { };
 }
 
+/*
+ * Cleanup macro for use with __free(path_put). Avoids dereference and
+ * copying @path unlike DEFINE_FREE(). path_put() will handle the empty
+ * path correctly just ensure @path is initialized:
+ *
+ * struct path path __free(path_put) = {};
+ */
+#define __free_path_put path_put
+
 #endif  /* _LINUX_PATH_H */
-- 
2.53.0



