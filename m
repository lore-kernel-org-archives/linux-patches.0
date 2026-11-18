Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039203;
	b=zBmArdHyfl9GgCFJ3YVojmZ7hKw8OlEh+ofCWvigS+HuMYm+YlnDLhYjTJzVFFsGgIFY
	 RsIGcA1LNzhLuPSs4lwkFcsMnXDGz7sZYoOYIXLEYn+31qX1ysfIsVmzeYE1rOk5mrbP4
	 WHFSDY2yFRkgk1Puc5w+I7tsDz71flatCEO77ABIkU4/pWFdj/b46LoKKxkd0oOINmdiw
	 3U4KtMTup6zaQO/fmonStB2AGjis4sPK6mD0gCJLXL0z3XjdNPztXl9UUAfGMtEzxruzy
	 VySB3BA/rgj2XXcQG59yjx6TaqH2mEg+AKVVPxFI6LQW/GQk5Z95pH2R9wr/xTGtd0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wvmJpnnccqMBf582eWkN+XPdRyw+brrwhNCn27GFkKo=;
	b=RMD97/nO2npWyWedtUCNMZZdN9qPDkTs+wMhlk7RoWPaUur6ojZ4R1VOQokGtnRrzQVd
	 fpkN5vsgZni/9YtZI2ugGosVnn2rI/S64isj1dTMjblTRBYiPebkQUDRLJo6dqwncyMr5
	 5dl3Qu3QRM+wwnhtRvAnl8tdIObQeDCz4hDpnueF97gsjNXtA/f//WG1wqQZWS+22mlSg
	 E52aM37VN/kAtTMVsDOacswQdorei9UcUBkZIos88IwKOe+4rU4ygWSrLKkT/CGx07X1m
	 hzIgRzLwNa2wy3Q26gdEjxMQ59bMsAdI250Wk+kSSxGr5N0H5RaSLKB/UkTf5nZyfqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixRcP5wo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E763606A32A;
	Wed, 18 Nov 2026 22:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixRcP5wo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A837E1F000C4;
	Wed, 18 Nov 2026 22:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039203;
	bh=wvmJpnnccqMBf582eWkN+XPdRyw+brrwhNCn27GFkKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixRcP5woOsk9tTqS/ui8fOybEHzfb4jJ3uURBUFFFCF7f3f6mz2x5W19ZO8luoxuh
	 Kiq0igNUTDLnGowcMsg3PSb4OsCdqCp9YSL+MtON5kEebkQfa2PO5j7qJlZCRk8D8C
	 CmaHRI7Xh76loM43R5X03N1h29+8qOzxL5lW9O9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2017/3318] lsm: dont call security_backing_file_free() multiple times
Date: Wed, 18 Nov 2026 15:43:59 +0100
Message-ID: <20261118150422.551960286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cai Xinchen <caixinchen1@huawei.com>

[ Upstream commit 3a84fc1a21577dbc8da7e4b6a49c9d8b07c07000 ]

I found the following path:

alloc_empty_backing-file
    init_file(&ff->file, xxx)
        -> file_ref_init(&f->f_ref, 1); // only 1
    error = init_backing_file
        -> security_backing_file_alloc
        -> rc = call_int_hook(backing_file_alloc, ...)
           if (unlikely(rc))
           	security_backing_file_free(backing_file); // first call
    if (unlikely(error)) {
        fput(&ff->file);
         -> if (unlikely(file_ref_put(&file->f_ref))) // zero
                __fput_deferred(file);
                 -> ____fput -> __fput -> file_free(file);
                 -> backing_file_free(backing_file(f));
                 -> security_backing_file_free(&ff->file); // second call

Currently, only SELinux has the lsm backing_file_alloc hook, and it always
return 0. When security_backing_file_free is called for the first time,
the blobs pointer is set to NULL. Therefore, double free will not occur in
the code.

Fixes: 6af36aeb147a ("lsm: add backing_file LSM hooks")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
[PM: subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/security.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/security.c b/security/security.c
index d90507fd008e7..517bd61269456 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2709,9 +2709,8 @@ void security_backing_file_free(struct file *backing_file)
 {
 	void *blob = backing_file_security(backing_file);
 
-	call_void_hook(backing_file_free, backing_file);
-
 	if (blob) {
+		call_void_hook(backing_file_free, backing_file);
 		backing_file_set_security(backing_file, NULL);
 		kmem_cache_free(lsm_backing_file_cache, blob);
 	}
-- 
2.53.0



