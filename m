Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA71A1649B3;
	Mon, 29 Jan 2024 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548440; cv=none; b=QWN3FaO554YodM9ZqXWpucgwjUGYmvIVDPY6If3svLm/pfh42hSCKWPjbw7/f311p5DFqgKUv5Oprpp0c5yE2z0SNNC2yIcnHlBRwOlpG/ItrpMvHnHdAhG3FUmOzbT2uxdmGrxYxCKc6GIWGnpDoA4rnMKenmIlsjukJiUpyHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548440; c=relaxed/simple;
	bh=IKjLbheaarrlHGfrt0lDISnEYiWJba7tFGD93eVqQUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PikxyJdOmwhc9kr6q2OtCxyvUaLjmHteNNBcu7S2726zV6YAL0R5J25DJ0EQ5r9gm7QTmSnGMLFUCFXvi/xqukZ9cxIr5XDldnl4sLNeRRM8kbzZScUe8CWxW7xq1ZlfvngfZ0gXdwtgUGPbc/Jb+pZDoj/3531e5aqWgQCBe+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kr3wvD1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kr3wvD1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829D1C43394;
	Mon, 29 Jan 2024 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548440;
	bh=IKjLbheaarrlHGfrt0lDISnEYiWJba7tFGD93eVqQUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kr3wvD1nCA2CLmWJPtjI8iMpqUt6Tuyo1ie4OEivGfQzBYKPL8tMn0nThKvHBeO/x
	 bU/JBTVplC6B3IbAH8oX+JkD1cN8lNe4InCm7MrPBHuYIy97fDD4+26bVn7RNmjAl0
	 QqAOMil7CvgDFdA6o6reN/52rYntmk3ea7UFa8fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/331] cifs: update iface_last_update on each query-and-update
Date: Mon, 29 Jan 2024 09:01:32 -0800
Message-ID: <20240129170015.777093968@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 78e727e58e54efca4c23863fbd9e16e9d2d83f81 ]

iface_last_update was an unused field when it was introduced.
Later, when we had periodic update of server interface list,
this field was used regularly to decide when to update next.

However, with the new logic of updating the interfaces, it
becomes crucial that this field be updated whenever
parse_server_interfaces runs successfully.

This change updates this field when either the server does
not support query of interfaces; so that we do not query
the interfaces repeatedly. It also updates the field when
the function reaches the end.

Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked list")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 8caf2cefc8a7..e33ed0fbc318 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -615,6 +615,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 				 "Empty network interface list returned by server %s\n",
 				 ses->server->hostname);
 		rc = -EOPNOTSUPP;
+		ses->iface_last_update = jiffies;
 		goto out;
 	}
 
@@ -712,7 +713,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 
 		ses->iface_count++;
 		spin_unlock(&ses->iface_lock);
-		ses->iface_last_update = jiffies;
 next_iface:
 		nb_iface++;
 		next = le32_to_cpu(p->Next);
@@ -734,6 +734,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	if ((bytes_left > 8) || p->Next)
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
+	ses->iface_last_update = jiffies;
+
 out:
 	/*
 	 * Go through the list again and put the inactive entries
-- 
2.43.0



