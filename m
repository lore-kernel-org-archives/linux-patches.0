Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89B3310651;
	Mon, 13 Apr 2026 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098634; cv=none; b=d4H9Invphin1NQs9AIne4QvsgJJKwI77JTrAr3SuCjb1JQk5iu4DOE5o+eTqtW8gGQTMl1zgop4HLi3aAqoWlSxRejUXB8AtMqFwSfdr2zpTlayh468EHmM5qprxmoqgo2W2H5w3cIYV8TLYAIdElL7hwsX4FetQ1tm2AxyqJys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098634; c=relaxed/simple;
	bh=9feddS6LnZJmW1jyl62WpKH6+fCXtN4w7P8oUwDYUGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVsaTwA6VQcXMeqn3uT3WraDA9rzX4UT89ns5LROgh53bVzyqnrRgGbxNa6+O4r3Dbx1gwP4W422re55/ZUGlr68NYA/CbyDTJ1WSG4mhoRKra/inxvqwnsxF4KW5/glEvdTeK0lrUq3eW5KAWf2HSGX/ByC+r5Za+o9zle4UBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjo0opTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjo0opTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FECBC2BCAF;
	Mon, 13 Apr 2026 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098634;
	bh=9feddS6LnZJmW1jyl62WpKH6+fCXtN4w7P8oUwDYUGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjo0opTpvH7xZ71wOx6bbVsrUw976cjf0fgpwYVJW7V3hMi1vnISu7pxjGPiBvVjh
	 gF9DndORTwSMIPjyQDb5j86NKj42uZz6kHF6JZKh5M+P48Nb2wAsOVNPw+eyFSx8Tr
	 ifsI7Z7EInFLq0hrsTmLUVgJ/GxmQNI4Lz90pqzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b09c1af8764c0097bb19@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 029/491] wifi: radiotap: reject radiotap with unknown bits
Date: Mon, 13 Apr 2026 17:54:34 +0200
Message-ID: <20260413155820.143524958@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -240,14 +240,14 @@ int ieee80211_radiotap_iterator_next(
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


