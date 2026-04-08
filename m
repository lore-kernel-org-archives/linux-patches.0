Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D417A3D4134;
	Wed,  8 Apr 2026 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673766; cv=none; b=hSBuTl6WjsxT3DriccFbixFJoCXkE/QtMSLVg5SVBg4w+AOEHpyElN/pOojsr4Je8YK1noEdhJNusWj4T1aVjTTLy9o0hwWW5t9sI9b8Zu4Ev7+x3TotGe1kZdMvl+AvM4JSP4XhDgO7F3jZ7j9P+RU+1X+otIDekeHgCYpmNhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673766; c=relaxed/simple;
	bh=14/29+WYmZyhV+KqXtdNxIbMnrmiTbMdsrUC5SscGMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biLObOFNTCLrJKFAheI76QVjjVXV+4y7hHL12bn4n2N21LM2ipPjCIMqLV6CZNH05v7T2iZZhjE1iqXYltEkdkkajezrfiJ+uQNSRmxr/JU+oYzSOu4CQsTNalAO5MkSWAm67qqn8zHffSjjqrb9E4y4WcaovBr4rVqBclyydek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpeQ67bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpeQ67bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D23EC19421;
	Wed,  8 Apr 2026 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673766;
	bh=14/29+WYmZyhV+KqXtdNxIbMnrmiTbMdsrUC5SscGMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpeQ67bp/MzRHmzNLW4eIAJycydRHasWPZIXVsySVK+DpmGIfWtE2RTiwnJE1bGy0
	 jSviGj0MKS9JS3wy0/cixB8kvJJwYNc6WV/Wl3sc0mxoknW7A2VQlR0qG6yPsPHE4+
	 /M7IYh7FldSmcM7UAu4Psyp2zT50g8/irxeItANU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/242] Bluetooth: MGMT: validate LTK enc_size on load
Date: Wed,  8 Apr 2026 20:02:02 +0200
Message-ID: <20260408175930.151700173@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Keenan Dong <keenanat2000@gmail.com>

[ Upstream commit b8dbe9648d69059cfe3a28917bfbf7e61efd7f15 ]

Load Long Term Keys stores the user-provided enc_size and later uses
it to size fixed-size stack operations when replying to LE LTK
requests. An enc_size larger than the 16-byte key buffer can therefore
overflow the reply stack buffer.

Reject oversized enc_size values while validating the management LTK
record so invalid keys never reach the stored key state.

Fixes: 346af67b8d11 ("Bluetooth: Add MGMT handlers for dealing with SMP LTK's")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ba6651f23d5d0..aa114fb218b2f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7265,6 +7265,9 @@ static bool ltk_is_valid(struct mgmt_ltk_info *key)
 	if (key->initiator != 0x00 && key->initiator != 0x01)
 		return false;
 
+	if (key->enc_size > sizeof(key->val))
+		return false;
+
 	switch (key->addr.type) {
 	case BDADDR_LE_PUBLIC:
 		return true;
-- 
2.53.0



