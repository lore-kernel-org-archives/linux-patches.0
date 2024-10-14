Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C7F1AD41F;
	Mon, 14 Oct 2024 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918116; cv=none; b=r/k5cZXXDN2iIdUGPqEpIJCunUxzn4sWMLiwPtycSEmE0VXwYpRFe5WLKTnJtUWW5cMHDR5yPGUcz8YGRBHJUuU1W1QgQpZbRIS9rfwtUHRXo6ZlRDvU60A/djXsMN31slOZHzERl3JfPmsm/rkv5XBZ+7ZGScqK8GdSMyxAQjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918116; c=relaxed/simple;
	bh=Le9PNYitS3M0JLhgk/1JhTKoxNzHrunRwsI2PkJQU7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iuz3dMtWqrv4dDBVqJ76IIWglE6trhfmEl3vDy6qyXotClGGUazVkg0nRqd1QBkpnu6bINh8WiMtu+e/RxauL1xJiDX/xNMfdcdyOJOUiJqfXOhFspesuMuvacA9ZeEtLF6wrjDrqY1zz+ksNPVE/6kx8C0IU7QJU2D5UyWgTV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GX7GGgB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GX7GGgB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8E5C4CEC7;
	Mon, 14 Oct 2024 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918115;
	bh=Le9PNYitS3M0JLhgk/1JhTKoxNzHrunRwsI2PkJQU7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GX7GGgB4i/EolLlP0TuSTJO6fXMMLP8L8krRaTcqfoxIb3u3Ts3BanU1jp+jXDIj4
	 qVmSXaYnz9gBDc0M4a6GjWW5+eCvOaxvwBfSfHjadbk3Jp6RFLIDVWAOBHZfWAkEhn
	 Xfsbrmx/uCO4LO/F3yH57w69kZyW9+1jtDh79fy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/798] drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
Date: Mon, 14 Oct 2024 16:12:30 +0200
Message-ID: <20241014141225.629224787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junlin Li <make24@iscas.ac.cn>

[ Upstream commit 8ae06f360cfaca2b88b98ca89144548b3186aab1 ]

Ensure index in rtl2832_pid_filter does not exceed 31 to prevent
out-of-bounds access.

dev->filters is a 32-bit value, so set_bit and clear_bit functions should
only operate on indices from 0 to 31. If index is 32, it will attempt to
access a non-existent 33rd bit, leading to out-of-bounds access.
Change the boundary check from index > 32 to index >= 32 to resolve this
issue.

Signed-off-by: Junlin Li <make24@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 4b01e01a81b6 ("[media] rtl2832: implement PID filter")
[hverkuil: added fixes tag, rtl2830_pid_filter -> rtl2832_pid_filter in logmsg]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/rtl2832.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 4fa884eda5d50..c27cbddc42b7b 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -983,7 +983,7 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 		index, pid, onoff, dev->slave_ts);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



