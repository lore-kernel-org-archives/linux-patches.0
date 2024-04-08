Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32DA8005E;
	Mon,  8 Apr 2024 13:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584048; cv=none; b=pd/I4rv6q4jjxFI/QxTV41ldIE14Wu2b/9WoK1VLVT2cLQWzkNeXrUeQmqXMOGo+J+xr+qVS5q14AGRysgdO48/ZPctfyr/SfKDDvBUER0uBE7pzeZ4uz2JxL59x1TjFknO1y80hLqdGpNqkSZeo7gyYohGhvGYAmGRgldw/+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584048; c=relaxed/simple;
	bh=3R3YpjTwA0veyb4iXdq93X4rRTPMC33g9VSbCExLsts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqYyyZZqJxexCWrFY6u3G7+sL9aJJmPQtpesBgPgedCB/RfxR40eJbN6XuGpjDeylMfLPM0EKobGyXWEcI7/POLEvjenOqTQ4p4oYjGmnFZVQkb0RTBQ8f2ny4IfaBgqfeaoJkZMD2ANrlxJz8FK2nYnF+ZJ3Y/gKmo/0vM98p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMDkMqpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMDkMqpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2B6C43390;
	Mon,  8 Apr 2024 13:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584048;
	bh=3R3YpjTwA0veyb4iXdq93X4rRTPMC33g9VSbCExLsts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMDkMqpD9lEfF2kjyG9zDtoIaP0lMQDpFlSyt/+b6M/hYMtRTTByzt7+gsmJ6Asqb
	 IouXNTXK72JkDPk0M9UdhzG9wpSOR37QhfwEKKgSX1Gc/NRXoD6WjqIuYJ8FOieeTO
	 1uAgYhdN/t40T6GEsDaPTeI1IUa3+P/+au0ut6V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 253/273] smb: client: fix potential UAF in smb2_is_valid_oplock_break()
Date: Mon,  8 Apr 2024 14:58:48 +0200
Message-ID: <20240408125317.305254258@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 22863485a4626ec6ecf297f4cc0aef709bc862e4 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -697,6 +697,8 @@ smb2_is_valid_oplock_break(char *buffer,
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 
 			spin_lock(&tcon->open_file_lock);


