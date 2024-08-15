Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8185919FA89;
	Thu, 15 Aug 2024 13:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728861; cv=none; b=MSMmXSHgaM0n2XKddZUnF73olWId7CctlO7w9HvQrusq/Ew2mCGK6NUNOUu6LCEchSgT+sYPdj7SA2z4LE2BNO193/rPDDWuVdx+2y2dQdsh5eDAPq0gwFeypo5XMAiNUY8gbHlU4iZcT5OHqbXNBiI0v/JLrRFtlgDpo5XyQd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728861; c=relaxed/simple;
	bh=m2TC03FeHyh2vO0dT4glFcMpGlmttuCElWZ74wA3xDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4nIvdbqGGgXAwcXq0ihEzB7XGs+/Tqm2eowMoPc29MG1dq2O6TYMHvqoZmu/1CCgkKSpU+i/h/+tmtIuDhYTbX/YMtNvL/s2ZmoT/MCJBK8jmUf2PwWSh9HlpnzQ5gZShKNLmeUxxRLwC/q3W+8fkwrYOMn9NEzJwuk3AzfocA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrkwHph7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrkwHph7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DBFC4AF11;
	Thu, 15 Aug 2024 13:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728861;
	bh=m2TC03FeHyh2vO0dT4glFcMpGlmttuCElWZ74wA3xDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrkwHph7GT0aCtpNUhniT0SIpCJwTKTvSrXPNgVV4EFi70uYR6iAQAUsV+pd7sdYo
	 7J2o+05pzrrwFiatBFT0YTcAjDcI1Sz4lZbRvtkwajiGECW+JrM/Dv2K6NtOq4ZkwJ
	 yiZgpnTSakTumASx2kxpn70Ygx2A7u45RRaUeMyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/196] Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()
Date: Thu, 15 Aug 2024 15:24:10 +0200
Message-ID: <20240815131857.163126390@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit c531e63871c0b50c8c4e62c048535a08886fba3e ]

Add missing call to 'l2cap_chan_unlock()' on receive error handling
path in 'l2cap_conless_channel()'.

Fixes: a24cce144b98 ("Bluetooth: Fix reference counting of global L2CAP channels")
Reported-by: syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=45ac74737e866894acb0
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 3f9b2b4a62ffd..ca225c1325237 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7055,6 +7055,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	bt_cb(skb)->l2cap.psm = psm;
 
 	if (!chan->ops->recv(chan, skb)) {
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 		return;
 	}
-- 
2.43.0



