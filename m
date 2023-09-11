Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171F11170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C04EC433C7;
	Mon, 11 Sep 2023 14:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442189;
	bh=fQvMRimz4XO5aLrtd3aM1OOsSou3OSPLGafczgZSATs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLXwlzEgGhV2iaaCw7XNRbKUueLtAIan5SClTASeAcVDXR4WUKZL0pU/OaBpZ0ZAc
	 Wjj6FLGBS4JBg/aiR8nFErbPY15VRj4WHG8rRAnsF4wklIQEv1MAHN1At8caIpTVco
	 ij1ZWjUqefiTfq6APK0nkxJJOCW3q8lDnd1mQWyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ding Xiang <dingxiang@cmss.chinamobile.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.5 678/739] selftests/landlock: Fix a resource leak
Date: Mon, 11 Sep 2023 15:47:57 +0200
Message-ID: <20230911134710.037246531@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

commit 2a2015495142ee0a35711b5dcf7b215c31489f27 upstream.

The opened file should be closed before return, otherwise resource leak
will occur.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20230830101148.3738-1-dingxiang@cmss.chinamobile.com
Fixes: 3de64b656b3c ("selftests/landlock: Add supports_filesystem() helper")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -113,7 +113,7 @@ static bool supports_filesystem(const ch
 {
 	char str[32];
 	int len;
-	bool res;
+	bool res = true;
 	FILE *const inf = fopen("/proc/filesystems", "r");
 
 	/*
@@ -125,14 +125,16 @@ static bool supports_filesystem(const ch
 
 	/* filesystem can be null for bind mounts. */
 	if (!filesystem)
-		return true;
+		goto out;
 
 	len = snprintf(str, sizeof(str), "nodev\t%s\n", filesystem);
 	if (len >= sizeof(str))
 		/* Ignores too-long filesystem names. */
-		return true;
+		goto out;
 
 	res = fgrep(inf, str);
+
+out:
 	fclose(inf);
 	return res;
 }


