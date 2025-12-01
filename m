Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A51A306B15;
	Mon,  1 Dec 2025 11:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588613; cv=none; b=I3sQeljNDoII6KWy7Dk+VxMVl871yqIkCE/O/S5+ovBI+6sbaBHlOv6obCSzUlXQluuFznp5k/m+rAK5TOXr9bY023NVHVIMNLhY04PVvh1xy23oVEDKxKxDhGYWkwsiQS10sclT+Kv3v8SOGkBqzfDJwtBN4PWeC45KGpxHn6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588613; c=relaxed/simple;
	bh=dia4/htE/fZ45ibgzUTspHuGdrjcBhi0jtGenQunDfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+tJSff7MRRFJEWhHdmUazkFWJYuNBCpCBi5SwGCH282RlmZ2ixmiacBcmkQo3bMK5Hkh5XDMmTbPS+qVbFQ8hPEjqWQWgDbFfPHjEbeEdYFrl1TOgNB/lOJMxz8JklUBSy1MMh3bj8hUfDCRf8HDcRCoatDDanCpVeTI7iNN8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmeuW1EA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmeuW1EA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3523C4CEF1;
	Mon,  1 Dec 2025 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588613;
	bh=dia4/htE/fZ45ibgzUTspHuGdrjcBhi0jtGenQunDfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmeuW1EAYb1UgupBHXCpObWTXvswOMgNEFVbfwFTtjfNz8C5j5D7VezdfkOOC4GNF
	 pVfjDoLF9049I5P1W2ywf+duwxQvtjchwPwpP4+wgzBbIXnkFt8pmhIADvgQTvaier
	 sKCZqHbdjn7Ux/EJcnmMlzQH7NwpV/67d94TIU/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/187] 9p: sysfs_init: dont hardcode error to ENOMEM
Date: Mon,  1 Dec 2025 12:23:37 +0100
Message-ID: <20251201112245.172192470@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b304e070139ca..1dd8a735bf7f6 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -594,13 +594,16 @@ static struct attribute_group v9fs_attr_group = {
 
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



