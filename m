Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3888F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156B0C4339B;
	Mon, 13 Feb 2023 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300772;
	bh=OxIh3XkM/vWdjisYp1G+l5JRo3AlZjlJE2kFM2UsgVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eERU/0IW5XMtEHboyujJArGKcwOxA9rcOi5Qe4INegPVssQtchHMIYn0B0/jjE1uu
	 B4+nqgvDx/IyovE/jIT7VqzaurlCzxEfqRea0FwrlVKiPJFqybj/tKnarCAxbg0dfg
	 YtnY0WrbxJ9xArxLxwQ460achyYgANSeNLkyAk1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Venky Shankar <vshankar@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 133/139] ceph: flush cap releases when the session is flushed
Date: Mon, 13 Feb 2023 15:51:18 +0100
Message-Id: <20230213144753.001537006@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

commit e7d84c6a1296d059389f7342d9b4b7defb518d3a upstream.

MDS expects the completed cap release prior to responding to the
session flush for cache drop.

Cc: stable@vger.kernel.org
Link: http://tracker.ceph.com/issues/38009
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3496,6 +3496,12 @@ static void handle_session(struct ceph_m
 		break;
 
 	case CEPH_SESSION_FLUSHMSG:
+		/* flush cap releases */
+		spin_lock(&session->s_cap_lock);
+		if (session->s_num_cap_releases)
+			ceph_flush_cap_releases(mdsc, session);
+		spin_unlock(&session->s_cap_lock);
+
 		send_flushmsg_ack(mdsc, session, seq);
 		break;
 


