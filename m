Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DE910FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1253EC433EF;
	Wed,  7 Jun 2023 20:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169535;
	bh=HoD8pfnSJ9bfKM/4PbrabivCPKLDimTR4j8uvKoaaYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glLOybQESyiCjgo9FKoLyUNcnD000SA8ffIACSKEx6eIZIRsU6UGB2B9n/Agzxa7o
	 ybvcLu9WOsp/mgJ944Ce7qvHltc0/Db3aiBTkhFIsyMQ+RqEVT276xEWPVJLkFbfzM
	 1nbxL1kC28jyrqsEFvTJJ580QszqA23mIrQNTxIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Zeng <zenghao@kylinos.cn>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 117/286] cpupower:Fix resource leaks in sysfs_get_enabled()
Date: Wed,  7 Jun 2023 22:13:36 +0200
Message-ID: <20230607200926.906855767@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Zeng <zenghao@kylinos.cn>

[ Upstream commit e652be0f59d4ba4d5c636b1f7f4dcb73aae049fa ]

The sysfs_get_enabled() opened file processor not closed,
may cause a file handle leak.
Putting error handling and resource cleanup code together
makes the code easy to maintain and read.
Removed the unnecessary else if branch from the original
function, as it should return an error in cases other than '0'.

Signed-off-by: Hao Zeng <zenghao@kylinos.cn>
Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/lib/powercap.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/power/cpupower/lib/powercap.c b/tools/power/cpupower/lib/powercap.c
index 0ce29ee4c2e46..a7a59c6bacda8 100644
--- a/tools/power/cpupower/lib/powercap.c
+++ b/tools/power/cpupower/lib/powercap.c
@@ -40,25 +40,34 @@ static int sysfs_get_enabled(char *path, int *mode)
 {
 	int fd;
 	char yes_no;
+	int ret = 0;
 
 	*mode = 0;
 
 	fd = open(path, O_RDONLY);
-	if (fd == -1)
-		return -1;
+	if (fd == -1) {
+		ret = -1;
+		goto out;
+	}
 
 	if (read(fd, &yes_no, 1) != 1) {
-		close(fd);
-		return -1;
+		ret = -1;
+		goto out_close;
 	}
 
 	if (yes_no == '1') {
 		*mode = 1;
-		return 0;
+		goto out_close;
 	} else if (yes_no == '0') {
-		return 0;
+		goto out_close;
+	} else {
+		ret = -1;
+		goto out_close;
 	}
-	return -1;
+out_close:
+	close(fd);
+out:
+	return ret;
 }
 
 int powercap_get_enabled(int *mode)
-- 
2.39.2



