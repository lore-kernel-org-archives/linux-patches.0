Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF48141995;
	Tue, 27 Feb 2024 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042457; cv=none; b=mhT70L87TU1rK3FolCArTeEexGHwxrNZv+S4JoCiNNSwfrTk9hVoWpHmfe7HQiCJWo6+yxvtZzVhsIuYxXcWfQjWYzLSZKK309gxhzmoG4+OG/F7OLuUyBScC/douVjChpiGozgMlwcUKTM/8kvnTcX9cerAp0TRriJpbTdLb5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042457; c=relaxed/simple;
	bh=EWoehuKT35+4Gtlv7o0yvZEDv2zEi/JwNc5pzXeUAAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhOTyC57sa1Gu9k8Lc0v73eRk440dPiWi0igwlpvexQVuw1AqXyP9Imld2r3vRGd2Nb0gmPaCTSmCno9LB/gCNSsWGyvjqj8sEFsO9pyvI10ppTKWD1jqk0cKEqx+JZx1dW9QkiqpU1zg245uB8QrG3jASfFZYii1XpX+bNSUKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpwn01bY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpwn01bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1ACC433F1;
	Tue, 27 Feb 2024 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042457;
	bh=EWoehuKT35+4Gtlv7o0yvZEDv2zEi/JwNc5pzXeUAAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpwn01bY0u+oeBHbo7NaLpEedcUJST0/7ne8u/P4C0M2ibnRJHG6wjABddKgG6iVQ
	 2IIVZYusfe3mBfxc0XoVJ+5Ta/IEtLibjQr6drqpItejq3VmmEpeYtvljZmNsJmVuv
	 tu/bDUGQQy6deAOhWmeYj+7hfLX9kUhUyVQhiBNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/299] tools: ynl: dont leak mcast_groups on init error
Date: Tue, 27 Feb 2024 14:26:29 +0100
Message-ID: <20240227131634.627970542@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5d78b73e851455d525a064f3b042b29fdc0c1a4a ]

Make sure to free the already-parsed mcast_groups if
we don't get an ack from the kernel when reading family info.
This is part of the ynl_sock_create() error path, so we won't
get a call to ynl_sock_destroy() to free them later.

Fixes: 86878f14d71a ("tools: ynl: user space helpers")
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20240220161112.2735195-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index 0a7fe6a13f7b9..11a7a889d279c 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -572,7 +572,13 @@ static int ynl_sock_read_family(struct ynl_sock *ys, const char *family_name)
 		return err;
 	}
 
-	return ynl_recv_ack(ys, err);
+	err = ynl_recv_ack(ys, err);
+	if (err < 0) {
+		free(ys->mcast_groups);
+		return err;
+	}
+
+	return 0;
 }
 
 struct ynl_sock *
-- 
2.43.0



