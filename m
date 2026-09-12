Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6A13385A5;
	Sat, 12 Sep 2026 13:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218552; cv=none; b=dqlPyA+aAPJUD6cMRtd2mJ4OQDf0F6saeLiJOTqLu3E/05DxJSwW7MLlkSQIWydOapl6wYikxDK7WE+Gqss1TBziD1Rx7BAPuqPNtkjsCNouFv2SDKiu63bDJixu69ZUZUaoqIty3alC4LpG90q1kDW7yiGYkCnEaJYmu0JYjdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218552; c=relaxed/simple;
	bh=CCFyIbt94wnYXdYZa/GADKe0sJIBqfJ7STbjn1F2na8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNgvHcrEylI+Q6YXWDWAEuMqYVV6QmspuulCzLonbuyAP8mivirNZI9IGZVqcFAMXhI6bnbgG4j08939PnKLqjUvSlH5Pb82rgDPV2nOWqhoaImHccQPJaDE8BTDRfogvM1AGPJAkh6jd2OdhNYvWECFifrtSYPIbegtcTZ13E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKp8ak6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKp8ak6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7781F000FF;
	Sat, 12 Sep 2026 13:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218551;
	bh=mcU8Mev2mfojK3w+wtfEY1piEvTw1p63w1AWmaBx6mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKp8ak6zbcNnZNIyAfAr7q78Zt2UwLT+F0Qr6NuksEYDu9y516PNKT06m8MDOKIha
	 QUC+n/h6/kyon2GhmSVZjepaIuaGFE/wAaqoJzxXlwu/O+ptqEY45JLu3W39bO2CdP
	 iDYXYk5eXko0j5yblL2NrUoEAfowcO5mHAiBs+Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1169/1376] smb/server: preserve error status in smb2_handle_negotiate()
Date: Sat, 12 Sep 2026 08:59:55 +0200
Message-ID: <20260912065633.605894413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 73541bd2bab77e7e8e89b1edb5d342f4190dd4d0 ]

smb2_handle_negotiate() records specific failures such as
STATUS_INVALID_PARAMETER or STATUS_NOT_SUPPORTED.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 52df4cafe8a84..ebb35e95aef54 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1169,7 +1169,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 				KSMBD_DEFAULT_GFP);
 		if (!conn->preauth_info) {
 			rc = -ENOMEM;
-			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 			goto err_out;
 		}
 
@@ -1266,7 +1266,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	ksmbd_conn_set_need_setup(conn);
 
 err_out:
-	if (rc)
+	if (rc && rsp->hdr.Status == STATUS_SUCCESS)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 
 	if (!rc)
-- 
2.53.0



