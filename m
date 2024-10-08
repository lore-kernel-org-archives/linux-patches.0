Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CB61D4141;
	Tue,  8 Oct 2024 12:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390828; cv=none; b=tXKE2LYZTm0kWv6QLTFnaMV69YBqFOaF2qDnPfNxuueftPcETdm6NXPXCaNPx/xiqC/BbgKg++dfKC/6/wWth796canCNWZ5fKivMDIK8F32ifZh3Bq+um/6cKDDPj4LIMlByuHsk66cJzZdMqXkoCCaEW8XuWwk3LBfldT3cCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390828; c=relaxed/simple;
	bh=q3+fpuYvAaBuIQ3r2MqIZJXsSW2Zj4kA8IuiNaxClsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+g+5qiKQTvvyZ8gEnY0PXxamPwwfw3eQUMeZpXuFF5fJ2DE4DuTfbUaVQ9EbT63qSSEJmJNGfx6tM/29oi9NL9R7l/Dsb3EqPfTQ82r5/+1p2ctUpj8aSAbOGQb+WTTqZFqdQwrI9Z9td6FulrvvTTsJmqfCvKiX6DeUND44u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Glprv8aO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Glprv8aO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E03C4CECC;
	Tue,  8 Oct 2024 12:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390827;
	bh=q3+fpuYvAaBuIQ3r2MqIZJXsSW2Zj4kA8IuiNaxClsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Glprv8aOlpQ3N/Z6gq4/wTw6Bk6CehtYdL98eX7HZs8pcrxKfusBCarcasKuNv1Jq
	 Hxw0Y7z8EWJvHiReVMNVq/y7Yz+iUGQZYBkV0wyUSLRlZso6WtxyDg4uaLQOa4PiCs
	 yz2fEa+RroVMP20H+ORovQJuPcIBpjBAaM/D6wEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alfred Agrell <blubban@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 6.10 406/482] tomoyo: fallback to realpath if symlinks pathname does not exist
Date: Tue,  8 Oct 2024 14:07:49 +0200
Message-ID: <20241008115704.386740901@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit ada1986d07976d60bed5017aa38b7f7cf27883f7 upstream.

Alfred Agrell found that TOMOYO cannot handle execveat(AT_EMPTY_PATH)
inside chroot environment where /dev and /proc are not mounted, for
commit 51f39a1f0cea ("syscalls: implement execveat() system call") missed
that TOMOYO tries to canonicalize argv[0] when the filename fed to the
executed program as argv[0] is supplied using potentially nonexistent
pathname.

Since "/dev/fd/<fd>" already lost symlink information used for obtaining
that <fd>, it is too late to reconstruct symlink's pathname. Although
<filename> part of "/dev/fd/<fd>/<filename>" might not be canonicalized,
TOMOYO cannot use tomoyo_realpath_nofollow() when /dev or /proc is not
mounted. Therefore, fallback to tomoyo_realpath_from_path() when
tomoyo_realpath_nofollow() failed.

Reported-by: Alfred Agrell <blubban@gmail.com>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1082001
Fixes: 51f39a1f0cea ("syscalls: implement execveat() system call")
Cc: stable@vger.kernel.org # v3.19+
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/tomoyo/domain.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -723,10 +723,13 @@ int tomoyo_find_next_domain(struct linux
 	ee->r.obj = &ee->obj;
 	ee->obj.path1 = bprm->file->f_path;
 	/* Get symlink's pathname of program. */
-	retval = -ENOENT;
 	exename.name = tomoyo_realpath_nofollow(original_name);
-	if (!exename.name)
-		goto out;
+	if (!exename.name) {
+		/* Fallback to realpath if symlink's pathname does not exist. */
+		exename.name = tomoyo_realpath_from_path(&bprm->file->f_path);
+		if (!exename.name)
+			goto out;
+	}
 	tomoyo_fill_path_info(&exename);
 retry:
 	/* Check 'aggregator' directive. */


