Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00DF346FCF;
	Thu, 12 Mar 2026 20:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346859; cv=none; b=BuQqoSLZBITbcpsv6TqZ/uisjZW+L7YTCKZajw0I9KWt/+6yYajtOXDOXw/b/jpBIxGwsMb5FTW4NZ0meEQ4aA/HYnIqRk8YDJIE34tXappcjJllrd1XH6+ktJVbvy0UvUemPNvy6Rm9j8OS7v4VOsnt7ejGlMTiqdZrQNZ9iUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346859; c=relaxed/simple;
	bh=M+RYzmLY48fn+t7Y6saNmaqeKQXTrZ1EMhRNSUlZcjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=As6vmZQkJLTbqQ+Xn1/aWABRXgoipK5rcJO7Y67iD1L6RtKrJGBISO/hVfgmkQZp+Svo7gQZDEbszSq5WLl4/NU3N05Zgpet2PKpl2c39SDLkYTPJcOjHrRuehzj2mmoWboIsPPGEzgFEGLoUQ3Hp+Ef5nfuK9auTO42Kt1l4EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U71S7jvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U71S7jvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F42FC4CEF7;
	Thu, 12 Mar 2026 20:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346859;
	bh=M+RYzmLY48fn+t7Y6saNmaqeKQXTrZ1EMhRNSUlZcjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U71S7jvEAcCSYAwsNrvljNX/gRxyj52Jr7/YJneY5NxLR3kiG/YqLturpmwVt2clQ
	 X9KQLEPr/qnr+O++jM/wbX6M/H6bOnWCs7MbMuRmIIWXZM8O2P/fJr1Wq8aLlbp9Gv
	 6QRTPy1NqJyZ3rH2+zMm9yBTPFHNFTOTrCGOXn3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b09c1af8764c0097bb19@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 144/265] wifi: radiotap: reject radiotap with unknown bits
Date: Thu, 12 Mar 2026 21:08:51 +0100
Message-ID: <20260312201023.458924889@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 net/wireless/radiotap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


