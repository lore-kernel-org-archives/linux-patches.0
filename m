Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B985F32E696;
	Sat, 30 May 2026 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162233; cv=none; b=d+wF+1fYyviR0bpaYPKF8LyvABc2elcvCa4C+KbDsQ/xldVrShqZrUXWWs+DbnqUzwqaJN3QnqD/Mec2YgQMKHmK144Rt8spxAko52l7XgylkjARFd49KF0c/S9nHD0tnKgyvNYeDemky8qtaL+07f1MXP0UH2mC6zYNYRtPSgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162233; c=relaxed/simple;
	bh=L2qjBaabPIyi+taUjxjvtI/I+LGAZVlDejmNxRGbh64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUK0oybkkemLTbmcXTjs6sx7s42S/Si/Wlb6Uy7lBmx+m4ZAz9aAjOWIxdkgYANSzHAtNqUM79V1IwqwpFDi5sdza+nfDWTCf7rwybyTgJqR59aRTw0aHzNo3LZpTZx8U5D1awJzEBEpnzEsTKdyZHb4klAIyXCI7Lr4dWL4jqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aULW6xzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aULW6xzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4C11F00893;
	Sat, 30 May 2026 17:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162232;
	bh=fWsZvK4rSlGHyJGYK/WaEnT3XrFPfz+VxGpAm/WP2Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aULW6xzZWyIDIRKFQ4eOYcc6rIaWQ/fWAVtW8kT/S4TsL+aIcc+N7kgj98JYBczKe
	 NOt52pLlZak8INUOKDrNW5QW/iQ7tHTsHh18pr5sC53c2PRH/AgtB8ngUg1hFJPjA5
	 XiOCqn82W6eb+XhhGqg2qAJ9eyX8yl/zIOo9B21w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 831/969] net/rds: reset op_nents when zerocopy page pin fails
Date: Sat, 30 May 2026 18:05:55 +0200
Message-ID: <20260530160323.593710906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

commit e174929793195e0cd6a4adb0cad731b39f9019b4 upstream.

When iov_iter_get_pages2() fails in rds_message_zcopy_from_user(),
the pinned pages are released with put_page(), and
rm->data.op_mmp_znotifier is cleared.  But we fail to properly
clear rm->data.op_nents.

Later when rds_message_purge() is called from rds_sendmsg() the
cleanup loop iterates over the incorrectly non zero number of
op_nents and frees them again.

Fix this by properly resetting op_nents when it should be in
rds_message_zcopy_from_user().

Fixes: 0cebaccef3ac ("rds: zerocopy Tx support.")
Signed-off-by: Allison Henderson <achender@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260505234336.2132721-1-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/message.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -409,6 +409,7 @@ static int rds_message_zcopy_from_user(s
 
 			for (i = 0; i < rm->data.op_nents; i++)
 				put_page(sg_page(&rm->data.op_sg[i]));
+			rm->data.op_nents = 0;
 			mmp = &rm->data.op_mmp_znotifier->z_mmp;
 			mm_unaccount_pinned_pages(mmp);
 			ret = -EFAULT;


