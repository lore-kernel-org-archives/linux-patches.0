Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E03E14265A;
	Thu, 13 Jun 2024 11:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279281; cv=none; b=iGH4a/mcnlSAz/VUBNNFLgnCw/fKrcUwI/PXPd0nwV9gpJIb0uk7BrWItFbZ/m3TiNasqeKeeiF0p6hCPc+KXbQRhQRbFQ7BH1Pe7MB96MpK5778aQxewZpQ5cSirMgvXHa5S3fzbC6EQNhyagRC0+2mKjvLRxQsr18vLDHA/aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279281; c=relaxed/simple;
	bh=XwTQpwIoJjs+VzvUKZXkINsfmL4hRTbZbdgc++NxqDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf6dmO3yvo3mmtPhXk7TlxO2TSBtyVn6cnf6H2392xvxYesFTEvzItREemp8B3odiVMwt+saBSvpZxb6WdnxHr0h7YpQ8thKnIuC0z9QI6qoeJx/23YiGo9JBijeWe6zzCQt15kCQKHun7HWjt+AgmsxHocs6PUJYamhsu2LgLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjsfD6kW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjsfD6kW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9949CC2BBFC;
	Thu, 13 Jun 2024 11:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279281;
	bh=XwTQpwIoJjs+VzvUKZXkINsfmL4hRTbZbdgc++NxqDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjsfD6kWAf/h6ZlVy9x97lpdCwwlTgi7bwhbuvY3aA6VyOx1FPQJ7St1J9TpX2PXl
	 N6px46ejGSZDSVWR+MZZjV+SZOQt0dAj+5vLkOeekL+KUL3FIx+qFvF0Lb8HNRBvmB
	 G14uFqX0yI0jNLWNwumFrFpBf7+cKQnJkSNUE1rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Henrik Sylvester <jan.henrik.sylvester@uni-hamburg.de>,
	Markus Suvanto <markus.suvanto@gmail.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.9 003/157] afs: Dont cross .backup mountpoint from backup volume
Date: Thu, 13 Jun 2024 13:32:08 +0200
Message-ID: <20240613113227.530125914@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Dionne <marc.dionne@auristor.com>

commit 29be9100aca2915fab54b5693309bc42956542e5 upstream.

Don't cross a mountpoint that explicitly specifies a backup volume
(target is <vol>.backup) when starting from a backup volume.

It it not uncommon to mount a volume's backup directly in the volume
itself.  This can cause tools that are not paying attention to get
into a loop mounting the volume onto itself as they attempt to
traverse the tree, leading to a variety of problems.

This doesn't prevent the general case of loops in a sequence of
mountpoints, but addresses a common special case in the same way
as other afs clients.

Reported-by: Jan Henrik Sylvester <jan.henrik.sylvester@uni-hamburg.de>
Link: http://lists.infradead.org/pipermail/linux-afs/2024-May/008454.html
Reported-by: Markus Suvanto <markus.suvanto@gmail.com>
Link: http://lists.infradead.org/pipermail/linux-afs/2024-February/008074.html
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/768760.1716567475@warthog.procyon.org.uk
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/mntpt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -140,6 +140,11 @@ static int afs_mntpt_set_params(struct f
 		put_page(page);
 		if (ret < 0)
 			return ret;
+
+		/* Don't cross a backup volume mountpoint from a backup volume */
+		if (src_as->volume && src_as->volume->type == AFSVL_BACKVOL &&
+		    ctx->type == AFSVL_BACKVOL)
+			return -ENODEV;
 	}
 
 	return 0;


