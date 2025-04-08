Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB2726E142;
	Tue,  8 Apr 2025 12:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114219; cv=none; b=LYiQbuc5uTyE43gMdcpkT3qMhDmqciSgIHFBTGu5O+p14/ze85XjPWaLLxszFjiq81eeIJoOD2SOdI0MiH8AdBlwdCQwRlOT2zc+WoHIQJrybMJjU+4xTD38SlGya3085Y+LCXZpKIXZfQrdgbcpSp22AgHySQWo3WgXfuqKCwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114219; c=relaxed/simple;
	bh=IbttMNfJUpTFxGU9vETCRT6QJCZg1kem5ZYNor6To04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVUeODBXzi/+CnztYXclvKdREhCRMQOL4H60nT/iSpK+BW4NkF40rudDedTRgH/TeMDI8xa7RkPboy59+m8M8oFswo9ZoppHq9C+ky4nJKi5bEYfOv85PrPuvKEOzAWGoHtHoJBVH38LEohioQA6pyjoZFQKQc7l4D4zpr16p5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTmWDqgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTmWDqgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24670C4CEEB;
	Tue,  8 Apr 2025 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114218;
	bh=IbttMNfJUpTFxGU9vETCRT6QJCZg1kem5ZYNor6To04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTmWDqgjLyLLYU7+uCHoyzqhfLvMOickKL3ljjC4iSoKqRuLNBtnu8YffNY0XlAV7
	 vqz5qhEqZz6TwEaIqvFOZboWMf6gIFSs1XWkWPP33bqJSrrUE8jd/2+D8Ah94UTJKz
	 PXPAa1BVyQAUioDL7TZF5sRfFT6+1k5PscKuiZZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Schumacher <tim.schumacher1@huawei.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 025/499] selinux: Chain up tool resolving errors in install_policy.sh
Date: Tue,  8 Apr 2025 12:43:57 +0200
Message-ID: <20250408104851.874469234@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Schumacher <tim.schumacher1@huawei.com>

[ Upstream commit 6ae0042f4d3f331e841495eb0a3d51598e593ec2 ]

Subshell evaluations are not exempt from errexit, so if a command is
not available, `which` will fail and exit the script as a whole.
This causes the helpful error messages to not be printed if they are
tacked on using a `$?` comparison.

Resolve the issue by using chains of logical operators, which are not
subject to the effects of errexit.

Fixes: e37c1877ba5b1 ("scripts/selinux: modernize mdp")
Signed-off-by: Tim Schumacher <tim.schumacher1@huawei.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/selinux/install_policy.sh | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/scripts/selinux/install_policy.sh b/scripts/selinux/install_policy.sh
index 24086793b0d8d..db40237e60ce7 100755
--- a/scripts/selinux/install_policy.sh
+++ b/scripts/selinux/install_policy.sh
@@ -6,27 +6,24 @@ if [ `id -u` -ne 0 ]; then
 	exit 1
 fi
 
-SF=`which setfiles`
-if [ $? -eq 1 ]; then
+SF=`which setfiles` || {
 	echo "Could not find setfiles"
 	echo "Do you have policycoreutils installed?"
 	exit 1
-fi
+}
 
-CP=`which checkpolicy`
-if [ $? -eq 1 ]; then
+CP=`which checkpolicy` || {
 	echo "Could not find checkpolicy"
 	echo "Do you have checkpolicy installed?"
 	exit 1
-fi
+}
 VERS=`$CP -V | awk '{print $1}'`
 
-ENABLED=`which selinuxenabled`
-if [ $? -eq 1 ]; then
+ENABLED=`which selinuxenabled` || {
 	echo "Could not find selinuxenabled"
 	echo "Do you have libselinux-utils installed?"
 	exit 1
-fi
+}
 
 if selinuxenabled; then
     echo "SELinux is already enabled"
-- 
2.39.5



