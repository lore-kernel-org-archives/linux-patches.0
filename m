Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF986AFAE;
	Thu, 13 Jun 2024 12:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280174; cv=none; b=BAO6Dj7lNuXLRZXZwLYndMsI8EuQaHebguVgsWGKnhWe8bUsBx6V9Ykqi12f3myiI8LWOkH67SBDnWMQVNrEPoLtsFpbe4IVNbxgdoekIfcHIH48QV+x9dIK0eo/wtKH2QeSfKYhwyxa/t1ZUIfXZuMHPnfiig/+ZO9yBNZJBiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280174; c=relaxed/simple;
	bh=y8AHKljJ+a9XxBrwh0kZhsMzHKptfwiIZ7vscqYYUBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWYFW3qbH66mub6o/Fq0pdQqqHhBH3CXTaLk9qIxCA9dLJlFfZLuVD+JHE8hGlcpuf4bGhG9vj3skseahiWQR/7osJpLv7WIsQSvlNqKm6EmrQFUbqCLAmuYF5GQjvbe7yRrS9co+h5FYDRodGSjgL5vgzKvP/Xg6gZXGtsyloM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBEakVfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBEakVfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F18C2BBFC;
	Thu, 13 Jun 2024 12:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280174;
	bh=y8AHKljJ+a9XxBrwh0kZhsMzHKptfwiIZ7vscqYYUBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBEakVfwCDGEhxuNujS/KgDOPfmJmg6kPjKex7KiQayi7wpcUG17nkdcrn9zCe4rj
	 kA7zQHMqYbGevjfeUFCfiRk/59Jf8fHPqSGYHH7+WM3ZFs8X57J7xgLRtutul4XpGX
	 tXq+xAyV67uMVSn84gmqC4AzD/XhaVXSsuyVtfg4=
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
Subject: [PATCH 5.4 168/202] afs: Dont cross .backup mountpoint from backup volume
Date: Thu, 13 Jun 2024 13:34:26 +0200
Message-ID: <20240613113234.227380704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,6 +146,11 @@ static int afs_mntpt_set_params(struct f
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


