Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063574;
	b=u4g/p1grobNAiqjrDwozlkvXHDi1sRaoOEJcjGHDM5prymR8SgdKAu6dZjlzsTClMMk8
	 4Jv3N3cxPSr6QcIj2IOlN5sMddp5ySUuqPk0gPiF4hLhRlMngHDgUnNDMlpdf2i4JbQQG
	 Ik1mjZ+Iue1gXUzFTgyQZarPOG1p0CrBGKQ12FlZSz5xS75hXaQa6JTPPLkFcTFBP2UAW
	 sSb9KTI0Dya4kXUnLbXabF5hmymnJniWOy29N4FMhfFk4DaCD41kfCrSWQUDQcaDwPC2v
	 M2Y6w3gCRtEtFiJrjCFI8B3khZWz6tCO9c6B/ZHU8Sx48ygbPIcbIlNGlSUErEek7CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9z6q12qGNvxghKFE0kdwXZQSgDDPGGS66KNLfQlWBho=;
	b=VUBt315GEy65fCWRAFQ1dzKmPlpcerY7t+HpY5jhGH7TfmF1A/FxkNVUDb8+Wg0HXXEZ
	 TRsogs9kaUEkWIRPNn1hdKVjBgT80LdaplrtnpgaqKvRR9Ah7slbtWJqn+ctdOFlN3QDJ
	 6K+UohRnrhF5g8ITxGGGKjdeUGhDvKv9egsLuUvEwa7ATQCCRJ2r23XfV8EAhHbkwSy05
	 +rrlJREJLxyvAHOn+JcUil2dBmYP6PZXHdDjqVb9KRaU/NkOo8IaHi91sDoNu9sbKgU5Q
	 ZZcjkZ02bGHS/v5o4llIbJqcjExoNlgM85Q6NVrIwLBgUDiXP7BAIFs/704ef9jCSCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TYrf9tj/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2D060A261A;
	Sat,  7 Nov 2026 14:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYrf9tj/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25261F008A4;
	Sat,  7 Nov 2026 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063573;
	bh=9z6q12qGNvxghKFE0kdwXZQSgDDPGGS66KNLfQlWBho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYrf9tj/Ml/Hk2ilTBUN9tAvDKeHUC63FDD262tCKivb0lGHAwhxJhqR6cUznF4Vs
	 Zh6hysNHXZYGnVkjmCx9PKY/4+ZKFQE7b3lSpLn+Z9+T7fLtzlspg2wmBwxPKhDXyr
	 +oWeH88zbqIymT9cl8kuJvB28QWchUR5WLeHVvxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 704/869] writeback: clear old wb dirty state after inode switches
Date: Sat,  7 Nov 2026 08:56:26 -0500
Message-ID: <20261107134916.797295183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit a396fe9f74ea367ae3fab2dcb70b24e83db9f0cb ]

Switching an inode to another wb updates the target wb's dirty-I/O state,
but no longer checks whether the source wb's dirty-I/O lists became empty.
The check was lost when inode_io_list_del_locked(inode, old_wb) was
removed to support tracking clean attached inodes.

If the last dirty inode is moved, WB_has_dirty_io remains set on the old
wb and its bandwidth contribution remains in bdi->tot_write_bandwidth.
This can keep an empty wb scheduled for periodic writeback and overstate
the total bandwidth used to distribute writeback work.

Call wb_io_lists_depopulated() on the old wb after the batch of inode
switches, while its list_lock is still held. This clears the flag and
removes the bandwidth contribution if its dirty-I/O lists are empty.

Fixes: f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261016115230.3640770-3-sunjunchao@bytedance.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b74a7387bea74..3025fc7ddfe84 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -534,6 +534,7 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	wb_io_lists_depopulated(old_wb);
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 
-- 
2.53.0



