Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7F41A3029;
	Tue, 21 Oct 2025 20:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077288; cv=none; b=oD/Btb27kYG9AM7lMmBhnkh6y1AoYRpmveuzp1Jjo7lAxc33V/3we4oomCDNZpQHtnzK5kjbUr9jIjOeWJ/fAbXhMTHD6Mgl1EgM2DFyyDao65II1CDE3uOsabsG/vRNR+EHjoEAiRJFaYXkFCGywUJlDGFSX2FZaHitYpRTT6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077288; c=relaxed/simple;
	bh=Zg/lizIfSnikAu/c+lAa0a+FJkeltMp54GfE9iu74QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPrgdM9B0W8Cv9Se3aB2x9mKwzYkyPsyZnoBolZtfKn74+yNi60auioWVQKNlgMN5+5HS+PGk0E3cnGxfInNXA5vx4m9E/BJtuLp1i7IX4Z/LvUWShHy02JSYLhAWQmVIe3TFH7rv8XtqP01lOeZVsCrwm/Y6fXjAhBjso5TQ9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zao+tgTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zao+tgTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BC9C4CEF1;
	Tue, 21 Oct 2025 20:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077287;
	bh=Zg/lizIfSnikAu/c+lAa0a+FJkeltMp54GfE9iu74QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zao+tgTPYdYTMqs3Uhxwob0hFOt5g0YC/Ir7KRDV91J5IrpqavrvR5e4qWtRKdIzH
	 67iJZle6tnPvMPhA3Mr1CK3M+4+Ol7RFloEnIcmBsKuiyvRxTiIKNo2qdLByytynUC
	 lApw+zwQx6mCy1gXDvGlv9L9y0qwc14QIObjTtEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Yu Watanabe <watanabe.yu@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 059/159] coredump: fix core_pattern input validation
Date: Tue, 21 Oct 2025 21:50:36 +0200
Message-ID: <20251021195044.633492429@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a779e27f24aeb679969ddd1fdd7f636e22ddbc1e ]

In be1e0283021e ("coredump: don't pointlessly check and spew warnings")
we tried to fix input validation so it only happens during a write to
core_pattern. This would avoid needlessly logging a lot of warnings
during a read operation. However the logic accidently got inverted in
this commit. Fix it so the input validation only happens on write and is
skipped on read.

Fixes: be1e0283021e ("coredump: don't pointlessly check and spew warnings")
Fixes: 16195d2c7dd2 ("coredump: validate socket name as it is written")
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: Yu Watanabe <watanabe.yu@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c | 2 +-
 fs/exec.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 60bc9685e1498..c5e9a855502dd 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1466,7 +1466,7 @@ static int proc_dostring_coredump(const struct ctl_table *table, int write,
 	ssize_t retval;
 	char old_core_pattern[CORENAME_MAX_SIZE];
 
-	if (write)
+	if (!write)
 		return proc_dostring(table, write, buffer, lenp, ppos);
 
 	retval = strscpy(old_core_pattern, core_pattern, CORENAME_MAX_SIZE);
diff --git a/fs/exec.c b/fs/exec.c
index e861a4b7ffda9..a69a2673f6311 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2048,7 +2048,7 @@ static int proc_dointvec_minmax_coredump(const struct ctl_table *table, int writ
 {
 	int error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
-	if (!error && !write)
+	if (!error && write)
 		validate_coredump_safety();
 	return error;
 }
-- 
2.51.0



