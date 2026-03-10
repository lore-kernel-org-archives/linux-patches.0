Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3CE2BF3E2;
	Tue, 10 Mar 2026 11:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141129; cv=none; b=ZCNiYRhNF9dJ5IZzZ1hnEk2hfSdhLVZqm/VtiWmGsmPNhfYVpzydF+qXzfnKbpEsFDUVY+rH2YW40g+ElVhvcxNLGJpsmwx8z6H36hwn1ChNQVuLMgBYxuJbLDChHUw52YgLnbGekpNAv7DCpMKzchPqrhEsfl8Y606HjSnVDSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141129; c=relaxed/simple;
	bh=eHnBqpLJDFFhmHK0niNCl4OLHx/UEX5JpwHy285dZis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfP75/kO9A89qlYLmmoA4ZgsoakguarZDLrcepI+/pr+SbW4BncTyJ6lFsphb27+C9o+t9AIZSHlxD2PwbS3vXqwSxB8SRxhYK3uEYNsl6BRlB83J6g5mp+Y8Z61kDZIL1mOrWNGpA/284XT07kZh+6oGHGVLDXZPFevbfZscgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhN1Iyn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhN1Iyn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA0EC2BC9E;
	Tue, 10 Mar 2026 11:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141129;
	bh=eHnBqpLJDFFhmHK0niNCl4OLHx/UEX5JpwHy285dZis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhN1Iyn8gU+ZdOEHR36kF1xoKQwB4lFxyk4+t6ZcXEPesYVdM7ccFSVExaoU574WH
	 2Ruj1UI+kqS8MD48zI/YfQGQ4veOj7Y+kG2RG6QhRPsxMQTQRKOmzAHKP8mywpKhrb
	 EbJe53jDO2yN7vRmIHmUjo+4BvkfwPYHnaXgMbwR7laLnP1uo9jjJ+xzOf2WQdBTHe
	 00YsScFc8Dg/N4MYQSdKF7xEx7zo6udQicKXGKPs7e8ZFCQ4xwd1cluEVcfOIKpphg
	 A3sqFR+ZVS87iX9fNJzWzm9EE4vH5vJ9h3kKKk4QxE93HhIUPG7ct1vF4Rkyj5MDG+
	 QDE+lze/jsyHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+b09c1af8764c0097bb19@syzkaller.appspotmail.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 132/311] wifi: radiotap: reject radiotap with unknown bits
Date: Tue, 10 Mar 2026 07:02:59 -0400
Message-ID: <5e56c7e7f3f882f9962bcd2cc5bf2ef587cd6b2b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

commit c854758abe0b8d86f9c43dc060ff56a0ee5b31e0 upstream.

The radiotap parser is currently only used with the radiotap
namespace (not with vendor namespaces), but if the undefined
field 18 is used, the alignment/size is unknown as well. In
this case, iterator->_next_ns_data isn't initialized (it's
only set for skipping vendor namespaces), and syzbot points
out that we later compare against this uninitialized value.

Fix this by moving the rejection of unknown radiotap fields
down to after the in-namespace lookup, so it will really use
iterator->_next_ns_data only for vendor namespaces, even in
case undefined fields are present.

Cc: stable@vger.kernel.org
Fixes: 33e5a2f776e3 ("wireless: update radiotap parser")
Reported-by: syzbot+b09c1af8764c0097bb19@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/69944a91.a70a0220.2c38d7.00fc.GAE@google.com
Link: https://patch.msgid.link/20260217120526.162647-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/radiotap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 326faea38ca38..c85eaa583a466 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -239,14 +239,14 @@ int ieee80211_radiotap_iterator_next(
 		default:
 			if (!iterator->current_namespace ||
 			    iterator->_arg_index >= iterator->current_namespace->n_bits) {
-				if (iterator->current_namespace == &radiotap_ns)
-					return -ENOENT;
 				align = 0;
 			} else {
 				align = iterator->current_namespace->align_size[iterator->_arg_index].align;
 				size = iterator->current_namespace->align_size[iterator->_arg_index].size;
 			}
 			if (!align) {
+				if (iterator->current_namespace == &radiotap_ns)
+					return -ENOENT;
 				/* skip all subsequent data */
 				iterator->_arg = iterator->_next_ns_data;
 				/* give up on this namespace */
-- 
2.51.0

