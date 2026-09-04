Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0CE41D4D6;
	Fri,  4 Sep 2026 06:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502589; cv=none; b=CHEBWEQ3ENWOnWvfBfNFlsAhVEs6s8DmZajKrzjVGGyUAKiqw5DHCBF2YhR0Rb7ZjD4MsumbxsEVITSxHwf3meT+hWIECJlnUzElAuxut9bSOL/rQpv0voBm7ybHre+MGCNcHi/3rCw8KiHy25q52cFLGo1+dJBXU6XW1yRKSbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502589; c=relaxed/simple;
	bh=kguz8HrA2umzzq7WAAGwOf3fN5kCA03JYX6+A2XrZmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrLbssaKULE0aa2wdNs3uBpfabAGqKADEPRB6djKVEVkCMvH5VpR2hAJPlWrWAil1BpiGKHhoz1cE2oUKBOmtiisRMRfJAR3jE4U9Fy/xVQYWR2HP5mJQdes8X9y5R0QofF6qKEpe3vrhBDB+VRTteMws1fiIkbhl7qzJhkz2nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dp4cKFc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dp4cKFc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F8C1F00A3D;
	Fri,  4 Sep 2026 06:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502587;
	bh=uh1+9FUqjMaFV8b6u6qx+FsXKG3LKSVLgb4LW2Gw2oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dp4cKFc/wUrK4Z/JtSusLyaazgbLp4nfP5X2jhvxy/qZ+IffXJaX0jlJc9XR81MIw
	 YxBVwcpiaZMt2sjQhbWv5sBRHTLemc9Pcb74s6L4cskiR96dEg5wWPZxJp7JHncBqW
	 NerB9H4CjZa++3R233Gm3KcjB0XKj/IlsJXpXAuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 259/403] nvme: nvme-fc: Fix nvme_fc_create_hw_io_queues() queue deletion in error path
Date: Fri,  4 Sep 2026 07:01:02 +0200
Message-ID: <20260904045740.754951511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -2310,7 +2310,7 @@ nvme_fc_create_hw_io_queues(struct nvme_
 	return 0;
 
 delete_queues:
-	for (; i > 0; i--)
+	for (--i; i > 0; i--)
 		__nvme_fc_delete_hw_queue(ctrl, &ctrl->queues[i], i);
 	return ret;
 }


