Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE15C26ED4A;
	Tue, 11 Nov 2025 01:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824610; cv=none; b=lTu7QeGTSmd57iXuqk1AQwlhI1fXbEMxRK1WpsVd/lO9b0yqqkFBKe7vg6jHz8BFDzQGyuRUH2ORnBCtYOTGgtmPyyehh4+6JvKkjGdU7KJwuxubquTBQoJSv4CsOPcvE5JNcu/Ypxh9WrUq1csXhi7HtWIBSTVU4YafdUtw8v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824610; c=relaxed/simple;
	bh=pbxF12dU4kM9r60W70vVzYGjiXw5/iSALZEFNe8WUYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQV6AfdV4XnVbSZeVboYk/W9J5llTotjTtd6ccmKFkyrp5uRRofMXpMrixlxQoZ8sfVXjnN7ePDhjKRP3Tny6b9QaQHahyxQ8nvyiqmYqfd/syWm3Hxc5rMMebwRFD3aUjtWDh1YDKP25tgKHQ+NZNJofibPeYmp/rK8VXyrSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FN+jecV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FN+jecV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E47C16AAE;
	Tue, 11 Nov 2025 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824610;
	bh=pbxF12dU4kM9r60W70vVzYGjiXw5/iSALZEFNe8WUYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FN+jecVVIBOam7s0FBFQUqe7rCewk+cR45LH/mQie4YgOGFv6fZJa4kRb2ySYieU
	 JjXecjqntmvv4K5Hpn0IRHKnobvRvp0Gzklixor6cwfP1QlINMqlRGJMy2j12rXTN8
	 faVzISg+3wbtuhmUfVr7Q2baLGn7HgOBfReQxmSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/565] 9p: sysfs_init: dont hardcode error to ENOMEM
Date: Tue, 11 Nov 2025 09:45:35 +0900
Message-ID: <20251111004537.694728044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e35b30534787d..ccf00a948146a 100644
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



