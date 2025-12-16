Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79884299924;
	Tue, 16 Dec 2025 12:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886421; cv=none; b=qeo1PxIBirufQJCwiknUvVrptJbwcIdF0RbnyhbUMVpW/S3d/5I/k0b3inEGE3gG0M5qtxFyvzjY/vAAfWv7ydhEZ/Kep3CI6SZomf1rebW915CsU5k9ajHtPoaH2jHvEuCBuJLt2vxx3lP9pnz1J0Rbbw9ZKk+U5SDiHbWAKqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886421; c=relaxed/simple;
	bh=vuiah4HXM923FYPg5KdN/V3QouTFYkQ3C410sWSysQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYdhYCPfDxLI7nQarCxYaezq+kmATxOQ6uvNte69uyxcUPikRIsj7QmW+VVb5yf5j0LIulyPinXDNUN81k2QEEXiIFXkZxtwsjj4T2Vugh7DsgOq4eWU8D6JcEBQggqocAGlRo8S+TNtje+V5DOrEuUOEGDnz7TnLs5KozEjR08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKGBnxxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKGBnxxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D05C4CEF1;
	Tue, 16 Dec 2025 12:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886421;
	bh=vuiah4HXM923FYPg5KdN/V3QouTFYkQ3C410sWSysQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKGBnxxfFkaBzotvj2IdOcxo3KxiHa8EmePZplAQjo4DPLCpdDS7KauyyAEQ2ywwL
	 Pu529WFQBLWgcV3krJEE7q1/Xht8gh+0x9IsEb6jT8wQ4LmtatyHgiWmwTuvQum5rk
	 aQylC+ONPptHsiAK5vyWUlHOft8ktkQ3Jxyah/bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Remi Pommarel <repk@triplefau.lt>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 432/507] 9p: fix cache/debug options printing in v9fs_show_options
Date: Tue, 16 Dec 2025 12:14:33 +0100
Message-ID: <20251216111401.110259035@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit f0445613314f474c1a0ec6fa8a5cd153a618f1b6 ]

commit 4eb3117888a92 changed the cache= option to accept either string
shortcuts or bitfield values. It also changed /proc/mounts to emit the
option as the hexadecimal numeric value rather than the shortcut string.

However, by printing "cache=%x" without the leading 0x, shortcuts such
as "cache=loose" will emit "cache=f" and 'f' is not a string that is
parseable by kstrtoint(), so remounting may fail if a remount with
"cache=f" is attempted.

debug=%x has had the same problem since options have been displayed in
c4fac9100456 ("9p: Implement show_options")

Fix these by adding the 0x prefix to the hexadecimal value shown in
/proc/mounts.

Fixes: 4eb3117888a92 ("fs/9p: Rework cache modes and add new options to Documentation")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Message-ID: <54b93378-dcf1-4b04-922d-c8b4393da299@redhat.com>
[Dominique: use %#x at Al Viro's suggestion, also handle debug]
Tested-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index a59c26cc3c7d9..9e2f8f0f82644 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -101,7 +101,7 @@ int v9fs_show_options(struct seq_file *m, struct dentry *root)
 	struct v9fs_session_info *v9ses = root->d_sb->s_fs_info;
 
 	if (v9ses->debug)
-		seq_printf(m, ",debug=%x", v9ses->debug);
+		seq_printf(m, ",debug=%#x", v9ses->debug);
 	if (!uid_eq(v9ses->dfltuid, V9FS_DEFUID))
 		seq_printf(m, ",dfltuid=%u",
 			   from_kuid_munged(&init_user_ns, v9ses->dfltuid));
@@ -117,7 +117,7 @@ int v9fs_show_options(struct seq_file *m, struct dentry *root)
 	if (v9ses->nodev)
 		seq_puts(m, ",nodevmap");
 	if (v9ses->cache)
-		seq_printf(m, ",cache=%x", v9ses->cache);
+		seq_printf(m, ",cache=%#x", v9ses->cache);
 #ifdef CONFIG_9P_FSCACHE
 	if (v9ses->cachetag && (v9ses->cache & CACHE_FSCACHE))
 		seq_printf(m, ",cachetag=%s", v9ses->cachetag);
-- 
2.51.0



