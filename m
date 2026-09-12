Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB8047CA72;
	Sat, 12 Sep 2026 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789233080; cv=none; b=mzR4Jn4s4N+eZMfEQKMgM4lJNGRkTi8YJy6Uo/rQgQ6rwCfzrD+9Ed001571ix4kTFmoDpxtbtGf6uGGuBUzhSjhfk35dLjKUF11231G4MbiilofepNHdyflYONzpc+3ScH4RuYGloMzaiI8JxKiK7p6jCAPs7fXkKonowU/X5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789233080; c=relaxed/simple;
	bh=gVFHx8iLOiw+WSzyo0AvXT8c5ryjVzu8sRk1yvqAmPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lk3hjcm248S8uLdTb7+Fk1lwQv4fnZipRDF5GO7lt/WHPZrdQd175JurU9C6h6Yy/wdPM+epkUtK4lDHWIytBhrkIlKtuNcuWvfsIcTZryEtNqlmaKiC4iNUsHmEltcxpjr9qPRyTGnZCyR9OHZEjwUCNQPqiYfZ9/l4kH+9Y44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzin702r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzin702r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214D31F000FF;
	Sat, 12 Sep 2026 17:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789233079;
	bh=7ZK4A6VlArLGnfCVzjKSq7cF6jbBltpQEDxkRbBNgak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzin702r4t9fEmADbrBD7+gJJzWE0H8FCU7Esrs8d7fzTY8n/JF1FcMmVTI+7KUOo
	 Z8aGhe/aVlMF/kOYhBCPGpD7/F9jQC8fdmvhDIOWuwStbmeBHkKZKlSvNGqUyJW84s
	 W7urJLjlCgPLOMQ5bJrNeVCAHNyhrpjQMUJVbEPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 141/935] nvme: nvme-fc: Fix nvme_fc_create_hw_io_queues() queue deletion in error path
Date: Sat, 12 Sep 2026 08:52:51 +0200
Message-ID: <20260912065530.056005658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

commit 22eb631bf86ee3246f47885e4fa94154a46863e4 upstream.

nvme_fc_create_hw_io_queues() will call __nvme_fc_delete_hw_queue() for the
last queue on which __nvme_fc_create_hw_queue() reported an error when deleting
all the io queues if they cannot all be created.  This is incorrect since the
last queue did not actually get created.

The most recent change to this code was commit 17a1ec08ce70 ("nvme/fc: simplify
error handling of nvme_fc_create_hw_io_queues") which moved the cleanup to the
delete_queues: label and changed the loop bounds, however the code was not
correct prior to this change in a different way.  The original commit
e399441de911 ("nvme-fabrics: Add host support for FC transport") had a
different error which called __nvme_fc_delete_hw_queue() on queue index 0 which
is used for the admin queue.

Fix this by correcting the initial loop index when deleting the io queues.

Fixes: 17a1ec08ce70 ("nvme/fc: simplify error handling of nvme_fc_create_hw_io_queues")
Fixes: e399441de911 ("nvme-fabrics: Add host support for FC transport")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2326,7 +2326,7 @@ nvme_fc_create_hw_io_queues(struct nvme_
 	return 0;
 
 delete_queues:
-	for (; i > 0; i--)
+	for (--i; i > 0; i--)
 		__nvme_fc_delete_hw_queue(ctrl, &ctrl->queues[i], i);
 	return ret;
 }


