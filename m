Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FEA2AF0E;
	Thu, 12 Dec 2024 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016958; cv=none; b=HpIcG+8Z5/zO8E2bfdF3XlSNXHh1hXoEDdYjYfMv6UG5D8frP68RdfH2Zc8VKPOsZzrhvxVob/oCZzf6nirjeKzBUw8gKQLDjqfJAsb9h7b6SgQfLnyFkVUlZ1CqkuTTQkW5hZleTcbYvQFWXRbPIOH6An6l6tN8ReSyJeSUhVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016958; c=relaxed/simple;
	bh=rlXtcwdVMPacQ3bc0PbCyAbCyPavZk4Wc0S9RdsD1oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbAyBOkuKjQXdkY4/kurMk+WYJMxpdGvMy0e835Ri7ma4lyHEKbBDTsXyOzUa8Npx6vdBNaUWmhwfzQywaAW0paYdDLlDOlmxZp2rERXliz08FPwTMJ3qaFvVGLW+olvXrCwAUc+4IyN+Ty057JEbqVK+H1ALeWRIT0LSDb7flg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fRfQAmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fRfQAmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B080CC4CECE;
	Thu, 12 Dec 2024 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016958;
	bh=rlXtcwdVMPacQ3bc0PbCyAbCyPavZk4Wc0S9RdsD1oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fRfQAmGhJ0WF0M1F5zPNe+vPbWrh1sT4E3O3b9TBX1M09bPooCtUjQAuIJc2Uk1C
	 nDLQJJ6Wphf/Fm+YNbZUkBdUCLQdpmOTpXzjq7H+VorXPbiBt1U90y8Arf81vYFVkp
	 F6iyK/9UFHZIW4d3bbxKQhAuNs6/Pa54Ta7wriKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2446dd3cb07277388db6@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/466] Bluetooth: hci_conn: Use disable_delayed_work_sync
Date: Thu, 12 Dec 2024 15:58:31 +0100
Message-ID: <20241212144320.304728303@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 2b0f2fc9ed62e73c95df1fa8ed2ba3dac54699df ]

This makes use of disable_delayed_work_sync instead
cancel_delayed_work_sync as it not only cancel the ongoing work but also
disables new submit which is disarable since the object holding the work
is about to be freed.

Reported-by: syzbot+2446dd3cb07277388db6@syzkaller.appspotmail.com
Tested-by: syzbot+2446dd3cb07277388db6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2446dd3cb07277388db6
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index a1dfd865d61ab..e6591f487a511 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1128,9 +1128,9 @@ void hci_conn_del(struct hci_conn *conn)
 
 	hci_conn_unlink(conn);
 
-	cancel_delayed_work_sync(&conn->disc_work);
-	cancel_delayed_work_sync(&conn->auto_accept_work);
-	cancel_delayed_work_sync(&conn->idle_work);
+	disable_delayed_work_sync(&conn->disc_work);
+	disable_delayed_work_sync(&conn->auto_accept_work);
+	disable_delayed_work_sync(&conn->idle_work);
 
 	if (conn->type == ACL_LINK) {
 		/* Unacked frames */
-- 
2.43.0



