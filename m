Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7767346E60;
	Tue, 11 Nov 2025 01:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824233; cv=none; b=q6k82PF6QLx40hEoBzhdQ+DGQ25wFG6zcgCKaL9kvgKzvVy1mrGDkim6KkogaX5sJURPaPuAnBJRVYCu1jMxWpfsQ5peUg8Xy14jvWlzDF2NfYpKZWEnbNWlAtxkuWlkrKs/r55WNNbdogt5MykMjOrXnp+VRW1xHN95XcbrETk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824233; c=relaxed/simple;
	bh=Zp5an3NrhkprFpl9uuxVhmPNHtuXAkfWCMrl1ouN7nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9cLFSAsCL+0W7Vr4Jk5l7LL9pPFy5xmg3jT2QAKVQZ/OQw1sf7Qom9KPUUzVfqco54cQ79TVxmfGAEA6w21Sh69aijO0bTe/y5V2erszITJp4A1vlU/oKSFq+UbgiRiqEgXwNXzYe292BsBSrXsL4MsXYd+/JRVD1YZ7f6Ihik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQrgnDNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQrgnDNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DACC19421;
	Tue, 11 Nov 2025 01:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824233;
	bh=Zp5an3NrhkprFpl9uuxVhmPNHtuXAkfWCMrl1ouN7nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQrgnDNNDdiVOLn7JYsoL215qLVkD06JXxlz/98JuR1NVDRiiaegIaIBEUg8km/4X
	 PMY0998Nr1RelqMcE4hRAwANO1Q/BadP9wtvmM0KJer6AeXMdWE9LbA0s0QbK62pt9
	 +Gmgq0I8tL8ypF0X45dPG2xPH9Lze7cwNJzP46Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huaweicloud.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 467/849] tty/vt: Add missing return value for VT_RESIZE in vt_ioctl()
Date: Tue, 11 Nov 2025 09:40:37 +0900
Message-ID: <20251111004547.721655865@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huaweicloud.com>

[ Upstream commit da7e8b3823962b13e713d4891e136a261ed8e6a2 ]

In vt_ioctl(), the handler for VT_RESIZE always returns 0, which prevents
users from detecting errors. Add the missing return value so that errors
can be properly reported to users like vt_resizex().

Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
Link: https://lore.kernel.org/r/20250904023955.3892120-1-wozizhi@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt_ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 61342e06970a0..eddb25bec996e 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -923,7 +923,9 @@ int vt_ioctl(struct tty_struct *tty,
 
 			if (vc) {
 				/* FIXME: review v tty lock */
-				__vc_resize(vc_cons[i].d, cc, ll, true);
+				ret = __vc_resize(vc_cons[i].d, cc, ll, true);
+				if (ret)
+					return ret;
 			}
 		}
 		console_unlock();
-- 
2.51.0



