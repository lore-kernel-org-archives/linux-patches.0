Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AF642399;
	Mon, 18 Dec 2023 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLj3Xxd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C374AC433C7;
	Mon, 18 Dec 2023 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908353;
	bh=JHboRZeNvG+HDIWvxLXdjx2gRnN4+QlKLU2V0bgiK7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLj3Xxd5sMz3ES1mOI03D7oBCMVNevxsJrNGDDLNl69BRF1VRoFLB8At9S9Ba1Vy7
	 EGKtnt32+AutBxC3vt74FfIrUGe/2YzebOm0ASnhOxjbNNr6aLAiSALrcpnr5iI6Zm
	 JK/6+7iKGTF9mWRu3Sol2EUdvTmzX6nPHes/2OXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 145/166] btrfs: dont clear qgroup reserved bit in release_folio
Date: Mon, 18 Dec 2023 14:51:51 +0100
Message-ID: <20231218135111.613446757@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit a86805504b88f636a6458520d85afdf0634e3c6b upstream.

The EXTENT_QGROUP_RESERVED bit is used to "lock" regions of the file for
duplicate reservations. That is two writes to that range in one
transaction shouldn't create two reservations, as the reservation will
only be freed once when the write finally goes down. Therefore, it is
never OK to clear that bit without freeing the associated qgroup
reserve. At this point, we don't want to be freeing the reserve, so mask
off the bit.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2303,7 +2303,8 @@ static int try_release_extent_state(stru
 		ret = 0;
 	} else {
 		u32 clear_bits = ~(EXTENT_LOCKED | EXTENT_NODATASUM |
-				   EXTENT_DELALLOC_NEW | EXTENT_CTLBITS);
+				   EXTENT_DELALLOC_NEW | EXTENT_CTLBITS |
+				   EXTENT_QGROUP_RESERVED);
 
 		/*
 		 * At this point we can safely clear everything except the


