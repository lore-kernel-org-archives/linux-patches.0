Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65479352FFA;
	Tue, 26 Aug 2025 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218533; cv=none; b=MjB0iGt3P/X4ZRqsC80xlU21YghKl9te1mwCvPuuaGeIl2YuDX3qcT3jwjXkBwKKQfReHECooPWp24BMJGGcp0Xc6JEtiVzSm2tcOHRFrL4xjvJqL+ecvIBZ5QAt+78nLrmHzlHEzf6XdUhcWHCsg0/oY1crMzg4sykKyZdWxAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218533; c=relaxed/simple;
	bh=0HFmfVXWdhBTcqUmoCciQ7AxIwNvVhrZcWArk7kCKv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD6Im1ZmpDgXo7h5c2k5cy8r5jzJ/oUm+FGBeo3bW9T3YwanNkEnOmaZ5Je6Q2xsP6eF2ClxQYzDcd+JqfCvyvIWbFf1lfsnRpgpKTE/RxlEr1AuYYq8kAcAla/oGJs+l4S1aI/arPafU0C7HpExO4KVl8aROeC8aKZ+x9BoNbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRorNeCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRorNeCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C10C4CEF1;
	Tue, 26 Aug 2025 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218533;
	bh=0HFmfVXWdhBTcqUmoCciQ7AxIwNvVhrZcWArk7kCKv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRorNeCnmqdMkNVwEJ10GocQvvFoG5C9yK5l3gq7wFdD8VD5/EslLcp2nXCcivjxY
	 mCzqDSJStiuGyAs6dlLTKGQKKq2JCV/PctySyo0pN4QrTJ1AYOZtZWOyaNmEzaTSFW
	 b0GGdSg5r80oeY2zTuDtE1d/1cWf9ZxBfPYeQMRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/403] Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout
Date: Tue, 26 Aug 2025 13:06:02 +0200
Message-ID: <20250826110906.814485476@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3227956eb7417..65035d89af98c 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1368,7 +1368,7 @@ static void smp_timeout(struct work_struct *work)
 
 	BT_DBG("conn %p", conn);
 
-	hci_disconnect(conn->hcon, HCI_ERROR_REMOTE_USER_TERM);
+	hci_disconnect(conn->hcon, HCI_ERROR_AUTH_FAILURE);
 }
 
 static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
-- 
2.39.5



