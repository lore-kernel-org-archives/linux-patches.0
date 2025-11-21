Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D0C2F28F0;
	Fri, 21 Nov 2025 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733098; cv=none; b=qwXsR0REpzaYxuCBiF9jjCnxRjzZ+gtvSzGxJHYc04eBjMJwhVkJe6P0mHpNMueNkqqhLcqthX6Pqgqvi9tLyWVNkOHh3m1OWvSnnMjNO+uIsV3UO5NnFL4JTz/vnhuVDecSnnIRqxxfxQaio11Qn6iuciiLl+ilNPMkcLrm0gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733098; c=relaxed/simple;
	bh=I/CShgXAnpg+uSSPG3/GmzDHyl7fcRhhQEHnlSz2X/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opRoIIr0FIqERQ6bSjXLK3mrvqu91GLXvTK94P8mYhegpQ5+zGbJI3/4StIb62vQe07tfiuKUNzN90EHH7mHyFxoiktNnkdEPOr8ul2TzxWo34x+i3xQYmDZJGCCgTUV/LpaCbQMNsPLpc64IGNSwUOGLKiPPs6XvyPVeO7CcpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gujHAkUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gujHAkUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8757C4CEF1;
	Fri, 21 Nov 2025 13:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733098;
	bh=I/CShgXAnpg+uSSPG3/GmzDHyl7fcRhhQEHnlSz2X/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gujHAkUcESNFBPyAMiAh2L/QNpGg2LlRdS+MSSvV5fjSn8xjmYmnhher0ZZM3vmsH
	 769qFyHj0mgvzc8aFe06G/3DNeUmqnfDmhPOoLux5wr2+/4gVBEKi6WOnlcQPDOsrb
	 i+r2z5mBDqaWF1KKAKl13TYEl21cFRir6hU9GJOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 317/529] 9p: sysfs_init: dont hardcode error to ENOMEM
Date: Fri, 21 Nov 2025 14:10:16 +0100
Message-ID: <20251121130242.304556687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Randall P. Embry <rpembry@gmail.com>

[ Upstream commit 528f218b31aac4bbfc58914d43766a22ab545d48 ]

v9fs_sysfs_init() always returned -ENOMEM on failure;
return the actual sysfs_create_group() error instead.

Signed-off-by: Randall P. Embry <rpembry@gmail.com>
Message-ID: <20250926-v9fs_misc-v1-3-a8b3907fc04d@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index af1921454ce87..be61810cb7798 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -597,13 +597,16 @@ static const struct attribute_group v9fs_attr_group = {
 
 static int __init v9fs_sysfs_init(void)
 {
+	int ret;
+
 	v9fs_kobj = kobject_create_and_add("9p", fs_kobj);
 	if (!v9fs_kobj)
 		return -ENOMEM;
 
-	if (sysfs_create_group(v9fs_kobj, &v9fs_attr_group)) {
+	ret = sysfs_create_group(v9fs_kobj, &v9fs_attr_group);
+	if (ret) {
 		kobject_put(v9fs_kobj);
-		return -ENOMEM;
+		return ret;
 	}
 
 	return 0;
-- 
2.51.0



