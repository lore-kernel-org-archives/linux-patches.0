Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DC038A712;
	Tue, 10 Mar 2026 11:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142034; cv=none; b=VbKWqIBcheAl2a4rbPY3aRmeRmfTCViHjIq1EfGTDu3R+Sm9oYpwzCajHckzTsgH9hNMPQAPYALTyOShLecMZIszsoFqnxTH/WbrjurzV9oSNGaZrCb9UPp7H+0sODDM6Vx1+Sy/Eu+sjHV1NSmb0c5K54fIlI+97XQFUTSHVwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142034; c=relaxed/simple;
	bh=eHnBqpLJDFFhmHK0niNCl4OLHx/UEX5JpwHy285dZis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABh47/ftHHaZZbcRr9qGkqTxQAGO2tVl+LnX081kXUJA9qaBwxNDJIXqTbsOWvTgtjuH7GpiWx7rTg0mzkbZYTvw4z/lD5ligjMvktlejgdXijY5WRrThwl1zMliOiuo6eR9jjkWLJ/2CN//0tgRQpIy34yYpJsPch9OQ30bYmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cphxRaZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cphxRaZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C423C2BC86;
	Tue, 10 Mar 2026 11:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142034;
	bh=eHnBqpLJDFFhmHK0niNCl4OLHx/UEX5JpwHy285dZis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cphxRaZm/WqDJDnqQozuB6q+53E7d+e+S+aqSvJd/jxheibg/jkWW1CWMQG2IHsRq
	 U0EzsZNA2SSZXkmnvT/6TzUu1FGoDL7/xxTWh3Az2qv/3fqgBlNWK7SVKKzD7amni/
	 ghIVM966Ztxe6K0o6CzwZmzHfIqysXxJLoRgDG+SCqYGKYVjUuvbEdHulLVrRimzSl
	 xBcHq7MF6IEeIVycUOP39RovlBNizidl6oPcRFvzmQGT+9OPDo20o+RSgpfQjSYlD4
	 VbrT1jQ1Eg4zH6NcBGw1K8uSiruCzL1aDUThdBbn29LtbIknW6Cdw6KqmuTOoC62y4
	 3zPfwq98hrwGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+b09c1af8764c0097bb19@syzkaller.appspotmail.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 161/314] wifi: radiotap: reject radiotap with unknown bits
Date: Tue, 10 Mar 2026 07:17:00 -0400
Message-ID: <63314f8f1874c6131a5327e3101e6d3f29bd1561.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

