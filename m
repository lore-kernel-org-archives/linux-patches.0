Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBFB13B7A3;
	Wed, 17 Sep 2025 12:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112570; cv=none; b=GlGc/xv+MoU9BYrgeFElRw8A1FL1ow8Hjn9a+xC71N9TM1vuvfTtDD60/ppTHYR+sjlqC3cYHRx6UArWnOxlXfFDLh+fmWWSB+eFuNvnNLA/KAVS3w4uzQHvtr48WVu9x3ph0xXo1DQPl14rZYDmlAzkuMRuE6VfUr2F6abCB7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112570; c=relaxed/simple;
	bh=kFmgrcPgU667lznguS2xdter0vateGlF6gBQpsS6BOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtHMYj7ameN5h//ctTH3A2RP3RpBpnvi3METXx9b/6J6mMXXKf29QzDlPRNgrIjTO7oQP3TKEOYPsdugDzr2PJW0tScoz6cYVZt38OKP78h5R4LUPzZdFIWRya79VXuMluakKqo43j3+sezWkl0M17yGXbImF6kcB7VfMsIf088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4zSUt0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4zSUt0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73023C4CEFD;
	Wed, 17 Sep 2025 12:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112569;
	bh=kFmgrcPgU667lznguS2xdter0vateGlF6gBQpsS6BOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4zSUt0hgsPjimeoXFwiMlXvDEcHV2IQyr7/YW2zUBa09NUE9bNWYUtNN8CkZR7M6
	 qe4uhIpvNSMipFiOynvCmMpRo3fgG8//EIzhuEdVaGPMIMavqb0ydCKErsq5H1jS+9
	 VJVfxEYHiiv3AiNns83qQmzd2dFNM+DIpWlYvom0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Spengler <brad.spengler@opensrcsec.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 003/189] coredump: dont pointlessly check and spew warnings
Date: Wed, 17 Sep 2025 14:31:53 +0200
Message-ID: <20250917123351.930949272@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit be1e0283021ec73c2eb92839db9a471a068709d9 ]

When a write happens it doesn't make sense to check perform checks on
the input. Skip them.

Whether a fixes tag is licensed is a bit of a gray area here but I'll
add one for the socket validation part I added recently.

Link: https://lore.kernel.org/20250821-moosbedeckt-denunziant-7908663f3563@brauner
Fixes: 16195d2c7dd2 ("coredump: validate socket name as it is written")
Reported-by: Brad Spengler <brad.spengler@opensrcsec.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c | 4 ++++
 fs/exec.c     | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index f217ebf2b3b68..012915262d11b 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1263,11 +1263,15 @@ static int proc_dostring_coredump(const struct ctl_table *table, int write,
 	ssize_t retval;
 	char old_core_pattern[CORENAME_MAX_SIZE];
 
+	if (write)
+		return proc_dostring(table, write, buffer, lenp, ppos);
+
 	retval = strscpy(old_core_pattern, core_pattern, CORENAME_MAX_SIZE);
 
 	error = proc_dostring(table, write, buffer, lenp, ppos);
 	if (error)
 		return error;
+
 	if (!check_coredump_socket()) {
 		strscpy(core_pattern, old_core_pattern, retval + 1);
 		return -EINVAL;
diff --git a/fs/exec.c b/fs/exec.c
index ba400aafd6406..551e1cc5bf1e3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2048,7 +2048,7 @@ static int proc_dointvec_minmax_coredump(const struct ctl_table *table, int writ
 {
 	int error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
-	if (!error)
+	if (!error && !write)
 		validate_coredump_safety();
 	return error;
 }
-- 
2.51.0



