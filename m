Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F2519BC9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6135C433EF;
	Wed,  7 Jun 2023 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170553;
	bh=jLmy0YIwg00FZkrO7Sqc6l+FN8D/FAERohoER1j45xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCm0iugIOuQqWFtcndG5CK8E8zqPXZSXxt1AJvfzKQzmoIDoTCE89YoqKybbFxHzc
	 eSoygmEoYee2PHwuCsCeO1lP8u5rIljzxvXR22qOs7Vo59t7mGN/rzfgvrNLuJveos
	 5FQf6FX/P78L6eItiV1bkEtbvCi4ZmWGukBxS5w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/225] ceph: silence smatch warning in reconnect_caps_cb()
Date: Wed,  7 Jun 2023 22:15:22 +0200
Message-ID: <20230607200918.596206763@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 9aaa7eb018661b2da221362d9bacb096bd596f52 ]

Smatch static checker warning:

  fs/ceph/mds_client.c:3968 reconnect_caps_cb()
  warn: missing error code here? '__get_cap_for_mds()' failed. 'err' = '0'

[ idryomov: Dan says that Smatch considers it intentional only if the
  "ret = 0;" assignment is within 4 or 5 lines of the goto. ]

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 54e3c2ab21d22..1989c8deea55a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3938,7 +3938,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	struct dentry *dentry;
 	struct ceph_cap *cap;
 	char *path;
-	int pathlen = 0, err = 0;
+	int pathlen = 0, err;
 	u64 pathbase;
 	u64 snap_follows;
 
@@ -3961,6 +3961,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	cap = __get_cap_for_mds(ci, mds);
 	if (!cap) {
 		spin_unlock(&ci->i_ceph_lock);
+		err = 0;
 		goto out_err;
 	}
 	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
-- 
2.39.2



