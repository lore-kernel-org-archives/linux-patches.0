Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7702494FE;
	Wed, 25 Feb 2026 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983555; cv=none; b=hpyMMYpelatgMLacoKExWVQg7Swjnqkluy+c0Vj/7Ifec0oNhwTaUku8XS9T5HxfmKxadz8EL2vAWK0SY6+JSs5ESyo1CI7PpAuPQe1C16mkNZ/zDQe2/VLTKwVK4AjW4Kpd81pudL9H+msJBJ0c9PY68/jD1xyT1y8wzRgQQRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983555; c=relaxed/simple;
	bh=yODjyLtt0Vk64uo1Ec2du4ajEmgTVBTlTiFrwQwZoHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LL9bbz3L5MoKAE8ycLQUPLAuuy31JY9UCRBiM2VNF+L+7WtHdg/k253ODezbLDYYtrxjA1wpIQIZhNx0GmpIdysk9e2xZyUkaGFUVxE5DQXsRh48DCSYFU/x07sLxXian4C4d+f4Kxkg1qaViItgATK6hbpTF9Y88oWCkWN1iwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yB7cYcYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yB7cYcYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4BDC116D0;
	Wed, 25 Feb 2026 01:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983555;
	bh=yODjyLtt0Vk64uo1Ec2du4ajEmgTVBTlTiFrwQwZoHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yB7cYcYOUcyB+yrtgWgd26Prk4ZktBXZQno6CHNPLpUP1s0/ZnF8JmkLa7Ol/NNI1
	 Gav2qj/ZbTz0OPWH2V7LSlEn0qjPkvacDJ8gfFx/AaKvbntb6ZTAvpw0xWtZQDiC4f
	 7G5+MpEPpE6+T310uJWahga6lA7MIvPmjd9nf0gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 656/781] net/rds: rds_sendmsg should not discard payload_len
Date: Tue, 24 Feb 2026 17:22:45 -0800
Message-ID: <20260225012415.879355728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit da29e453dcb3aa7cabead7915f5f945d0add3a52 ]

Commit 3db6e0d172c9 ("rds: use RCU to synchronize work-enqueue with
connection teardown") modifies rds_sendmsg to avoid enqueueing work
while a tear down is in progress. However, it also changed the return
value of rds_sendmsg to that of rds_send_xmit instead of the
payload_len. This means the user may incorrectly receive errno values
when it should have simply received a payload of 0 while the peer
attempts a reconnections.  So this patch corrects the teardown handling
code to only use the out error path in that case, thus restoring the
original payload_len return value.

Fixes: 3db6e0d172c9 ("rds: use RCU to synchronize work-enqueue with connection teardown")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260213035409.1963391-1-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/send.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 0b3d0ef2f008b..071c5dca969a2 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1382,9 +1382,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		else
 			queue_delayed_work(rds_wq, &cpath->cp_send_w, 1);
 		rcu_read_unlock();
+
+		if (ret)
+			goto out;
 	}
-	if (ret)
-		goto out;
+
 	rds_message_put(rm);
 
 	for (ind = 0; ind < vct.indx; ind++)
-- 
2.51.0



