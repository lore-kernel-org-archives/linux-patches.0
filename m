Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711C2190663;
	Tue,  8 Oct 2024 12:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391123; cv=none; b=tuaD5s9vrbCmQdygjGHpi2TJSQmvWkehRBHEHumzaIw3cHdVDBXtysxVod9ZliupYwEgvuYOJMwOjuvq4fXz7XUA0nzNXubAzyPmbjmidSJvXQDXBD/Y/Fjnr5jtl7M703j9EJsSSd4dTB0SNJFLOxvDr6nLh2JwiB+kSQGKDeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391123; c=relaxed/simple;
	bh=+ChWtTeIykdYABVTvGCf7MWmIv7L6rOtW7kJ9JzjPD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VckxRe0mjta0eKHHTyY7QUR/Qevlu9nhodmiROIpqH4L4/cjdoXezlTDKPX6l9o5q3HjSGGo95fPEn8p/AcV+phhQJCjeCEiLhArmVYC52UYtiFNDOIi5tAp8nBN7H18HKYdcoHjYLSTjmCunQ0c/icW6WN3vV4FZhZ9SKc/8Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7eFzf/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7eFzf/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA56C4CEC7;
	Tue,  8 Oct 2024 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391122;
	bh=+ChWtTeIykdYABVTvGCf7MWmIv7L6rOtW7kJ9JzjPD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7eFzf/CfckOeFvFiKs8CuN3w+Q+GH+b7fAH8iKF5xYUkqJtrOJU3HK1MrCYFumAL
	 HFc0FoSWDxq9fl2klHVAWpTsrJodMIwoMbNh5uVPtvhKW8s2qJkUC72+K9MKrX6LA1
	 3FJ6cyRTpergAev5235OWv7po1rWGstEk75ofpe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 015/558] ceph: fix a memory leak on cap_auths in MDS client
Date: Tue,  8 Oct 2024 14:00:45 +0200
Message-ID: <20241008115702.822346529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 276e34ab3e2cc..2e4b3ee7446c8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -6015,6 +6015,18 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
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



