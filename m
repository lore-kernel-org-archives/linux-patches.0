Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCA76A352;
	Mon,  8 Apr 2024 13:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582773; cv=none; b=hoUb+i+ppjMxz3Le87zND/6uNenqBYVPXeUFvUV+iuh3AufTzkW/Z+7+7LCJr5nTjReGuiXNNEQcY52IE8bQhzLfMyGnBtK9CMwufnZCDOjBJy+ZGD4W90SnyQ8NLUHw140onZhU0dmueR+Cq/u24rV4pWaCWdZ9FP4mJ4zNXJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582773; c=relaxed/simple;
	bh=VLoKsDDmisZ41LJbKFwe46JmbRgYOpaX8ckY+7cxdeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHc3HZYYpvggL4XwXMZ/oZVB7CujCtT1WN6XR2ElyBK4nm62dl6F1P4t04YwHRkw+J5eqKkXhW8DPEk521yJjmxFtZtUkOZGaV7PO+NG8WBi3A9+C7gdGJ9MtyphlaF2HiVovj7O+BXmn6eO19tIzpjEYHIojkGX7hM0qLycOAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+eQlSnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+eQlSnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD4DC433C7;
	Mon,  8 Apr 2024 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582772;
	bh=VLoKsDDmisZ41LJbKFwe46JmbRgYOpaX8ckY+7cxdeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+eQlSnqTcvAIMA5i3ajx8v/aHqEOvzfZVQqjU3/2Q+uC+3AFRdoYzFbcihxo1hux
	 YqlUlmaDpWVnr5IaBCdYmH0lDJK13EI+1rDAaVjMG9OntXBFV5qvF1mz4XKAGekT6Y
	 ePUiwQr2usIeHmajBBsuzULI3WUWsXj2Igq+IyM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 132/138] smb: client: fix potential UAF in smb2_is_network_name_deleted()
Date: Mon,  8 Apr 2024 14:59:06 +0200
Message-ID: <20240408125300.335599953@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 63981561ffd2d4987807df4126f96a11e18b0c1d upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2437,6 +2437,8 @@ smb2_is_network_name_deleted(char *buf,
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				spin_lock(&tcon->tc_lock);


