Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76E1334367;
	Fri, 21 Nov 2025 13:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731629; cv=none; b=V7Y0jKj4vzG5ivf2M2rxEVMMr9mD1lIOSliWA7Kp07ARBvftwqNfD3naBBvtVTU87fJW4vF7vfxcjiAkR46pHDst+27MtDb9lmfsJNXwhEWk0vUb+X47As7wwu/HHEmMkCsnQU3vgVeCyLpExcO8ETHJ3x7P44ik+AJ7Kpc9EKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731629; c=relaxed/simple;
	bh=HYrUEAVXZqgCx8jMSR2Ifk2lGrFkl5+1qyfhMtMgrYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qslb59IGjk7lbRmMV2KbWBlwDYEMYlmSXu64DwiDyQ8bz/i5touyBAXbNfsm7xk+NWvjgaiH/jt9lIQCygymV0RTLUaVY2/fu13rom83cX2zUWq2poGOpJnfL83pPXhlGVfU3y5ijAh0henZD2deW2hdb/V4odhAOmW2/qzriIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdmIdmQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdmIdmQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9ADC4CEF1;
	Fri, 21 Nov 2025 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731629;
	bh=HYrUEAVXZqgCx8jMSR2Ifk2lGrFkl5+1qyfhMtMgrYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdmIdmQXEKbKEmHRIBmdbSVR6w+1sx0y5dW1qWzdaq8xRjr8W/IpTiPKlghY+1WiR
	 oB07MnjMb8hTHZrlOAPwwCXZaAvFtATL6Pw4ro3J9Rld0fOGFkkFXZunWBSIsWgme4
	 RqIWehqUf4fMf3hp4SwULC2mxSTqoOPv4Vtxnx0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/185] smb/server: fix possible refcount leak in smb2_sess_setup()
Date: Fri, 21 Nov 2025 14:10:54 +0100
Message-ID: <20251121130144.854410706@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

[ Upstream commit 379510a815cb2e64eb0a379cb62295d6ade65df0 ]

Reference count of ksmbd_session will leak when session need reconnect.
Fix this by adding the missing ksmbd_user_session_put().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 67021dc6dfd81..cd42d25812661 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1798,6 +1798,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (ksmbd_conn_need_reconnect(conn)) {
 			rc = -EFAULT;
+			ksmbd_user_session_put(sess);
 			sess = NULL;
 			goto out_err;
 		}
-- 
2.51.0



