Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B963352071;
	Tue, 26 Aug 2025 14:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217166; cv=none; b=SpC6nLcQcN8LJ/H8ZtgdkDVbQXbDczoLFldkY6HrtmpN0YFfnW9M77Ure88p2vX1KrsXv0epvKL2lzEDoX0HRnpWsqDTvAKF+6YIQmzzoWNOQKPBhztyJCeVRco5e/bI0B56H2Ntwz4PQRVgU2xnMg3fGq87arl6j4TpPBes6rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217166; c=relaxed/simple;
	bh=W/smZtKZ0MEhCIR+MpC8XwO7WCS4qaNVywDs2cZh/GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLbGcX8pG5yNIYKmPuOX9ddOwQ2IssPmtYxGjrjufHmXpRX1vZdKWEO/39lZ/qi/ADhL8dTex0Havru8OlOuNhXcF1UJ6FPVSQPGni0wwkp/3U03paQtT8GDLAV14x8KRCQHUFL1z4bTd/AvnqVpqqYZhm9HwnFyeKkTdxnvHj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajBvyv8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajBvyv8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D29C4CEF1;
	Tue, 26 Aug 2025 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217166;
	bh=W/smZtKZ0MEhCIR+MpC8XwO7WCS4qaNVywDs2cZh/GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajBvyv8/g5WytNZGkDP7uBIaOBJddXOZJmwRTtspP+EGzpzDN0ijqGKEqwB52LXeN
	 U5aGTHWdIktT7S5iBPlLggypUkHYN+wGv+adh2RncvZ59w91zaVQxGfrCemYji71pH
	 e24Q2xONymY2zzjkYBfXvY1+kRadIXUPduJaawq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/523] Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout
Date: Tue, 26 Aug 2025 13:04:11 +0200
Message-ID: <20250826110925.612670535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6ef99c917688a8510259e565bd1b168b7146295a ]

This replaces the usage of HCI_ERROR_REMOTE_USER_TERM, which as the name
suggest is to indicate a regular disconnection initiated by an user,
with HCI_ERROR_AUTH_FAILURE to indicate the session has timeout thus any
pairing shall be considered as failed.

Fixes: 1e91c29eb60c ("Bluetooth: Use hci_disconnect for immediate disconnection from SMP")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 5a56e862ba13c..fc896d39a6d95 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1374,7 +1374,7 @@ static void smp_timeout(struct work_struct *work)
 
 	bt_dev_dbg(conn->hcon->hdev, "conn %p", conn);
 
-	hci_disconnect(conn->hcon, HCI_ERROR_REMOTE_USER_TERM);
+	hci_disconnect(conn->hcon, HCI_ERROR_AUTH_FAILURE);
 }
 
 static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
-- 
2.39.5



