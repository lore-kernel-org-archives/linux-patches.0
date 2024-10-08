Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E311DDC06;
	Tue,  8 Oct 2024 12:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389501; cv=none; b=jcJUaz7y48W8afUvM4s3TIv/mU+0b3eKp6+hijySyytslUd3XgkikumP3q3vej93K2sC/EssAikHeqHfp3f1T066Of8aySzf2nzDuwRlcaEU7gNWtT3839DQm5xvT7jqqL93+k669rpij8uIWHzbx6k/0DEP3m/2jQz8lYJpe9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389501; c=relaxed/simple;
	bh=lOY69hwQ4ZwwA6xtoEmQWrq0NG3huJ6wz59qsPaHlxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baX/i4Y2TmKSDrtyrV5OSCnYKOj2kNUHhakZFE1hijdejkhA7rbGSPSuSDTx3G7DD2NQmaz6ndW9vEWq00F22FoWXhtGoX5/UHxN0sqjsNWck1EO2xSiWGRHsFx50j4Rrc0PoLHeHnuhnjalwf97lAOxkIxvowTtvelK3rRNbiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlB4Eugh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlB4Eugh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37016C4CEC7;
	Tue,  8 Oct 2024 12:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389501;
	bh=lOY69hwQ4ZwwA6xtoEmQWrq0NG3huJ6wz59qsPaHlxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlB4EughumKLKMmNIQDJLfogorm7uOEZ3hbmjGIgLTVZocfL3wpomMqJvSrYzJAqu
	 mIrue+hR63Sk5nMr2KL5e64FnCRmWgvpfnIqIHFD2anBN09ctyCUjqP4NU2NNHg4r1
	 P6YDA5lEfYYho97nIjaf8PDfL+sSb6+fm8RrmWZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 013/482] ceph: fix a memory leak on cap_auths in MDS client
Date: Tue,  8 Oct 2024 14:01:16 +0200
Message-ID: <20241008115648.821733401@linuxfoundation.org>
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

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

[ Upstream commit d97079e97eab20e08afc507f2bed4501e2824717 ]

The cap_auths that are allocated during an MDS session opening are never
released, causing a memory leak detected by kmemleak.  Fix this by freeing
the memory allocated when shutting down the MDS client.

Fixes: 1d17de9534cb ("ceph: save cap_auths in MDS client when session is opened")
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c2157f6e0c698..d37e9ea571137 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -6011,6 +6011,18 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 		ceph_mdsmap_destroy(mdsc->mdsmap);
 	kfree(mdsc->sessions);
 	ceph_caps_finalize(mdsc);
+
+	if (mdsc->s_cap_auths) {
+		int i;
+
+		for (i = 0; i < mdsc->s_cap_auths_num; i++) {
+			kfree(mdsc->s_cap_auths[i].match.gids);
+			kfree(mdsc->s_cap_auths[i].match.path);
+			kfree(mdsc->s_cap_auths[i].match.fs_name);
+		}
+		kfree(mdsc->s_cap_auths);
+	}
+
 	ceph_pool_perm_destroy(mdsc);
 }
 
-- 
2.43.0



